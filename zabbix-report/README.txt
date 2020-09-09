zabbix-report
=============

This tool retrieves events from a Zabbix server and produce a report containing relevant event information,
in CSV format, that is included in an email sent to interested parties.

The tool reads a configuration file (config.ini) that contains, among other things, the connection settings
for Zabbix (events) and SMTP server (email). The following settings will likely need to be modified:
- User the [Zabbix] section: url, user, password
- Under the [Email] section: from, to, subject, text
- Under the [Report] section: csv_filename

Note that the tool requires Python interpreter version 3.x.

Usage: python eventreport.py [<from_datetime|from_timestamp> <to_datetime|to_timestamp> <report_type>]
    from_datetime: the start date/time. It is a string that follows datetime_format defined in config
    from_timestamp: the start timestamp. It is a integer based timestamp in epoch format
    to_datetime: the end date/time. It is a string that follows datetime_format defined in config, oR epoch timestamp
    to_timestamp: the end timestamp. It is a integer based timestamp in epoch format
    report_type: string that qualifies the report e.g. weekly

Here are the suggested command lines for the various automatic report generation via cron jobs:
   python3 eventreport.py `expr \`date +%s\` - 604800` `expr \`date +%s\`` weekly
   python3 eventreport.py `expr \`date +%s\` - 2592000` `expr \`date +%s\`` monthly
   python3 eventreport.py `expr \`date +%s\` - 31536000` `expr \`date +%s\`` yearly

For support please send email to ben.crowell@nuagenetworks.com
