#!/bin/bash
#
if [ $# -eq 2 ]; then
    # Send some info to log for troubleshooting
    /bin/echo "\nSending message to following number: ${1}" &>> /home/ec2-user/scripts/pinpoint/voicecall.log
    /bin/echo "\nMessage text: ${2}" &>> /home/ec2-user/scripts/pinpoint/voicecall.log

    # build the json string
    json='{"Content": {"PlainTextMessage": {"Text": "'
    json+="${2}"
    json+='", "VoiceId": "Salli"}}, "OriginationPhoneNumber": "+15874093016","DestinationPhoneNumber": "'
    json+="${1}"
    json+='" }'

    # log the json string for troubleshooting
    /bin/echo "JSON string: ${json}" &>> /home/ec2-user/scripts/pinpoint/voicecall.log

    # execute the voice call
    /bin/aws pinpoint-sms-voice send-voice-message --cli-input-json "${json}" &>> /home/ec2-user/scripts/pinpoint/voicecall.log
else
    /bin/echo -e "\nThis script requires 2 parameters."
    /bin/echo -e "\nUsage: ${0} +12345678900 'My message here'\n"
fi
