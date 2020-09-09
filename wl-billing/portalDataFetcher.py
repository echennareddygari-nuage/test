import logging

logger = logging.getLogger(__name__)

class PortalDataFetcher(object):

#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the class.  
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self, portal_access_config_dict, access_token, portal_http_requester):
        logger.info("Welcome to the Portal Data Fetcher class")

        self.required_config_names      =  ['portal_platform_URL', 'portal_orgs_URL', 'portal_batch_page_size']
        self.access_token               =  access_token
        self.portal_http_requester      =  portal_http_requester

        self.portal_access_config_dict  =  portal_access_config_dict

        self.validate_user_arguments()
        
        for config_name in self.required_config_names:
            config_value  =  portal_access_config_dict[config_name]
            logger.debug("assigning config name {} and value {}".format(config_name, config_value))
            setattr(self, config_name, config_value)

        self.bearer_string          =  'Bearer ' + self.access_token
        self.auth_header_dict       =  {"Authorization" : self.bearer_string}
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------
    def fetch_organization_report(self):
        logger.debug("starting")

        response_object       =  self.portal_http_requester.issue_get_request_basic(self.portal_platform_URL, headers = self.auth_header_dict)
        json_org_object_list  =  response_object.json()

        logger.debug("ending")
        return json_org_object_list
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def fetch_number_of_branches_for_subscriber(self, subscriber_id):
        logger.debug("starting for subscriber id {}".format(subscriber_id))

        portal_branch_URL   =  self.portal_orgs_URL + "/" + str(subscriber_id) + "/branches"
        response_object     =  self.portal_http_requester.issue_head_request(portal_branch_URL, headers = self.auth_header_dict, params = None)
        number_of_branches  =  int(response_object.headers['X-VNS-Count'])

        logger.debug("ending with number of branches {}".format(number_of_branches))
        return number_of_branches
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------
# Make requests for batches of subscriber branch records, using values in headers to determine batch(page) size
# and page number.  If page size is 50 and have 100 branches, then need 2 calls to fetch 50 from pages 0 and 1
#---------------------------------------------------------------------------------------------------------------
    def fetch_subscriber_branch_detail_data(self, subscriber_id, number_of_branches):
        logger.info("starting for subscriber ID {} and branch count {}".format(subscriber_id, number_of_branches))

        portal_branch_URL       =  self.portal_orgs_URL + "/" + str(subscriber_id) + "/branches"
        page_size_requested     =  self.portal_batch_page_size
        page_number_requested   =  0
        records_fetched_so_far  =  0
    
        json_full_subscriber_branch_object_list  =  []
    
        while records_fetched_so_far < number_of_branches:
            page_header_dict                    =  self.auth_header_dict
            page_header_dict['X-VNS-PageSize']  =  str(page_size_requested)
            page_header_dict['X-VNS-Page']      =  str(page_number_requested)

            response_object          =  self.portal_http_requester.issue_get_request_basic(portal_branch_URL, headers = page_header_dict)
            page_size                =  response_object.headers['X-VNS-PageSize']
            current_page             =  response_object.headers['X-VNS-Page']
            logger.debug("found page size {} and current page {}".format(page_size, current_page))

            json_partial_branch_object_list  =  response_object.json()

            logger.info("response json_object_list {}".format(json_partial_branch_object_list))
            json_full_subscriber_branch_object_list.extend(json_partial_branch_object_list)
            records_fetched_so_far  +=  int(page_size)
            page_number_requested   +=  1

        logger.info("ending")
        return json_full_subscriber_branch_object_list
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

        if self.access_token:
            pass
        else:
            msg = 'ERROR: Portal Access Token is missing'
            logger.error(msg)
            raise Exception(msg)

        if self.portal_http_requester:
            pass
        else:
            msg = 'ERROR: Portal HTTP Requester instance is missing'
            logger.error(msg)
            raise Exception(msg)

        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  
