#!/usr/bin/python3

import argparse
import logging
import loggingUtilities
import boto3
import os
import shutil

logger = logging.getLogger()

#---------------------------------------------------------------------------------------------------------------  
def arg_handler():
    logger.info("starting")
    parser_instance  =  argparse.ArgumentParser()

    parser_instance  =  loggingUtilities.add_supported_run_time_args_to_parser(parser_instance)
    
    parser_instance.add_argument('-bn', '--bucketName',    action='store', dest='bucket_name',    required=True, help='S3 Bucket Name (wl-billing-test)' )
    parser_instance.add_argument('-fn', '--folderName',    action='store', dest='folder_name',    required=True, help='S3 Folder Name (daily-reports)' )
    parser_instance.add_argument('-dn', '--directoryName', action='store', dest='directory_name', required=True, help='EC2 Full Directory Path Name' )
    parser_instance.add_argument('-an', '--archiveName',   action='store', dest='archive_name',   required=True, help='EC2 Full Archive Path Name' )

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
    
    s3                 =  boto3.resource('s3')
    source_directory   =  run_time_args.directory_name
    archive_directory  =  run_time_args.archive_name
    
    file_list  =  os.listdir(source_directory)
    logger.info("found file list {}".format(file_list))

    for filename in os.listdir(source_directory):
        logger.info("found file name {}".format(filename))
        source_file_name            =  source_directory + '/' + filename
        target_bucket_name          =  run_time_args.bucket_name
        target_folder_and_filename  =  run_time_args.folder_name + '/' + filename
        s3.meta.client.upload_file(source_file_name, target_bucket_name, target_folder_and_filename)
        shutil.move(source_file_name, archive_directory)

    logger.info("ending")
#---------------------------------------------------------------------------------------------------------------  



if __name__ == '__main__':
    main()
