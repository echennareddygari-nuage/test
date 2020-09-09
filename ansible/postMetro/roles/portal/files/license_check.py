#!/usr/bin/env python

from datetime import datetime
import json
import argparse
import re

######################
### Start of functions

def getExpiryDate(fileName):

    text = open(fileName, "r")

    for line in text:

        match = re.match("(expiry:).([\d]*-[\d]*-[\d]*)", line)

        if match:

            date = match.group(2)

    text.close()
    expiryDate = datetime.strptime(date, '%Y-%m-%d')

    return expiryDate

def getArgs():

    # Parse command line args
    parser = argparse.ArgumentParser(description='Check expiry date of specified license file and return info.')
    parser.add_argument('-f', '--file', default='/opt/vnsportal/tomcat-instance1/vns-portal.license', help='the name and full path of the license file (default = /opt/vnsportal/tomcat-instance1/vns-portal.license)')

    return parser.parse_args()

### End of functions
####################


##########################
### START of Main loop ###
def main():

    # Gets args
    args = getArgs()

    # Write args to global variables
    FILE = args.file

    # Build the json structure and intialize some values
    dict = {}
    dict['daysLeft'] = 9999999
    dict['file'] = ""
    dict['date'] = ""

    # Get current datetime
    now = datetime.utcnow()

    # Extract expiry from the license file


    try:
        expiryDate = getExpiryDate(FILE)

    except:
        ERROR = "True"

    else:
        timeDelta =  (expiryDate - now)

        dict['daysLeft'] = timeDelta.days
        dict['file'] = FILE
        dict['date'] = expiryDate.strftime("%Y-%m-%d %H:%M:%SZ")


    JSON = json.dumps(dict)

    print(JSON)



if __name__ == "__main__":

    main()

### END
#######
