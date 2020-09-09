from datetime import datetime
from pyzabbix.api import ZabbixAPI
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.utils import formatdate
import re
import configparser
import smtplib
import sys
import time

# Constants
SEVERITY_INFO_LEVEL = 1
ACKNOWLEDGE_ACTION_CODE = 0x02
COMMENT_ACTION_CODE = 0x04
LF = '\r'
CR = '\n'
EOL = LF + CR
CSV_CELL_SEPARATOR = ','

# Global variables
csv_cell_no_value = ''
csv_cell_multi_value_separator = ''
datetime_format = ''


# Main function. Takes optional arguments as described in README.txt
def main():
    # Load global settings from the config file
    config = configparser.ConfigParser()
    config.read('config.ini')
    global csv_cell_no_value
    csv_cell_no_value = config['Report']['csv_cell_no_value']
    global csv_cell_multi_value_separator
    csv_cell_multi_value_separator = config['Report']['csv_cell_multi_value_separator']
    global datetime_format
    datetime_format = config['Report']['datetime_format']

    # Get the date range filter (optional)
    from_datetime_str = 'none'
    from_datetime = None
    to_datetime_str = 'none'
    to_datetime = None
    report_type = 'none'
    if len(sys.argv) == 4:
        from_datetime_str = sys.argv[1]
        if from_datetime_str.isdigit():
            from_datetime = int(from_datetime_str)
            from_datetime_str = get_date_string_from_timestamp(from_datetime)
        else:
            from_datetime = get_timestamp_from_date_string(from_datetime_str)
        to_datetime_str = sys.argv[2]
        if to_datetime_str.isdigit():
            to_datetime = int(to_datetime_str)
            to_datetime_str = get_date_string_from_timestamp(to_datetime)
        else:
            to_datetime = get_timestamp_from_date_string(to_datetime_str)
        report_type = sys.argv[3]
        print('Retrieving events from ' + from_datetime_str + ' to ' + to_datetime_str)
    else:
        print('Retrieving all events')
    print()

    # Produce CSV report by retrieving events from Zabbix server, using the date range filter if specified
    zabbix_url = config['Zabbix']['Url']
    zabbix_user = config['Zabbix']['User']
    zabbix_password = config['Zabbix']['Password']
    severity_items = config['Report']['severities']
    severities = dict(severity_item.split(':') for severity_item in severity_items.split(','))
    column_ids = config['Report']['columns'].split(',')
    ticket_id_regex = config['Report']['ticket_id_regex']
    csv = get_events(url=zabbix_url, user=zabbix_user, password=zabbix_password,
                     from_datetime=from_datetime, to_datetime=to_datetime,
                     severities=severities, column_ids=column_ids, ticket_id_regex=ticket_id_regex)
    print('Events retrieved successfully')

    # Print CSV report
    print()
    print(csv)

    # Send email to configured recipients with CSV report as attachment
    email_enabled = config['Email']['enabled']
    if email_enabled == 'true':
        print('Sending email...')
        smtp_host = config['SMTP']['host']
        smtp_port = config['SMTP']['port']
        smtp_user = config['SMTP']['user']
        smtp_password = config['SMTP']['password']
        email_from_addr = config['Email']['from']
        email_to_addr = config['Email']['to']
        email_subject = config['Email']['subject']
        email_text = config['Email']['text']
        report_filename = build_filename(filename_format=config['Report']['csv_filename'],
                                         report_type=report_type,
                                         from_datetime=from_datetime_str,
                                         to_datetime=to_datetime_str)
        send_email(host=smtp_host, port=smtp_port, user=smtp_user, password=smtp_password, from_addr=email_from_addr,
                   to_addr=email_to_addr, subject=email_subject, content=email_text,
                   attachment_content=csv, attachment_filename=report_filename)
        print('Email sent successfully')
    else:
        print('Not sending email')


# Retrieves events from Zabbix server, optionally using a time filter (start, end)
# Returns CSV output
def get_events(url, user, password, from_datetime, to_datetime, severities, column_ids, ticket_id_regex):
    # Log in to Zabbix server
    zapi = ZabbixAPI(url=url, user=user, password=password)

    # Get events from Zabbix server using a filter for the attributes to retrieve from each event
    event_params = {'output': 'extend', 'sortfield': ['clock', 'eventid'], 'sortorder': 'DESC', 'selectTags': 'extend',
                    'selectHosts': ['hostid', 'host'], 'select_acknowledges': ['action', 'message', 'clock', 'alias']}
    if from_datetime:
        event_params['time_from'] = str(from_datetime)
    if to_datetime:
        event_params['time_till'] = str(to_datetime)
    events = zapi.event.get(**event_params)

    # Construct the CSV header based on the configured columns
    csv = create_csv_row(column_ids=column_ids)

    # Process events and populate the various columns
    columns = {}
    resolved_events = {}
    for event in events:
        # Only process events with a severity value, which represent "Created" events
        severity_id_str = event['severity']
        severity_id = int(severity_id_str)
        if severity_id >= SEVERITY_INFO_LEVEL:
            # Alarm raised time
            clock_timestamp_str = event['clock']
            columns['AlarmRaisedTime'] = get_date_string_from_timestamp(clock_timestamp_str)

            # Alarm cleared time. The time is available in the referred resolved event, which was previously cached
            r_eventid_str = event['r_eventid']
            r_eventid = int(r_eventid_str)
            if r_eventid > 0:
                r_event = resolved_events[r_eventid_str]
                r_event_timestamp_str = r_event['clock']
                r_event_timestamp = get_date_string_from_timestamp(r_event_timestamp_str)
            else:
                r_event_timestamp = csv_cell_no_value
            columns['AlarmClearedTime'] = r_event_timestamp

            # Acknowledged time
            acknowledged_time = get_event_acknowledges_attribute_value(event=event,
                                                                       target_action_code=ACKNOWLEDGE_ACTION_CODE,
                                                                       attribute_name='clock',
                                                                       conversion_func=get_date_string_from_timestamp)
            columns['AcknowledgedTime'] = acknowledged_time

            # User who acknowledged event
            user = get_event_acknowledges_attribute_value(event=event,
                                                          target_action_code=ACKNOWLEDGE_ACTION_CODE,
                                                          attribute_name='alias')
            columns['AcknowledgedUser'] = user

            # Host name
            hosts = event['hosts']
            if len(hosts) >= 1:
                host = hosts[0]
                hostname = host['host']
            else:
                hostname = csv_cell_no_value
            columns['Host'] = hostname

            # Severity
            severity_str = severities[severity_id_str]
            columns['Severity'] = severity_str

            # Comments
            comments = get_event_acknowledges_attribute_value(event=event,
                                                              target_action_code=COMMENT_ACTION_CODE,
                                                              attribute_name='message',
                                                              conversion_func=remove_eols)
            if comments:
                comments = "\"" + comments + "\""
            else:
                comments = csv_cell_no_value
            columns['Comments'] = comments

            # Ticket #
            # Extract from comments. Parsing string configurable
            match = re.search(ticket_id_regex, comments, re.IGNORECASE)
            if match:
                ticket_id = match.group(1)
            else:
                ticket_id = csv_cell_no_value
            columns['TicketId'] = ticket_id

            # Add new row to CSV, using the configured columns
            csv += create_csv_row(column_ids=column_ids, conversion_func=lambda column_id: columns[column_id])
        else:
            # 'Resolved' type of event
            # Cache it for subsequence access from 'Created' type of event
            eventid_str = event['eventid']
            eventid = int(eventid_str)
            if eventid > 0:
                resolved_events[eventid_str] = event

    # Logout from Zabbix
    zapi.user.logout()

    return csv


# Creates a new row for CSV output
def create_csv_row(column_ids, conversion_func=None):
    csv_row = ''

    first_entry = True
    for column_id in column_ids:
        if not first_entry:
            csv_row += CSV_CELL_SEPARATOR
        if conversion_func:
            csv_row += conversion_func(column_id)
        else:
            csv_row += column_id
        first_entry = False

    csv_row += EOL

    return csv_row


# Retrieves the value of an attribute stored under the event's "acknowledges" attribute
# Uses optional lambda function for converting raw attribute value into something more presentable
def get_event_acknowledges_attribute_value(event, target_action_code, attribute_name, conversion_func=None):
    attribute_value = ''

    acknowledged = int(event['acknowledged'])
    if acknowledged:
        acknowledges = event['acknowledges']
        first_entry = True
        for acknowledge in acknowledges:
            action_code = int(acknowledge['action'])
            if action_code & target_action_code:
                if not first_entry:
                    attribute_value += csv_cell_multi_value_separator
                if attribute_name in acknowledge:
                    attribute_value_str = acknowledge[attribute_name]
                    if conversion_func:
                        attribute_value += conversion_func(attribute_value_str)
                    else:
                        attribute_value = attribute_value_str
                else:
                    attribute_value = csv_cell_no_value
                first_entry = False

    return attribute_value


# Sends an email that contains text and an attachment via a SMTP server
def send_email(host, port, user, password, from_addr, to_addr, subject, content, attachment_content,
               attachment_filename):
    # Create email header
    msg = MIMEMultipart()
    msg['From'] = from_addr
    msg['To'] = to_addr
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    # Add content to email
    msg.attach(MIMEText(content))

    # Add attachment to email
    part = MIMEApplication(attachment_content, Name=attachment_filename)
    part['Content-Disposition'] = 'attachment; filename="%s"' % attachment_filename
    msg.attach(part)

    # Extract the list of recipients as sendmail() expects a list of email addresses
    to_addrs = to_addr.split(',')

    # Send email
    server = smtplib.SMTP(host, port)
    server.ehlo()
    server.starttls()
    server.ehlo()
    server.login(user, password)
    server.sendmail(from_addr, to_addrs, msg.as_string())
    server.close()


# Constructs filename using format and replace values
def build_filename(filename_format, from_datetime, to_datetime, report_type):
    return filename_format. \
        replace('{{report_type}}', report_type). \
        replace('{{from_datetime}}', from_datetime). \
        replace('{{to_datetime}}', to_datetime)


# Converts date string to timestamp (Epoch)
def get_timestamp_from_date_string(time_str):
    element = datetime.strptime(time_str, datetime_format)
    timetuple = element.timetuple()
    return int(time.mktime(timetuple))


# Converts timestamp (Epoch) to date string
def get_date_string_from_timestamp(timestamp_str):
    timestamp = int(timestamp_str)
    dt = datetime.utcfromtimestamp(timestamp)
    return dt.strftime(datetime_format)


# Removes line endings from text
def remove_eols(text):
    return text.replace(LF, '').replace(CR, '')


if __name__ == "__main__":
    main()
