#!./env/bin/python
## /usr/bin/python3

## Step-00
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
import json
import time, datetime as dt
import os                                        ## read env variables
from decouple import config as config_env        ## read env variables from .env file
config_env.encoding = 'utf-8'
#
import sys                                       ## DEBUG: sys.exit()
#
import smtplib                                   ## buildin Python module
from email.mime.multipart import MIMEMultipart   ## MIME-Types (attach HTML-code)
from email.mime.base import MIMEBase             ## MIME-Types (attach Excel-file)
from email.mime.text import MIMEText             ## MIME-Types (attach Text-message)
from email.header import Header                  ## Headers
from email import encoders                       ## encoders.encode_base64(_part)



## Step-01.1
parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
parser.add_argument("-m", "--message", default="Empty message", help="Notification message that is being sent to Gmail")
args = vars(parser.parse_args())

## Step-01.2
EXTERNAL_MSG = args["message"]


## Step-02.1
with open('config.json', 'r') as f:
    config_json = json.load(f)

## Step-02.2
PROJECT_TITLE = config_json['PROJECT_TITLE']
#GMAIL_LOGIN  = config_json['GMAIL_LOGIN']
#GMAIL_2FPASS = config_json['GMAIL_2FPASS']
#GMAIL_LOGIN  = os.environ.get('GMAIL_LOGIN')
#GMAIL_2FPASS = os.environ.get('GMAIL_2FPASS')
GMAIL_LOGIN   = config_env('GMAIL_LOGIN')
GMAIL_2FPASS  = config_env('GMAIL_2FPASS')
MSG_SUBJECT   = config_json['MSG_SUBJECT']
MSG_TITLE     = config_json['MSG_TITLE']
LINK_JENKINS_SERVER = config_json['LINK_JENKINS_SERVER']
LINK_GITHUB_REPO    = config_json['LINK_GITHUB_REPO']


## Step-03
TS_NOW_1 = dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
TS_NOW_2 = dt.datetime.now().strftime("%Y-%m-%d")
EXTERNAL_MSG_BODY = TS_NOW_1 + " :: " + EXTERNAL_MSG

print(">>>EMAIL_TEXT:")                             ## debug_output
print(EXTERNAL_MSG_BODY)                            ## debug_output


## Step-04
##-gmail mail service parameters
smtpSrvHost = 'smtp.gmail.com' 
smtpSrvPort = 465                                   ## SSL

##-sender authorization data on gmail service
senderMail = GMAIL_LOGIN                            ## Login
senderPswd = GMAIL_2FPASS                           ## AppPassword with enabled 2FA

##-recievers email list
receiver = 'devops.dotspace@gmail.com'

##-costruct email body
subject = MSG_SUBJECT + " | " + TS_NOW_2
msgText = """<h2>{msg_title}</h2>
<br>
<p>{msg_text}</p>
<br>
<hr>
<a href="{link1}" target="_blank">{link1}</a><br>
<a href="{link2}" target="_blank">{link2}</a><br/>
""".format(msg_title=MSG_TITLE,msg_text=EXTERNAL_MSG_BODY,link1=LINK_JENKINS_SERVER,link2=LINK_GITHUB_REPO)


##-build email object
msg = MIMEMultipart('alternative')
msg.set_charset('utf8')

msg['FROM'] = senderMail
msg['To'] = receiver
msg['Subject'] = Header(subject, "utf-8")

_attach = MIMEText(_text = msgText.encode('utf-8'), _subtype='html', _charset='UTF-8')  ## _subtype='plain'
msg.attach(_attach)

##-sending email
try:
    #print('>>>SENDING_EMAIL..\n\n', msg)                           ##-with debug data
    with smtplib.SMTP_SSL(smtpSrvHost, smtpSrvPort) as session:
        #
        session.login(senderMail, senderPswd)                       ##-sender authorization on gmail
        session.sendmail(senderMail, receiver, msg.as_string())     ##-send email
    print('>>>EMAIL_SENT;')
#
##-catching and print errors
except smtplib.SMTPException as error:
    print('EMAIL_SEND_ERROR:\n', str(error))

##-exitting app
sys.exit()
