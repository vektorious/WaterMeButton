#!/usr/bin/env bash
#
# Installation script
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

echo "Starting WaterMeButton installation" &&
echo "Updating Raspberry Pi..." &&
sudo apt-get update &&
echo "installing ssmtp" &&
sudo apt-get install ssmtp &&
sudo apt-get install mailutils &&
echo "Type the GMail adress you want to send emails from:" &&
read email &&
echo "And the password for this account:" &&
read password &&
sed -i 's/mailhub=.*/mailhub=smtp.gmail.com:587/' /etc/ssmtp/ssmtp.conf &&
echo "AuthUser="$email >> /etc/ssmtp/ssmtp.conf &&
echo "AuthPass="$password >> /etc/ssmtp/ssmtp.conf &&
echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf &&
echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf &&
echo "Now let's see if it works" &&
echo "Enter an email adress you want to send a test email to:" &&
read emailadress &&
echo "Test email" | ssmtp -F"Test Name" -v $emailadress &&
echo "Did it work? Give it some time! (y/n)" &&
read input &&
  case $input in
    [Yy]* ) echo "Great!";;
    [Nn]* ) echo "Then try again. email adress to send the email to:";
            read emailadress2;
            echo "Test email" | ssmtp -F"Test Name" -v $emailadress;
            echo "Did it work? Maybe wait a bit longer this time (y/n)",
            read input2
              case $input2 in
                [Yy]* ) echo "Great!";;
                [Nn]* ) echo "Sorry.. Maybe try again"; exit;;
              esac
  esac
echo "Setting up email send script:" &&
echo "Enter emailadress which should recieve the reminder emails" &&
read recipient &&
echo "Now enter the sender name" &&
read sender &&
echo "And the subject:" &&
read subject &&
echo "writing personal email send script..." &&
echo "#!/bin/bash" >> send_mail.sh &&
echo "message=\$1" >> send_mail.sh &&
echo "{" >> send_mail.sh &&
echo -e "\t echo To: $recipient" >> send_mail.sh &&
echo -e "\t echo From: $sender" >> send_mail.sh &&
echo -e "\t echo Subject: $subject" >> send_mail.sh &&
echo -e "\t echo \$message" >> send_mail.sh &&
echo -e "\t } | ssmtp $recipient" >> send_mail.sh &&
sudo chmod +x send_mail.sh &&
echo "Let's test if your script works!" &&
echo "sendig test email..." &&
./send_mail.sh "This ist a test email" &&
echo "Did it work? Give it some time! (y/n)" &&
read input &&
  case $input in
    [Yy]* ) echo "Great!";;
    [Nn]* ) echo "Ok, do you want so modify the script manually as described in the README?  (y/n)";
            read input2
              case $input2 in
                [Yy]* ) echo "Great! Do this wenn the script has finished!";;
                [Nn]* ) echo "Sorry.. Maybe try again"; exit;;
              esac
  esac
echo "installing dash button recognition scripts..." &&
echo "You have to know the mac adress of your Dash Button befor you go on!" &&
echo "Do you have it ready? (y/n)" &&
read input
  case $input in
    [Yy]* ) echo "Great!";;
    [Nn]* ) echo "Ok. Then this install script will stop now!";
            echo "If you found out the mac adress of the Dash Button start the dash button recognition scripts install file by typing 'sudo ./install_button.sh'";
            exit 1;;
  esac
sudo chmod +x install_button.sh  &&
sudo ./install_button.sh &&

exit 1
