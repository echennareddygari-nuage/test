This file describes how to run the Python scripts that extract reseller and subscriber data from the Portal.

Script files required:
  mainNSGRunner.py           - main Python script
  loggingUtilities.py        - default logging configuration (see file for override options)
  portalDataFetcher          - fetches data from portal such as Organizational Report, subscriber branch data
  portalOrgReportHandler     - fetches and processes branches from the Organizational Report
  portalBranchDataExtractor  - formats subscriber branch data into CSV format
  portalAccessConfig         - defines portal credentials, URL, CSV output file and run-time argument name for each portal instance
  portalAccessHandler        - handles authentication to the portal such as login and fetching tokens
  portalExtractFormatConfig  - defines available CSV output format options and run-time argument name for each option
  portalHttpRequester        - uses Python <requests> package to issue GET, HEAD and POST http requests to the portal 

Enhancements:
  1. Would be nice to specify output file as a run-time argument and not as configuration setting in portalAccessConfig.py
     - see file portalAccessConfig  portal_dev_1_dict['extract_file_path'] =  "C:/Users/lpaquett\OneDrive - Nokia/workspace/vnsProject/src/"
     - for this version, change this entry for each portal instance to direct path to CSV output file
  
Example calls:
  mainNSGRunner.py -cfg DEV-02 -fmt FORMAT-01                           -> use portal DEV-2, CSV format "FORMAT-01" (log at INFO level to debug.log)
  mainNSGRunner.py -cfg DEV-01 -fmt FORMAT-01                           -> use portal DEV-1, CSV format "FORMAT-01" (log at INFO level to debug.log)
  mainNSGRunner.py -cfg DEV-02 -fmt FORMAT-01 -ll DEBUG -lf wl-test.log -> use portal DEV-2, CSV format "FORMAT-01" (log at DEBUG level to wl-test.log)

Run time Python environment:
  Need Python 3.7 or 3.8 and packages requests, argparse, logging, json, time, datetime
  