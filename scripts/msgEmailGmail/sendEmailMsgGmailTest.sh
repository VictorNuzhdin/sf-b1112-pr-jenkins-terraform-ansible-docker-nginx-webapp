#!/bin/bash


##--Activating Python Virtual Environment (venv), send test message and deactivating venv
source env/bin/activate

./sendEmailMsgGmail.py --message 'Application deployed successfully (<a href="http://jenkins.dotspace.ru:8001">webapp</a>, <a href="https://jenkins.dotspace.ru/">jenkins</a>, <a href="https://github.com/VictorNuzhdin/sf-b1112-pr-jenkins-terraform-ansible-docker-nginx-webapp">github</a>)'

deactivate
