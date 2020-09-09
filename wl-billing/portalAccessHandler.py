import logging
import json

logger = logging.getLogger(__name__)

class PortalAccessHandler(object):

#---------------------------------------------------------------------------------------------------------------  
# This function initializes an instance of the class.  
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self, portal_access_config_dict, portal_http_requester):
        logger.info("Welcome to the Portal Access Handler class")
        
        self.required_config_names      =  ['portal_login_URL', 'portal_oauth_URL', 'portal_token_URL', 'oauth_client_id', 'oauth_client_secret', 
                                            'portal_user', 'portal_password', 'portal_organization']

        self.portal_access_config_dict  =  portal_access_config_dict
        self.portal_http_requester      =  portal_http_requester

        self.validate_user_arguments()
        
        for config_name in self.required_config_names:
            config_value  =  portal_access_config_dict[config_name]
            logger.debug("assigning config name {} and value {}".format(config_name, config_value))
            setattr(self, config_name, config_value)

        self.auth_token                =  None
        self.auth_code                 =  None
        self.access_token              =  None
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def authenticate_and_create_access_token(self):
        logger.info("starting")

        self.fetch_auth_token()
        self.fetch_auth_code()
        self.fetch_access_token()
        
        logger.info("ending with access token {}".format(self.access_token))
        return self.access_token
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def fetch_auth_token(self):
        logger.debug("starting")

        payload_dict     =  {"username" : self.portal_user, "password" : self.portal_password, "organization" : self.portal_organization}
        header_dict      =  {"client_app" : "react", "client_id" : self.oauth_client_id, "client_secret" : self.oauth_client_secret}

        json_string      =  json.dumps(payload_dict)
        response         =  self.portal_http_requester.issue_post_request(self.portal_login_URL, headers = header_dict, data = json_string, auth = None)
        result_dict      =  response.json()
    
        self.auth_token  =  result_dict['authToken']

        logger.debug("ending with auth token {}".format(self.auth_token))
        return self.auth_token
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def fetch_auth_code(self):
        logger.debug("starting")

        payload_dict    =  {"client_id" : self.oauth_client_id, "response_type" : "code", "keep_session_alive" : "true", "language" : "en", "auth_token" : self.auth_token}
    
        response        =  self.portal_http_requester.issue_head_request(self.portal_oauth_URL, headers = None, params = payload_dict)
        location        =  response.headers['Location']

        search_string   = 'sdwan?code='
        start_position  =  location.find(search_string)
        end_position    =  len(location)
    
        self.auth_code  =  location[(start_position + len(search_string)) : end_position]

        logger.debug("ending with auth code {}".format(self.auth_code))
        return self.auth_code
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def fetch_access_token(self):
        logger.debug("starting")

        payload_dict  =  { 'grant_type' : 'authorization_code', 'code' : self.auth_code}
        auth_tuple    =  (self.oauth_client_id, self.oauth_client_secret)
        response      =  self.portal_http_requester.issue_post_request(self.portal_token_URL, headers = None, data = payload_dict, auth = auth_tuple)
        
        result_dict         =  response.json()
        self.access_token   =  result_dict['access_token']

        logger.debug("ending with access token {}".format(self.access_token))
        return self.access_token
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
            
        if self.portal_http_requester:
            pass
        else:
            msg = 'ERROR: Portal HTTP Requester instance is missing'
            logger.error(msg)
            raise Exception(msg)

        logger.debug("ending")
        return
#---------------------------------------------------------------------------------------------------------------  
