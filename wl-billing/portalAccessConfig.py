import logging

logger = logging.getLogger(__name__)

class PortalAccessConfig:

#--------------------------------------------------------------------------------------------------------------- 
# These values describe the access configuration for all available instances of the SDWAN Portal.
# Instances for production, lab/development and unit test environments can be specified here.
#---------------------------------------------------------------------------------------------------------------  
    portal_na_1_dict                                  =  {}
    portal_na_1_dict['oauth_client_id']               =  "billingclient"
    portal_na_1_dict['oauth_client_secret']           =  "WhN4jv6k3n697eYW"
    portal_na_1_dict['portal_environment']            =  "PROD-XXXX"
    portal_na_1_dict['portal_description']            =  "XXXX production instance"
    portal_na_1_dict['portal_user']                   =  "wlbilling"
    portal_na_1_dict['portal_password']               =  "A9pcz8vnPc5tqrny"
    portal_na_1_dict['portal_organization']           =  "csp"
    portal_na_1_dict['portal_batch_page_size']        =  1
    portal_na_1_instance_base_URL                     =  "https://portal/vnsportal"
    portal_na_1_dict['portal_instance_base_URL']      =  portal_na_1_instance_base_URL
    portal_na_1_dict['portal_login_URL']              =  portal_na_1_instance_base_URL + "/system/v6_0/login"
    portal_na_1_dict['portal_platform_URL']           =  portal_na_1_instance_base_URL + "/public/v6_0/platform/organizationreport"
    portal_na_1_dict['portal_orgs_URL']               =  portal_na_1_instance_base_URL + "/public/v6_0/organizations"
    portal_na_1_dict['portal_oauth_URL']              =  portal_na_1_instance_base_URL + "/oauth/authorize"
    portal_na_1_dict['portal_token_URL']              =  portal_na_1_instance_base_URL + "/oauth/token"
    portal_na_1_dict['extract_file_path']             =  "/home/ec2-user/reports/"
    portal_na_1_dict['extract_file_prefix']           =  "prod-xxxx-"
    portal_na_1_dict['extract_file_suffix']           =  ".csv"

    portal_apac_1_dict                                  =  {}
    portal_apac_1_dict['oauth_client_id']               =  "billingclient"
    portal_apac_1_dict['oauth_client_secret']           =  "WhN4jv6k3n697eYW"
    portal_apac_1_dict['portal_environment']            =  "PROD-APAC01"
    portal_apac_1_dict['portal_description']            =  "APAC01 production instance"
    portal_apac_1_dict['portal_user']                   =  "wlbilling"
    portal_apac_1_dict['portal_password']               =  "A9pcz8vnPc5tqrny"
    portal_apac_1_dict['portal_organization']           =  "csp"
    portal_apac_1_dict['portal_batch_page_size']        =  1
    portal_apac_1_instance_base_URL                     =  "https://portal/vnsportal"
    portal_apac_1_dict['portal_instance_base_URL']      =  portal_apac_1_instance_base_URL
    portal_apac_1_dict['portal_login_URL']              =  portal_apac_1_instance_base_URL + "/system/v6_0/login"
    portal_apac_1_dict['portal_platform_URL']           =  portal_apac_1_instance_base_URL + "/public/v6_0/platform/organizationreport"
    portal_apac_1_dict['portal_orgs_URL']               =  portal_apac_1_instance_base_URL + "/public/v6_0/organizations"
    portal_apac_1_dict['portal_oauth_URL']              =  portal_apac_1_instance_base_URL + "/oauth/authorize"
    portal_apac_1_dict['portal_token_URL']              =  portal_apac_1_instance_base_URL + "/oauth/token"
    portal_apac_1_dict['extract_file_path']             =  "/home/ec2-user/reports/"
    portal_apac_1_dict['extract_file_prefix']           =  "prod-apac01-"
    portal_apac_1_dict['extract_file_suffix']           =  ".csv"

    
#---------------------------------------------------------------------------------------------------------------  
# The values in the dictionary 'available_portals_dict' represent all of the SDWAN Portal instances that
# can be selected as a run-time argument by specifying one of the keys found in the dictionary.
#---------------------------------------------------------------------------------------------------------------  
    available_portals_dict  = {}
    
    available_portals_dict['NA01']   =  portal_na_1_dict
    available_portals_dict['APAC01']   =  portal_apac_1_dict
    

   
#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the class.  It requires a run-time argument that must match one of
# the keys in the dictionary 'available_directory_dict' such as 'DEV-01' or 'PROD-01'.
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self):
        logger.debug("Welcome to the SDWAN Portal Access Configuration class")

        self.current_config_dict  =  None
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# This function returns the dictionary 'value' for a specific SDWAN Portal instance run-time argument 'key'
#---------------------------------------------------------------------------------------------------------------  
    def get_portal_configuration_dict_by_name(self, run_time_portal_instance_name):
        logger.debug("starting")

        self.validate_run_time_portal_argument(run_time_portal_instance_name)
        
        available_config_dicts    =  PortalAccessConfig.available_portals_dict
        self.current_config_dict  =  available_config_dicts[run_time_portal_instance_name] 

        logger.debug("returning with current_config_dict: {}".format(self.current_config_dict))
        return self.current_config_dict
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# This function validates that the run-time SDWAN Portal instance argument key is configured in this class
#---------------------------------------------------------------------------------------------------------------  
    def validate_run_time_portal_argument(self, run_time_portal_instance_name):
        logger.debug("starting")

        if (run_time_portal_instance_name in PortalAccessConfig.available_portals_dict.keys()):
            pass
        else:
            msg = "ERROR: Invalid SDWAN Portal Instance Name argument " + run_time_portal_instance_name + " provided"
            logger.error(msg)
            raise Exception(msg)

        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  
