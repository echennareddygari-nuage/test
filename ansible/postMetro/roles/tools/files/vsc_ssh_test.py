#!/usr/bin/env python

''' This runs a simple uptime command on a remote VSC using SSH. It is used to test connectivity and OS
operationla state at a higher lvel than simple reachability tests.
./monitor.py [-s server_hostname] [-u username] [-p password]
    -s : hostname of the remote server to login to.
    -u : username to user for login.
    -p : Password to user for login.
Example:
    This will print information about the given host:
        ./monitor.py -s www.example.com -u mylogin -p mypassword
It works like this:cd ..
    Login via SSH (This is the hardest part).
    Run 'show uptime'.
    Logout of the remote host.
'''

from __future__ import print_function

from __future__ import absolute_import

import os, sys, re, getopt, getpass
import pexpect


try:
    raw_input
except NameError:
    raw_input = input


#
# Some constants.
#
COMMAND_PROMPT = '(vsc.*#)'
UPTIME_OUTPUT = '(System Up Time.*\(hr:min:sec\))'
# This is the prompt we get if SSH does not have the remote host's public key stored in the cache.
SSH_NEWKEY = '(?i)are you sure you want to continue connecting'
PERMISSION_DENIED = 'Permission denied'
AUTH_FAILED = 'Authentication failed'

def exit_with_usage():

    print(globals()['__doc__'])
    os._exit(1)

def main():

    global COMMAND_PROMPT, SSH_NEWKEY, UPTIME_OUTPUT, PERMISSION_DENIED, AUTH_FAILED
    ######################################################################
    ## Parse the options, arguments, get ready, etc.
    ######################################################################
    try:
        optlist, args = getopt.getopt(sys.argv[1:], 'h?d?s:u:p:', ['help','h','?'])
    except Exception as e:
        print(str(e))
        exit_with_usage()
    options = dict(optlist)
    if len(args) > 1:
        exit_with_usage()

    if [elem for elem in options if elem in ['-h','--h','-?','--?','--help']]:
        print("Help:")
        exit_with_usage()

    if '-s' in options:
        host = options['-s']
    else:
        host = raw_input('hostname: ')
    if '-u' in options:
        user = options['-u']
    else:
        user = raw_input('username: ')
    if '-p' in options:
        password = options['-p']
    else:
        password = getpass.getpass('password: ')
    if '-d' in options:
        DEBUG = True
    else:
        DEBUG = False

    # Set some initial values
    STATUS = None
    LOGIN_SUCCESS = None
    COMMAND_SUCCESS = None
    LOGOUT_SUCCESS = None

    #
    # Login via SSH
    #LOGIN_SUCCESS = None
    child = pexpect.spawn('ssh -l %s %s'%(user, host))

    while LOGIN_SUCCESS is None:
        i = child.expect([pexpect.TIMEOUT, SSH_NEWKEY, COMMAND_PROMPT, '(?i)password', PERMISSION_DENIED, AUTH_FAILED])
        if i == 0: # Timeout
            if DEBUG:
                print('ERROR! could not login with SSH. Here is what SSH said:')
                print(child.before, child.after)
                print(str(child))
            LOGIN_SUCCESS = False
            print('2')
            sys.exit(1)
        if i == 1: # In this case SSH does not have the public key cached.
            if DEBUG:
                print('Not a known host.  Adding ssh key locally.')
            child.sendline ('yes')
        if i == 2:
            # This may happen if a public key was setup to automatically login.
            # But beware, the COMMAND_PROMPT at this point is very trivial and
            # could be fooled by some output in the MOTD or login message.
            if DEBUG:
                 print('Login successful...we are in!')
            LOGIN_SUCCESS = True
        if i == 3:
            if DEBUG:
                print('Sending password now...')
            child.sendline(password)
            # Now we are either at the command prompt or
            # the login process is asking for our terminal type.
        if i == 4: # Timeout
            if DEBUG:
                print('ERROR! Thre is a problem with your user/pass combination:')
                print(child.before, child.after)
                print(str(child))
            LOGIN_SUCCESS = False
            print('2')
            sys.exit(1)
        if i == 5: # Timeout
            if DEBUG:
                print('ERROR! There is a problem with your user/pass combination:')
                print(child.before, child.after)
                print(str(child))
            LOGIN_SUCCESS = False
            print('2')
            sys.exit(1)

    # Now we should be at the command prompt and ready to run some commands.
    if DEBUG:
        print('---------------------------------------')
        print('Report of commands run on remote host.')
        print('---------------------------------------')

    # Run 'show uptime'
    child.sendline ('show uptime')

    while COMMAND_SUCCESS is None:
        i = child.expect([pexpect.TIMEOUT, UPTIME_OUTPUT, COMMAND_PROMPT])
        if i == 0:
            if DEBUG:
                print('ERROR! Command timed out. Here is what SSH said:')
                print(child.before, child.after)
                print(str(child))
            COMMAND_SUCCESS = False
            sys.exit (1)
        if i == 1:
            if DEBUG:
                print('Uptime command output received')
                print('Back to prompt.')
            COMMAND_SUCCESS = True


    # Now logout from vsc.
    child.sendline ('logout')

    i = child.expect(pexpect.EOF)
    if i == 0:
        if DEBUG:
            print('Successfully logged out of vsc')
        LOGOUT_SUCCESS = True
    else:
        if DEBUG:
            print('Failed to log out of vsc')
            print(child.before, child.after)
        LOGOUT_SUCCESS = False

    # print the overall status code
    # 0 -> total success
    # 1 -> partial success (degraded)
    # 2 -> total failure (SSH failure)
    # 3 -> unknown failure

    if LOGIN_SUCCESS and COMMAND_SUCCESS and LOGOUT_SUCCESS:
        STATUS = 0
    elif not LOGIN_SUCCESS:
        # we should never get here anyway
        STATUS = 2
    elif LOGIN_SUCCESS and (not COMMAND_SUCCESS or not LOGOUT_SUCCESS):
        STATUS = 1
    else:
        STATUS = 3

    if DEBUG:
        print('Login = ' + str(LOGIN_SUCCESS) + ' | Command = ' + str(COMMAND_SUCCESS) + ' | Logout = ' + str(LOGOUT_SUCCESS))

    # Output overal state
    print(STATUS)


if __name__ == "__main__":
    main()
