import logging
import time
from datetime import datetime

logger = logging.getLogger(__name__)

class PortalBranchDataExtractor(object):

#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the class.  
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self, portal_access_config_dict):
        logger.info("Welcome to the Portal Branch Data Extractor class")

        self.required_config_names      =  ['extract_file_path', 'extract_file_prefix', 'extract_file_suffix', 'portal_environment', 'portal_description']
        self.portal_access_config_dict  =  portal_access_config_dict

        self.validate_user_arguments()
        
        for config_name in self.required_config_names:
            config_value  =  portal_access_config_dict[config_name]
            logger.debug("assigning config name {} and value {}".format(config_name, config_value))
            setattr(self, config_name, config_value)
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def extract_branches_to_csv(self, subscriber_branch_record_dict_list, requested_csv_layout):
        logger.info("starting")
        
        csv_data_array      =  []

        subscriber_counter  =  0
        record_counter      =  0
        branch_counter      =  0
        new_field_names     =  []
        new_header_names    =  []
        
        extract_file_name   =  self.extract_file_path + self.extract_file_prefix + time.strftime('%Y%m%d%H%M%S') + self.extract_file_suffix
        portal_timestamp    =  str(datetime.utcnow())
        portal_environment  =  self.portal_environment
        portal_description  =  self.portal_description

        #temp_header_array   = ['Record Ctr', 'Run Time', 'White Label Env', 'White Label Desc', 'Reseller Name',  'Reseller ID', 'Subscriber Ctr',  'Branch Ctr', 'Subscriber ID', 'Name', 'No. of Branches']
        temp_header_array   = ['execution_tod', 'deployment_name', 'deployment_description', 'reseller_name',  'reseller_id', 'reseller_uuid', 'subscriber_name', 'subscriber_id']

        for column_header_field_pair_dict in requested_csv_layout:
            for header_name, field_name in column_header_field_pair_dict.items(): 
                new_field_names.append(field_name)
                new_header_names.append(header_name)
            
        temp_header_array.extend(new_header_names)
        temp_header_record = ','.join(temp_header_array)

        csv_data_array.append(temp_header_record)

        for subscriber_record in subscriber_branch_record_dict_list:
            subscriber_id                          =  str(subscriber_record['subscriber_id'])
            subscriber_name                        =  str(subscriber_record['subscriber_name'])
            reseller_name                          =  str(subscriber_record['parent_reseller_name'])
            reseller_id                            =  str(subscriber_record['parent_reseller_id'])
            reseller_uuid                          =  str(subscriber_record['parent_reseller_uuid'])
            subscriber_branch_count                =  str(subscriber_record['number_of_branches'])
            subscriber_branch_detail_object_list   =  subscriber_record['branch_detail_list']
            
            branch_counter  =  0
            if len(subscriber_branch_detail_object_list) > 0:
                subscriber_counter += 1
         
            for branch_object in subscriber_branch_detail_object_list:
                record_counter += 1
                branch_counter += 1
                temp_data_array  =  []
                #temp_data_array.append(str(record_counter))
                temp_data_array.append(portal_timestamp)
                temp_data_array.append(portal_environment)
                temp_data_array.append(portal_description)
                temp_data_array.append(reseller_name)
                temp_data_array.append(reseller_id)
                temp_data_array.append(reseller_uuid)
                #temp_data_array.append(str(subscriber_counter))
                #temp_data_array.append(str(branch_counter))
                temp_data_array.append(subscriber_name)
                temp_data_array.append(subscriber_id)
                #temp_data_array.append(subscriber_branch_count)
                                   
                for field_name in new_field_names:
                    value  =  str(branch_object[field_name])
                    if ',' in value:
                        value = '"' + value + '"'
                    temp_data_array.append(value)

                temp_data_record = ','.join(temp_data_array)
    
                csv_data_array.append(temp_data_record)

        output_file = open(extract_file_name, "w")

        for csv_record in csv_data_array:
            output_file.write(csv_record)
            output_file.write("\n")
            print (csv_record)
    
        output_file.close()

        logger.info("ending with CSV record count is {}".format(record_counter))
        
        return
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# Ensure that initialization arguments pass some simple validation
#---------------------------------------------------------------------------------------------------------------  
    def validate_user_arguments(self):
        logger.debug("starting")
        
        if self.portal_access_config_dict:
            pass
        else:
            msg = 'ERROR: Portal Access Config Dictionary is missing'
            logger.error(msg)
            raise Exception(msg)

        for config_name in self.required_config_names:
            if config_name in self.portal_access_config_dict.keys():
                pass
            else:
                msg = 'ERROR: Config value ' + config_name + ' was not provided'
                logger.exception(msg)
                raise Exception(msg)

        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  
