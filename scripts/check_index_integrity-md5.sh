#!/bin/bash

##--Check index page integrity

## Page instances URLs
PAGE_ON_GITHUB="https://github.com/VictorNuzhdin/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp/blob/main/src/index.html"
PAGE_URL_GITHUB="https://raw.githubusercontent.com/VictorNuzhdin/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp/main/src/index.html"
PAGE_URL_JENKINS="src/index.html"
PAGE_URL_DOCKER="http://jenkins.dotspace.ru:8001"
#PAGE_URL_JENKINS="src/js/index.js"
#PAGE_URL_DOCKER="http://jenkins.dotspace.ru:8001/fake"  ## negative test

## Page instances MD5 checksums
PAGE_MD5_GITHUB="$(curl -sL $PAGE_URL_GITHUB | md5sum | cut -d ' ' -f 1)"
PAGE_MD5_JENKINS="$(md5sum $PAGE_URL_JENKINS | cut -d ' ' -f 1)"
PAGE_MD5_DOCKER="$(curl -sL $PAGE_URL_DOCKER | md5sum | cut -d ' ' -f 1)"

## Test
#echo $PAGE_MD5_GITHUB; echo $PAGE_MD5_JENKINS; echo $PAGE_MD5_DOCKER

##=TEST_OUTPUT:
#    72bb11570bb43d519088dd638e1364b4
#    72bb11570bb43d519088dd638e1364b4
#    72bb11570bb43d519088dd638e1364b4
#


## Comparing index.html instances by MD5 checksum
#
CHECK_RESULT=""
CHECK_RESULT_DESCR=""

## If all page instances are equals
#if [ $PAGE_MD5_GITHUB = "72bb11570bb43d519088dd638e1364b4" ]; then   ## positive test
#if [ $PAGE_MD5_GITHUB = "72bb11570bb43d519088dd638e1364b4_" ]; then  ## negative test
#
#if [ $PAGE_MD5_GITHUB = $PAGE_MD5_LOCAL ]; then                                              ## SUCCESS
#if [ $PAGE_MD5_JENKINS = $PAGE_MD5_DOCKER ]; then                                            ## SUCCESS
#if [ $PAGE_MD5_GITHUB = $PAGE_MD5_JENKINS && $PAGE_MD5_JENKINS = $PAGE_MD5_DOCKER ]; then    ## FAILED  ??
#if [[ $PAGE_MD5_GITHUB = $PAGE_MD5_JENKINS && $PAGE_MD5_JENKINS = $PAGE_MD5_DOCKER ]]; then  ## SUCCESS
#
if [[ $PAGE_MD5_GITHUB = $PAGE_MD5_JENKINS && $PAGE_MD5_JENKINS = $PAGE_MD5_DOCKER ]]; then
	CHECK_RESULT="SUCCESS"
        CHECK_RESULT_DESCR="All index.html page instances are equals by md5 checksum"
    else
        ## If one of the page instance IS NOT equal
        CHECK_RESULT="FAILED"
        CHECK_RESULT_DESCR="One of page instance IS NOT equal others by md5 checksum"
fi


## OUTPUT
clear
echo --Checking index page accessibility..
echo
echo "  CHECK_RESULT......: $CHECK_RESULT"
echo "  CHECK_RESULT_DESCR: $CHECK_RESULT_DESCR"
echo
echo "  PAGE_MD5_GITHUB...: $PAGE_MD5_GITHUB"
echo "  PAGE_MD5_JENKINS..: $PAGE_MD5_JENKINS"
echo "  PAGE_MD5_DOCKER...: $PAGE_MD5_DOCKER"
echo
echo "  --URLs"
echo "  PAGE_ON_GITHUB....: $PAGE_ON_GITHUB"
echo "  PAGE_ON_JENKINS...: $PAGE_URL_JENKINS"
echo "  PAGE_ON_DOCKER....: $PAGE_URL_DOCKER"
echo
