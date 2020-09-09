import logging

logger = logging.getLogger(__name__)

class PortalExtractFormatConfig:

#--------------------------------------------------------------------------------------------------------------- 
# These values describe all available instances of the Active Directory within the hosted VNS environment.
# Instances for production, lab/development and unit test environments can be specified here.
#          fields = ['vsdId', 'speedTier', 'associatedGatewaySecurityId', 'systemId', 'enterpriseId', 'name']
#---------------------------------------------------------------------------------------------------------------  

    extract_format_01_list  =  []

    #extract_format_01_list.append( {'ID'                             : 'id'} )
    extract_format_01_list.append( {'vsd_id'                         : 'vsdId'} )
    #extract_format_01_list.append( {'Organization ID'                : 'organizationId'} )

    # NSG info section
    extract_format_01_list.append( {'branch_name'                    : 'name'} )
    extract_format_01_list.append( {'description'                    : 'description'} )
    extract_format_01_list.append( {'system_id'                      : 'systemId'} )
    extract_format_01_list.append( {'operation_mode'                 : 'operationMode'} )
    extract_format_01_list.append( {'operation_status'               : 'operationStatus'} )
    extract_format_01_list.append( {'pending'                        : 'pending'} )
    extract_format_01_list.append( {'personality'                    : 'personality'} )
    extract_format_01_list.append( {'product_name'                   : 'productName'} )
    extract_format_01_list.append( {'serial_number'                  : 'serialNumber'} )
    extract_format_01_list.append( {'family'                         : 'family'} )
    extract_format_01_list.append( {'branch_package'                 : 'branchPackage'} )
    extract_format_01_list.append( {'speed_tier'                     : 'speedTier'} )
    extract_format_01_list.append( {'bios_release_date'              : 'biosReleaseDate'} )
    extract_format_01_list.append( {'bios_version'                   : 'biosVersion'} )
    extract_format_01_list.append( {'cpu_type'                       : 'cpuType'} )
    extract_format_01_list.append( {'mac_address'                    : 'macAddress'} )
    extract_format_01_list.append( {'nsg_version'                    : 'nsgVersion'} )
    extract_format_01_list.append( {'sku'                            : 'sku'} )

    # state info
    extract_format_01_list.append( {'boot_strap_id'                  : 'bootstrapId'} )
    extract_format_01_list.append( {'boot_strap_status'              : 'bootstrapStatus'} )
    extract_format_01_list.append( {'gateway_connected'              : 'gatewayConnected'} )
    extract_format_01_list.append( {'last_config_reload_time'        : 'lastConfigurationReloadTimestamp'} )
    extract_format_01_list.append( {'configuration_reload_state'     : 'configurationReloadState'} )
    extract_format_01_list.append( {'configuration_status'           : 'configurationStatus'} )
    extract_format_01_list.append( {'nat_traversal_enabled'          : 'natTraversalEnabled'} )

    # other nsg info
    extract_format_01_list.append( {'enterprise_id'                  : 'enterpriseId'} )
    #extract_format_01_list.append( {'external_id'                    : 'externalId'} )
    extract_format_01_list.append( {'libraries'                      : 'libraries'} )
    extract_format_01_list.append( {'location_id'                    : 'locationId'} )
    extract_format_01_list.append( {'redundancy_group_id'            : 'redundancyGroupId'} )
    extract_format_01_list.append( {'template_id'                    : 'templateId'} )
    extract_format_01_list.append( {'alias'                          : 'alias'} )
    extract_format_01_list.append( {'gateway_security_id'            : 'associatedGatewaySecurityId'} )
    extract_format_01_list.append( {'gateway_security_profile_id'    : 'associatedGatewaySecurityProfileId'} )

    # example of multiple extract formats
    #extract_format_02_list  =  []

    #extract_format_02_list.append( {'VSD ID 2'                         : 'vsdId'} )
    #extract_format_02_list.append( {'Speed Tier 2'                     : 'speedTier'} )
    #extract_format_02_list.append( {'Associated Gateway Security Id 2' : 'associatedGatewaySecurityId'} )
    #extract_format_02_list.append( {'System ID 2'                      : 'systemId'} )
    #extract_format_02_list.append( {'Enterprise ID 2'                  : 'enterpriseId'} )
    #extract_format_02_list.append( {'Branch Name 2'                    : 'name'} )
    # etc...

#---------------------------------------------------------------------------------------------------------------  
# The values in the dictionary 'available_format_dict' represent all of the possible Portal Branch formats that
# can be selected as a run-time argument by specifying one of the keys found in the dictionary.
#---------------------------------------------------------------------------------------------------------------  
    available_format_dict  = {}
    
    available_format_dict['FORMAT-01']   =  extract_format_01_list
    #available_format_dict['FORMAT-02']   =  extract_format_02_list

   
#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the class.  It requires a run-time argument that must match one of
# the keys in the dictionary 'available_format_dict' such as 'FORMAT-01' or 'FORMAT-02'.
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self):
        logger.debug("Welcome to the Portal Extract Format Configuration")

        self.current_format_list  =  None
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# This function returns the dictionary 'value' for a specific Portal Branch Format run-time argument 'key'
#---------------------------------------------------------------------------------------------------------------  
    def get_extract_format_list_by_name(self, run_time_format_name):
        logger.debug("starting")

        self.validate_run_time_format_argument(run_time_format_name)
        
        available_formats_dict    =  PortalExtractFormatConfig.available_format_dict
        self.current_format_list  =  available_formats_dict[run_time_format_name] 

        logger.debug("returning with current_format_list: {}".format(self.current_format_list))
        return self.current_format_list
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# This function validates that the run-time Portal Branch Format name argument key is configured in this class
#---------------------------------------------------------------------------------------------------------------  
    def validate_run_time_format_argument(self, run_time_format_name):
        logger.debug("starting")

        if (run_time_format_name in PortalExtractFormatConfig.available_format_dict.keys()):
            pass
        else:
            msg = "ERROR: Invalid Portal Extract Format Name argument " + run_time_format_name + " provided"
            logger.error(msg)
            raise Exception(msg)

        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  
