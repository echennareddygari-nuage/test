import logging.config

#-----------------------------------------------------------------------------------------------------------------------  
# This is the default logging configuration.  By default, write to file /var/log/scripts/debug.log in INFO mode
#
# Option           Default               Run Time arg override example           Result of override
# --------------  --------------------  --------------------------------        ---------------------------------------------
# Log Level        INFO                 { -ll | --logLevel } DEBUG              Log messages at DEBUG level
# Log File Name    'debug.log'          { -lf | --logFile  } test-01.log        Write to file /var/log/scripts/test-01.log
# Log Path Name    '/var/log/scripts'   { -lp | --logPath  } /tmp/test123.log   Write to file /tmp/test123.log
#
#------------------------------------------------------------------------------------------------------------------------  
DEFAULT_LOGGING_CONFIG = {
    'version' : 1,
    
    'disable_existing_loggers' : False,
    
    'formatters' : { 'full': {'format': '%(asctime)s [%(module)s] %(funcName)s:%(lineno)d - %(message)s'},
                     'mini': {'format': '%(asctime)s - %(message)s'}
                   },

    'handlers' : { 'file':    {
                              'class'        :  'logging.handlers.TimedRotatingFileHandler', 
                              'formatter'    :  'full',
                              'level'        :  'INFO',
                              'filename'     :  '/var/log/scripts/debug.log',
                              'when'         :  'M',
                              'interval'     :  2,
                              'backupCount'  :  5
                              },
                   'console': {
                              'class'      : 'logging.StreamHandler',
                              'formatter'  : 'full',
                              'level'      : 'INFO'
                              }
                 },
    
    'loggers': { '' : { 'handlers' : ['console', 'file']} },

    'root' : {'handlers' : ['console', 'file'], 'level': 'INFO'},
}

#---------------------------------------------------------------------------------------------------------------  
# Configure logging using the current contents of the dictionary argument
#---------------------------------------------------------------------------------------------------------------  
def establish_default_logging():
    configure_logging_using_dict(DEFAULT_LOGGING_CONFIG)
    logging.getLogger().info("logging configuration has been established")

    return


#---------------------------------------------------------------------------------------------------------------  
# Provide a list of arguments for the caller module.  The caller should invoke this method to capture the latest
# set of arguments and functionality that is supported by this class.
#---------------------------------------------------------------------------------------------------------------  
def add_supported_run_time_args_to_parser(parser_instance):
    logging.getLogger().info("starting")
    log_location_parser = parser_instance.add_mutually_exclusive_group(required=False)
    log_location_parser.add_argument('-lp', '--logPath',  action='store', dest='log_path_name', required=False, help='Full Path and name for log file')
    log_location_parser.add_argument('-lf', '--logFile',  action='store', dest='log_file_name', required=False, help='Name (only) for log file')

    parser_instance.add_argument('-ll', '--logLevel', action='store', dest='log_level', required=False,  help='logging level')

    logging.getLogger().info("ending")
    return parser_instance


#---------------------------------------------------------------------------------------------------------------  
# Override whatever log file options have been specified as run time arguments
#---------------------------------------------------------------------------------------------------------------  
def override_default_logging_if_args_provided(run_time_args):
    logging.getLogger().info("starting")
    if run_time_args.log_path_name:
        override_default_log_path_name(run_time_args.log_path_name)
        
    if run_time_args.log_file_name:
        override_default_log_file_name(run_time_args.log_file_name)
        
    if run_time_args.log_level:
        override_default_log_level(run_time_args.log_level)

    configure_logging_using_dict(DEFAULT_LOGGING_CONFIG)

    logging.getLogger().info("ending")
    return


#---------------------------------------------------------------------------------------------------------------  
# Configure logging using the current contents of the dictionary argument
#---------------------------------------------------------------------------------------------------------------  
def configure_logging_using_dict(logging_config_dict):
    logging.getLogger().info("starting")
    logging.config.dictConfig(logging_config_dict)
    logging.getLogger().info("ending")
    return


#---------------------------------------------------------------------------------------------------------------  
# Override the full path and filename portion of the default log file.  Replace values in dictionary.
#   - typical argument would be similar to this "/var/log/newScriptsDirectory/failover.log"
#---------------------------------------------------------------------------------------------------------------  
def override_default_log_path_name(new_log_path_name):
    logging.getLogger().info("starting override of log path name to {}".format(new_log_path_name))
    handlers_dict                  =  DEFAULT_LOGGING_CONFIG['handlers']
    handler_file_dict              =  handlers_dict['file']
    handler_file_dict['filename']  =  new_log_path_name
    
    logging.getLogger().info("ending")
    return


#---------------------------------------------------------------------------------------------------------------  
# Override only the filename portion of the default log file.  Replace values in dictionary.
#   - typical argument would be similar to this "failover.log"
#---------------------------------------------------------------------------------------------------------------  
def override_default_log_file_name(new_log_file_name):
    logging.getLogger().info("starting override of log file name to {}".format(new_log_file_name))
    handlers_dict                  =  DEFAULT_LOGGING_CONFIG['handlers']
    handler_file_dict              =  handlers_dict['file']
    handler_file_dict['filename']  =  '/var/log/scripts/' + new_log_file_name

    logging.getLogger().info("ending")
    return


#---------------------------------------------------------------------------------------------------------------  
# Override the default logging level.  Typical argument would be "DEBUG".  Replace values in dictionary.
#---------------------------------------------------------------------------------------------------------------  
def override_default_log_level(new_log_level):
    logging.getLogger().info("starting override of log level to {}".format(new_log_level))
    valid_level  =  validate_new_log_level_value(new_log_level)
    
    if not valid_level:
        return
    
    handlers_dict                  =  DEFAULT_LOGGING_CONFIG['handlers']

    handler_file_dict              =  handlers_dict['file']
    handler_file_dict['level']     =  valid_level


    handler_console_dict           =  handlers_dict['console']
    handler_console_dict['level']  =  valid_level


    root_dict                      =  DEFAULT_LOGGING_CONFIG['root']
    root_dict['level']             =  valid_level

    logging.getLogger().info("ending")
    return

#---------------------------------------------------------------------------------------------------------------  
# Validate the new log level value.  If it is not a supported value, then the old log level will not be changed
#---------------------------------------------------------------------------------------------------------------  
def validate_new_log_level_value(new_log_level):
    if new_log_level == 'DEBUG':
        return 'DEBUG'

    if new_log_level == 'INFO':
        return 'INFO'

    if new_log_level == 'WARNING':
        return 'WARNING'

    if new_log_level == 'ERROR':
        return 'ERROR'

    return None
