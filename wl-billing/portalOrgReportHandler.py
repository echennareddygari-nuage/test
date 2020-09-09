import logging

logger = logging.getLogger(__name__)

class PortalOrgReportHandler(object):

#---------------------------------------------------------------------------------------------------------------
# The Organization Report is a list of JSON objects that look like the following excerpt.
# Each object is converted into an instance of the class PortalOrgRecordClass 
    '''
   {"id":4072,                                             Handle with function convert_json_object_to_org_record
    "name":"sub org1",
    "parentOrganization":
       {"id":4071,                                         This parent is parsed for its ID and Name to see if the child is a subscriber
        "name":"Reseller org",
        "parentOrganization":{ "id":1,                     This parent is ignored
                               "name":"csp",
                               "parentOrganization":null,
                               "vsdId":null,
                               "branches":[]},             These branches are ignored
        "vsdId":"ac4df739-5029-4ba3-9ec8-10e33f587871",
        "branches":[]},                                    These branches are ignored
    "vsdId":"cdede0fa-c822-4b4d-a8aa-529730b48700",
    "branches":[                                           These branches are ignored
       {"id":1194, "vsdId":"aad15c1d-28ee-4b99-a196-1f255612e7e4", "organizationId":4072, "branchPackage":null, "speedTier":null},
       {"id":1193, "vsdId":"b0742b2f-331e-476a-8c4d-891548478e59", "organizationId":4072, "branchPackage":null, "speedTier":null}]
      },
    '''
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the class.  
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self, portal_data_fetcher):
        logger.info("Welcome to the Portal Organization Report Handler class")
        
        self.portal_data_fetcher  =  portal_data_fetcher

        self.validate_user_arguments()
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def construct_subscriber_branch_record_dict_list(self):
        logger.info("starting")

        json_org_object_list      =  self.portal_data_fetcher.fetch_organization_report()
        org_record_instance_list  =  self.construct_org_record_instance_list(json_org_object_list)

        subscriber_branch_record_dict_list  =  []
    
        for org_record in org_record_instance_list:
            logger.info("Org record:  Org id {}, name {}".format(org_record.org_id, org_record.org_name))
            logger.info("Org record:  is reseller? {}, is subscriber {}".format(org_record.is_org_a_reseller, org_record.is_org_a_subscriber))
        
            if org_record.is_org_a_subscriber:
                subscriber_branch_record_dict                          =  {}
                subscriber_branch_record_dict['subscriber_id']         =  org_record.org_id
                subscriber_branch_record_dict['subscriber_name']       =  org_record.org_name
                subscriber_branch_record_dict['parent_reseller_id']    =  org_record.parent_org_id
                subscriber_branch_record_dict['parent_reseller_name']  =  org_record.parent_org_name
                subscriber_branch_record_dict['parent_reseller_uuid']  =  org_record.parent_org_uuid
                subscriber_branch_record_dict['number_of_branches']    =  0
                subscriber_branch_record_dict['branch_detail_list']    =  []
            
                subscriber_branch_record_dict_list.append(subscriber_branch_record_dict)
    
        logger.info("ending")
        return subscriber_branch_record_dict_list
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def construct_org_record_instance_list(self, json_org_object_list):
        logger.debug("starting")

        org_record_instance_list  =  []
    
        for json_org_object in json_org_object_list:
            logger.debug("json Object is {}".format(json_org_object))

            org_record_instance  =  self.convert_json_object_to_org_record(json_org_object)

            org_record_instance_list.append(org_record_instance)

        logger.debug("ending")
        return org_record_instance_list
#---------------------------------------------------------------------------------------------------------------  


#-------------------------------------------------------------------------------------------------------------------------------------------  
# call this to convert a JSON object representing a top-level Organization into an instance of PortalOrgClass
#-------------------------------------------------------------------------------------------------------------------------------------------  
    def convert_json_object_to_org_record(self, json_object):
        logger.info("starting for json object {}".format(json_object))
    
        my_vsd_id              =  json_object['vsdId']
        my_org_id              =  json_object['id']
        my_org_name            =  json_object['name']
        my_parent_org_id       =  None
        my_parent_org_name     =  None
        my_parent_org_uuid     =  None

        my_parent_json_object  =  json_object['parentOrganization']
        if my_parent_json_object:
            my_parent_org_id    =  my_parent_json_object['id']
            my_parent_org_name  =  my_parent_json_object['name']
            my_parent_org_uuid  =  my_parent_json_object['vsdId']

        org_record_instance  =  PortalOrgRecordClass(my_org_id, my_org_name, my_vsd_id, my_parent_org_id, my_parent_org_name, my_parent_org_uuid)
    
        logger.info("ending with org_instance id {} and name {}".format(org_record_instance.org_id, org_record_instance.org_name))
        return org_record_instance
#-------------------------------------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
# Ensure that initialization arguments pass some simple validation
#---------------------------------------------------------------------------------------------------------------  
    def validate_user_arguments(self):
        logger.debug("starting")
        
        if self.portal_data_fetcher:
            pass
        else:
            msg = 'ERROR: Portal Data Fetcher instance is missing'
            logger.error(msg)
            raise Exception(msg)

        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  


class PortalOrgRecordClass(object):

#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the PortalOrgRecordClass class.  
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self, org_id, org_name, org_vsd_id, parent_org_id, parent_org_name, parent_org_uuid):
        logger.debug("Welcome to the Portal Organization class")
        self.org_id                =  org_id
        self.org_name              =  org_name
        self.org_vsd_id            =  org_vsd_id
        self.parent_org_id         =  parent_org_id
        self.parent_org_name       =  parent_org_name
        self.parent_org_uuid       =  parent_org_uuid

        self.is_org_a_reseller     =  False
        self.is_org_a_subscriber   =  False

        self.assign_business_attributes()
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def assign_business_attributes(self):
        logger.debug("starting for organization id {}, name {}".format(self.org_id, self.org_name))
        
        if self.org_id == 1:
            logger.debug("found root CSP organization - skipping ")
            return
        
        if self.parent_org_id == 1:
            self.is_org_a_reseller    =  True
        else:
            self.is_org_a_subscriber  =  True
            
        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  
