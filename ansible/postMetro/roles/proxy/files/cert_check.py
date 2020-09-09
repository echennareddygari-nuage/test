#!/usr/bin/env python

from datetime import datetime
import OpenSSL
import glob
import argparse
import json

### Start of functions

def buildFileList(path):

    fileList = glob.glob(path + "/*.pem")

    return fileList

def getExpiryDate(fileName):

    cert = file(fileName).read()
    x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_PEM, cert)
    expiryDate = datetime.strptime(x509.get_notAfter(),"%Y%m%d%H%M%SZ")

    return expiryDate


def getArgs():

    # Parse command line args
    parser = argparse.ArgumentParser(description='Check expiry date of PEM files in a directory and return info about soon to be expired certs.')
    parser.add_argument('-p', '--path', default='/opt/proxy/config/keys', help='the path to scan for cert files')
    parser.add_argument('-t1', default=30, type=int, help='first threshold in days (default=30)')
    parser.add_argument('-t2', default=15, type=int, help='second threshold in days (default=15)')
    parser.add_argument('-t3', default=5, type=int, help='second threshold in days (default=5)')

    return parser.parse_args()


### End of functions
####################

### START of Main loop ###
def main():

    # Get args
    args = getArgs()

    # Write args to global variables
    PATH = args.path
    T1 = args.t1
    T2 = args.t2
    T3 = args.t3

    # Build the json structure and intialize some values
    dict = {}
    dict['nextDaysLeft'] = 9999999
    dict['nextFile'] = ""
    dict['nextDate'] = ""
    dict['t1Count'] = 0
    dict['t1Files'] = ""
    dict['t2Count'] = 0
    dict['t2Files'] = ""
    dict['t3Count'] = 0
    dict['t3Files'] = ""

    # Get current datetime
    now = datetime.utcnow()

    # Get list of all PEM files in specificed directory
    fileList = buildFileList(PATH)

    # Loop through the files, extract the expiry date and generate a dictionary
    for fileName in fileList:

        try:
            expiryDate = getExpiryDate(fileName)

        except:
            ERROR = "True"

        else:
            timeDelta =  (expiryDate - now)

            if timeDelta.days < dict['nextDaysLeft']:
                dict['nextDaysLeft'] = timeDelta.days
                dict['nextFile'] = fileName
                dict['nextDate'] = expiryDate.strftime("%Y-%m-%d %H:%M:%SZ")

            if timeDelta.days < T3:
                dict['t3Count'] += 1
                dict['t3Files'] += "[" + fileName + "]"

            elif timeDelta.days < T2:
                dict['t2Count'] += 1
                dict['t2Files'] += "[" + fileName + "]"

            elif timeDelta.days < T1:
                dict['t1Count'] += 1
                dict['t1Files'] += "[" + fileName + "]"

    JSON = json.dumps(dict)
    print(JSON)

if __name__ == "__main__":

    main()

### END
#######