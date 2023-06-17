#!/bin/bash


##--Creating an Activating Python Virtual Environment (venv) and install required packages
python3 -m venv env
source env/bin/activate
pip install -r ./requirements.txt

##--Check Python version
python --version
