#!./env/bin/python
## /usr/bin/python3

## Step-00
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
import json
from datetime import datetime as dt
import telebot 
from telethon.sync import TelegramClient 
from telethon.tl.types import InputPeerUser, InputPeerChannel
from telethon import TelegramClient, sync, events

## Step-01.1
parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
parser.add_argument("-m", "--message", default="Empty message", help="Notification message that is being sent to Telegram")
args = vars(parser.parse_args())

## Step-01.2
msg_body = args["message"]

## Step-02.1
with open('config.json', 'r') as f:
    config = json.load(f)

## Step-02.2
PROJECT_TITLE  = config['PROJECT_TITLE']
TG_APP_API_ID = config['TG_APP_API_ID']
TG_APP_API_HASH = config['TG_APP_API_HASH']
TG_USER_PHONE = config['TG_USER_PHONE']
TG_USER_NAME = config['TG_USER_NAME']
TG_USER_ID = config['TG_USER_ID']
TG_ACCESS_HASH = config['TG_ACCESS_HASH']

## Step-03
ts = dt.now().strftime("%Y.%m.%d %H:%M:%S")
msg_text = ts + " :: " + msg_body

## Step-04
client = TelegramClient('session', TG_APP_API_ID, TG_APP_API_HASH)

## Step-05
client.connect()
print("Telegram client session opened")

## Step-06
if not client.is_user_authorized(): 
    ## Step-06.1
	client.send_code_request(TG_USER_PHONE) 
	## Step-06.2
	client.sign_in(TG_USER_PHONE, input('Enter the code: ')) 
try:
    ## Step-07.0
    #print(client.get_input_entity(TG_USER_NAME))
    
    ## Step-07.1
    receiver = InputPeerUser(int(TG_USER_ID), int(TG_ACCESS_HASH))

    ## Step-08
    client.send_message(receiver, msg_text, parse_mode='html')
    print('Message sent: ' + msg_text)

except Exception as e:
    ## Step-09
    print(e)


## Step-10
client.disconnect()
print("Telegram client session closed")
