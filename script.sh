#!/bin/bash
sudo apt install python3 -y
sudo apt-get install python3-venv -y
python3 -m venv venv
. venv/bin/activate
pip3 install -r requirements.txt
python3 product_list_app.py
