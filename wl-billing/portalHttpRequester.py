import logging
import requests

logger = logging.getLogger(__name__)

requests.urllib3.disable_warnings()

class PortalHttpRequester:
    
#---------------------------------------------------------------------------------------------------------------  
    def __init__(self):
        logger.info("Welcome to the Portal HTTP Requester Class")
#---------------------------------------------------------------------------------------------------------------  

        
#---------------------------------------------------------------------------------------------------------------  
    def issue_get_request_basic(self, url, headers):
        logger.debug("starting issuing GET to URL {} with headers {}".format(url, headers))

        try:
            response_object  =  requests.get(url, verify=False, headers=headers)
            logger.debug("GET Response status code is {}".format(response_object.status_code))
            logger.debug("GET Response headers is {}".format(response_object.request.headers))
            logger.debug("GET Response body is {}".format(response_object.request.body))
            response_object.raise_for_status()
            
            if response_object.status_code != 200:
                msg = 'Invalid status code {} for GET Request '.format(response_object.status_code)
                logger.error(msg)
                raise Exception(msg)
            
        except requests.exceptions.RequestException as e:
            msg = "GET Request failed: " + str(e)
            logger.exception(msg)
            raise Exception(msg)

        logger.debug("GET response code is {} with text {}".format(response_object.status_code, response_object.text))
        return response_object
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def issue_head_request(self, url, headers, params):
        logger.debug("starting issuing HEAD to URL {} with headers {} and params {}".format(url, headers, params))

        try:
            response_object  =  requests.head(url, verify=False, headers=headers, params=params)
            logger.debug("HEAD Response status code is {}".format(response_object.status_code))
            logger.debug("HEAD Response headers is {}".format(response_object.request.headers))
            logger.debug("HEAD Response body is {}".format(response_object.request.body))
            response_object.raise_for_status()
            
            if response_object.status_code in [204, 302]:
                pass
            else:
                msg = 'Invalid status code {} for HEAD Request '.format(response_object.status_code)
                logger.error(msg)
                raise Exception(msg)
            
        except requests.exceptions.RequestException as e:
            msg = "HEAD Request failed: " + str(e)
            logger.exception(msg)
            raise Exception(msg)

        logger.debug("HEAD response code is {} with text {}".format(response_object.status_code, response_object.text))
        return response_object
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
    def issue_post_request(self, url, data, auth, headers):
        logger.debug("starting issuing POST to URL {} with data {}, auth {}, and headers {}".format(url, data, auth, headers))

        try:
            response_object  =  requests.post(url, data=data, verify=False, headers=headers, auth=auth)
            logger.debug("POST Response status code is {}".format(response_object.status_code))
            logger.debug("POST Response headers is {}".format(response_object.request.headers))
            logger.debug("POST Response body is {}".format(response_object.request.body))
            response_object.raise_for_status()

            if response_object.status_code != 200:
                msg = 'Invalid status code {} for POST Request '.format(response_object.status_code)
                logger.error(msg)
                raise Exception(msg)
            
        except requests.exceptions.RequestException as e:
            msg = "POST Request failed: " + str(e)
            logger.exception(msg)
            raise Exception(msg)

        logger.debug("POST response code is {} with text {}".format(response_object.status_code, response_object.text))
        return response_object
#---------------------------------------------------------------------------------------------------------------  
