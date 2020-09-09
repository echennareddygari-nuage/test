#!/usr/bin/env python

import argparse
import getpass
import json
import logging
import requests
from datetime import datetime

from prettytable import PrettyTable
from vspk import v5_0 as vsdk


def get_args():
    """
    Supports the command-line arguments listed below.
    """

    parser = argparse.ArgumentParser(description="Tool to list all FIPs attached to the VMs to which the user has access to.")
    parser.add_argument('-d', '--debug', required=False, help='Enable debug output', dest='debug', action='store_true')
    parser.add_argument('-j', '--json', required=False, help='Print as JSON, not as a table', dest='json_output', action='store_true')
    parser.add_argument('-l', '--log-file', required=False, help='File to log to (default = stdout)', dest='logfile', type=str)
    parser.add_argument('-E', '--nuage-enterprise', required=True, help='The enterprise with which to connect to the Nuage VSD/SDK host', dest='nuage_enterprise', type=str)
    parser.add_argument('-H', '--nuage-host', required=True, help='The Nuage VSD/SDK endpoint to connect to (do not include protocol identifier)', dest='nuage_host', type=str)
    parser.add_argument('-P', '--nuage-port', required=False, help='The Nuage VSD/SDK server port to connect to (default = 8443)', dest='nuage_port', type=int, default=8443)
    parser.add_argument('-p', '--nuage-password', required=False, help='The password with which to connect to the Nuage VSD/SDK host. If not specified, the user is prompted at runtime for a password', dest='nuage_password', type=str)
    parser.add_argument('-u', '--nuage-user', required=True, help='The username with which to connect to the Nuage VSD/SDK host', dest='nuage_username', type=str)
    parser.add_argument('-S', '--disable-SSL-certificate-verification', required=False, help='Disable SSL certificate verification on connect', dest='nosslcheck', action='store_true')
    parser.add_argument('-v', '--verbose', required=False, help='Enable verbose output', dest='verbose', action='store_true')
    args = parser.parse_args()
    return args


def main():
    """
    Main function to handle vcenter vm names and the mapping to a policy group
    """

    # Handling arguments
    args                = get_args()
    debug               = args.debug
    json_output         = args.json_output
    log_file            = None
    if args.logfile:
        log_file        = args.logfile
    nuage_enterprise    = args.nuage_enterprise
    nuage_host          = args.nuage_host
    nuage_port          = args.nuage_port
    nuage_password      = None
    if args.nuage_password:
        nuage_password  = args.nuage_password
    nuage_username      = args.nuage_username
    nosslcheck          = args.nosslcheck
    verbose             = args.verbose

    # Logging settings
    if debug:
        log_level = logging.DEBUG
    elif verbose:
        log_level = logging.INFO
    else:
        log_level = logging.WARNING

    logging.basicConfig(filename=log_file, format='%(asctime)s %(levelname)s %(message)s', level=log_level)
    logger = logging.getLogger(__name__)

    # Disabling SSL verification if set
    if nosslcheck:
        logger.debug('Disabling SSL certificate verification.')
        requests.packages.urllib3.disable_warnings()

    # Getting user password for Nuage connection
    if nuage_password is None:
        logger.debug('No command line Nuage password received, requesting Nuage password from user')
        nuage_password = getpass.getpass(prompt='Enter password for Nuage host %s for user %s: ' % (nuage_host, nuage_username))

    try:
        # Connecting to Nuage
        logger.info('Connecting to Nuage server %s:%s with username %s' % (nuage_host, nuage_port, nuage_username))
        nc = vsdk.NUVSDSession(username=nuage_username, password=nuage_password, enterprise=nuage_enterprise, api_url="https://%s:%s" % (nuage_host, nuage_port))
        nc.start()

    except Exception, e:
        logger.error('Could not connect to Nuage host %s with user %s and specified password' % (nuage_host, nuage_username))
        logger.critical('Caught exception: %s' % str(e))
        return 1

    if json_output:
        logger.debug('Setting up json output')
        json_dict = {}
    else:
        logger.debug('Setting up basic output table')
        pt = PrettyTable(['Enterprise', 'Domain', 'VM Name', 'VM IP', 'VM MAC', 'FIP'])

    logger.debug('Getting license IDs for the logged in user.')

    for nc_license in nc.user.licenses.get():

        if nc_license.license_type == "CLUSTERED":

            # Calculate days left on license
            now = datetime.utcnow()
            expiryDate = datetime.utcfromtimestamp(nc_license.expiration_date/1000)
            timeDelta = (expiryDate - now)
            json_dict['daysLeft'] = timeDelta.days
            json_dict['expiryDate'] = expiryDate.strftime("%Y-%m-%d %H:%M:%SZ")

    # Get the count of licensed and used NSGs
    nc_license_status = nc.user.license_status.get()
    json_dict['usedNsgCount']=  nc_license_status[0].total_licensed_used_nsgs_count
    json_dict['licensedNsgCount'] = nc_license_status[0].total_licensed_nsgs_count

    # Output result as json
    print json.dumps(json_dict, sort_keys=True, indent=4)

    return 0

# Start program
if __name__ == "__main__":
    main()
