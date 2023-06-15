#!/bin/bash

##--Check index page accessibility
#PAGE_URL="http://jenkins.dotspace.ru:8001/fake"
PAGE_URL="http://jenkins.dotspace.ru:8001"
#
PAGE_STATUS="$(curl -sI $PAGE_URL | head -n 1 | cut -d $' ' -f2)"
PAGE_TITLE="$(curl -s $PAGE_URL | grep '<title>' | awk '{$1=$1;print}' | sed -e 's/<[^>]*>//g')"
#
CHECK_RESULT=""


##--If check Success
#
if [ "$PAGE_STATUS" = 200 ]; then
    CHECK_RESULT="SUCCESS"
fi

##--If check Failed
#
if [ "$PAGE_STATUS" != 200 ]; then
    CHECK_RESULT="FAILED :: WebServer is disabled/blocked | Webapp is NOT running | Page is NOT available"
fi


##--OUTPUT
clear
echo --Checking index page accessibility..
echo
echo "  PAGE_URL....: $PAGE_URL"
echo "  PAGE_STATUS.: $PAGE_STATUS"
echo "  PAGE_TITLE..: $PAGE_TITLE"
echo
echo "  CHECK_RESULT: $CHECK_RESULT"
echo

