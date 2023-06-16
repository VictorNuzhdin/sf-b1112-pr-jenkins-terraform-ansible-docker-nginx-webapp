#!/bin/bash

##--00. Check result Flags
isIndexPageAccessible="notSet"
isIndexInstancesEqual="notSet"


##--01. Checking index page accessibility
#
PAGE_URL="http://jenkins.dotspace.ru:8001"
#PAGE_URL="http://jenkins.dotspace.ru:8001/fake"  ## negative test 1
#
PAGE_STATUS="$(curl -sI $PAGE_URL | head -n 1 | cut -d $' ' -f2)"
PAGE_TITLE="$(curl -s $PAGE_URL | grep '<title>' | awk '{$1=$1;print}' | sed -e 's/<[^>]*>//g')"

##--If Page Access check Success
if [ "$PAGE_STATUS" = 200 ]; then
	isIndexPageAccessible="true"
fi
##--If page Access check Failed
if [ "$PAGE_STATUS" != 200 ]; then
	#CHECK_RESULT="FAILED :: WebServer is disabled/blocked | Webapp is NOT running | Page is NOT available"
    isIndexPageAccessible="false"
fi


##--02. Checking index page integrity
#
##--Page instances URLs
PAGE_ON_GITHUB="https://github.com/VictorNuzhdin/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp/blob/main/src/index.html"
PAGE_URL_GITHUB="https://raw.githubusercontent.com/VictorNuzhdin/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp/main/src/index.html"
PAGE_URL_JENKINS="src/index.html"
PAGE_URL_DOCKER="http://jenkins.dotspace.ru:8001"
#PAGE_URL_JENKINS="src/js/index.js"                      ## negative test 2
#PAGE_URL_DOCKER="http://jenkins.dotspace.ru:8001/fake"  ## negative test 3

##--Page instances MD5 checksums
PAGE_MD5_GITHUB="$(curl -sL $PAGE_URL_GITHUB | md5sum | cut -d ' ' -f 1)"
PAGE_MD5_JENKINS="$(md5sum $PAGE_URL_JENKINS | cut -d ' ' -f 1)"
PAGE_MD5_DOCKER="$(curl -sL $PAGE_URL_DOCKER | md5sum | cut -d ' ' -f 1)"

if [[ $PAGE_MD5_GITHUB = $PAGE_MD5_JENKINS && $PAGE_MD5_JENKINS = $PAGE_MD5_DOCKER ]]; then
    ## All index.html page instances are equals by md5 checksum
    isIndexInstancesEqual="true"
else
    ## If one of the page instance IS NOT equal others by md5 checksum
    isIndexInstancesEqual="false"
fi


##--03. Print check results (DEBUG)
#echo "isIndexPageAccessible: $isIndexPageAccessible"
#echo "isIndexInstancesEqual: $isIndexInstancesEqual"


##--04. Final checks and send message if Check result is false
#
NOTIFICATION_MSG=""
APP_LINKS=' (<a href="http://jenkins.dotspace.ru:8001">webapp</a>, <a href="https://jenkins.dotspace.ru/">jenkins</a>, <a href="https://github.com/VictorNuzhdin/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp">github</a>)'
APP_LINKS_SHORT=' (<a href="http://jenkins.dotspace.ru:8001">webapp</a>, <a href="https://jenkins.dotspace.ru/">jenkins</a>)'

## webapp is running and index.html page instances are equals by md5 checksum
if [[ "$isIndexPageAccessible" == "true" && $isIndexInstancesEqual == "true" ]]; then
    echo "WebApp Verification SUCCESS"
    NOTIFICATION_MSG="Application deployment SUCCESS :: WebApp is RUNNING and accessible and index.html md5 intergrity checks SUCCESS ${APP_LINKS}"
    echo $NOTIFICATION_MSG

## webapp is NOT running OR one of the index.html page instance is NOT equal others by md5 checksum
else
    echo "WebApp Verification FAILED"
    if [[ "$isIndexPageAccessible" == "false" ]]; then
        NOTIFICATION_MSG="Application deployment FAILED :: WebApp is NOT accessible! Maybe not running, or blocked by firewall rules ${APP_LINKS_SHORT}"
    fi
    if [[ "$isIndexPageAccessible" == "true" && "$isIndexInstancesEqual" == "false" ]]; then
        NOTIFICATION_MSG="Application is deployed and running, but index.html md5 integrity check is FAILED ${APP_LINKS}"
    fi
    #echo $NOTIFICATION_MSG

    ##--05. Run Python script and send notification message to personal Telegram channel
    ./sendTgMsg.py --message "$NOTIFICATION_MSG"
fi
