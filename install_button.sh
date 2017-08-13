#!/usr/bin/env bash
#
# Installation script of button recognition scripts
#
# WaterMeButton
# https://github.com/vektorious/WaterMeButton
#
# Copyright (C) 2017-2017 Alexander Kutschera <alexander.kutschera@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
echo "installing scapy and tcpdump" &&
sudo apt-get install scapy &&
sudo apt-get install tcpdump &&
echo "please enter the mac adress of your Dash Button (IMPORTANT: put it in quotes and keep the letters in lowercase like this: 'ac:63:be:03:1a:7c')" &&
read macadress &&
sed -i 's/mac_to_action =.*/mac_to_action = {'$macadress' : button_pressed_dash1}/' dash_test.py &&
sudo chmod +x dash_test.py &&
echo "Let's test it, press the button and see if it recognized! (press strg + c to end testing)" &&
sudo python dash_test.py &&
echo "" &&
echo "did it work?" &&
read input
  case $input in
    [Yy]* ) echo "Great!";;
    [Nn]* ) echo "Ok. Then this install script will stop now! Maybe you entered the wrong mac adress";
            echo "If you found out the mac adress of the Dash Button start the dash button recognition scripts install file by typing 'sudo ./install_button.sh'";
            exit 1;;
  esac
echo "Setting up final script..." &&
sed -i 's/mac_to_action =.*/mac_to_action = {'$macadress' : button_pressed_dash1}/' WaterMeButton.py &&
sudo chmod +x WaterMeButton.py &&
echo "Setup complete! You can start the final script bei typing 'sudo python WaterMeButton.py'" &&
echo "If you want to run the script in the background type 'sudo nohup python WaterMeButton.py &'" &&
echo "Have fun with the script! Cheers, Alex"
exit 1
