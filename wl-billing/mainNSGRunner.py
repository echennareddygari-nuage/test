#!/usr/bin/python3

import argparse
import logging
import loggingUtilities
import portalDataFetcher
import portalOrgReportHandler
import portalBranchDataExtractor
import portalAccessConfig
import portalAccessHandler
import portalExtractFormatConfig
import portalHttpRequester

logger = logging.getLogger()

#---------------------------------------------------------------------------------------------------------------  
def arg_handler():
    logger.info("starting")
    parser_instance  =  argparse.ArgumentParser()

    parser_instance.add_argument('-cfg', '--portalConfig',  action='store',  dest='portal_config_name',  required=True, help='Portal Configuration (DEV-01)' )
    parser_instance.add_argument('-fmt', '--extractFormat', action='store',  dest='data_extract_format', required=True, help='Extract Format Name (FORMAT-01)' )

    parser_instance  =  loggingUtilities.add_supported_run_time_args_to_parser(parser_instance)
   
    run_time_args    =  parser_instance.parse_args()
    
    loggingUtilities.override_default_logging_if_args_provided(run_time_args)

    logger.info("ending")
    return run_time_args
#---------------------------------------------------------------------------------------------------------------  


#---------------------------------------------------------------------------------------------------------------  
def main():
    loggingUtilities.establish_default_logging()
    logger.info("starting")
    run_time_args  =  arg_handler()
    
    portal_access_config_instance       =  portalAccessConfig.PortalAccessConfig()
    portal_access_config_dict           =  portal_access_config_instance.get_portal_configuration_dict_by_name(run_time_args.portal_config_name)
    
    extract_format_config_instance      =  portalExtractFormatConfig.PortalExtractFormatConfig()
    csv_layout_list                     =  extract_format_config_instance.get_extract_format_list_by_name(run_time_args.data_extract_format)

    portal_http_requester               =  portalHttpRequester.PortalHttpRequester()
    portal_branch_data_extractor        =  portalBranchDataExtractor.PortalBranchDataExtractor(portal_access_config_dict)
    
    portal_access_handler               =  portalAccessHandler.PortalAccessHandler(portal_access_config_dict, portal_http_requester)
    access_token                        =  portal_access_handler.authenticate_and_create_access_token()

    portal_data_fetcher                 =  portalDataFetcher.PortalDataFetcher(portal_access_config_dict, access_token, portal_http_requester)

    portal_org_report_handler           =  portalOrgReportHandler.PortalOrgReportHandler(portal_data_fetcher)
    subscriber_branch_record_dict_list  =  portal_org_report_handler.construct_subscriber_branch_record_dict_list()
    
    actual_branch_count                 =  0

    for subscriber_record in subscriber_branch_record_dict_list:
        subscriber_id                            =  subscriber_record['subscriber_id']
        number_of_branches                       =  portal_data_fetcher.fetch_number_of_branches_for_subscriber(subscriber_id)
        subscriber_record['number_of_branches']  =  number_of_branches
        json_subscriber_branch_object_list       =  portal_data_fetcher.fetch_subscriber_branch_detail_data(subscriber_id, number_of_branches)
        subscriber_record['branch_detail_list']  =  json_subscriber_branch_object_list
        subscriber_record['']
        actual_branch_count                     +=  len(json_subscriber_branch_object_list)

    portal_branch_data_extractor.extract_branches_to_csv(subscriber_branch_record_dict_list, csv_layout_list)

    logger.info("actual branch count is {}".format(actual_branch_count))
    logger.info("ending")
#---------------------------------------------------------------------------------------------------------------  
        

if __name__ == '__main__':
    main()
