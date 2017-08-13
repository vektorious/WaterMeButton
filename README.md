# WaterMeButton

<p align="center">
<img src="https://github.com/vektorious/WaterMeButton/blob/master/img/OPS-logo.png"/>
</p>

2017-08-12 Alex Kutschera, alexander.kutschera@tum.de

This script was developed to help distracted people like me not to forget to water their plants. It was intended to be used by plant scientists but I guess it is also useful at home!
Just place an hacked amazon dash button next to your plants and every time you watered them (or checked them and their are still fine) press the button. If you should forget to water them (and not press the button) you will receive an email reminder to check your plants!

All you need is an amazon dash button, a raspberry pi (It actually would work with any computer but the install script is adjusted to the RPi), a GMail account and a WiFi network.

Before you start the software setup you should prepare your amazon dash button first! Activate it as described in the instructions. Depending on if you want to get your money back you paid for the dash button you can order one product with it, reset the button and don't choose a product to order. If you don't want to do that just follow the setup until you have to choose a product and then just close the amazon application and stop the setup at this point. Now you should receive a notification on your phone every time you press the button saying you should finish the setup process of the button. You can either ignore this or block the button from accessing the internet via your router.

### Setup
You will need your Email account data and the mac address of your button. You can detect the mac address by scanning your local network after pressing the button or by monitoring connected devices on your router.  
!For now it works only with GMAIl!

type this into the shell:

>cd /home/pi  
>sudo git clone https://github.com/vektorious/WaterMeButton.git  
>cd WaterMeButton  
>sudo chmod +x install.sh  
>sudo ./install.sh

This should install everything. If you should encounter any problems you might have to set it up manually. Here are the example contents of the Email config files:

open file: sudo nano /etc/ssmtp/ssmtp.conf

root=postmaster  
mailhub=smtp.gmail.com:587  
hostname=raspberrypi  
AuthUser=InsertGMailUserName@gmail.com  
AuthPass=InsertGMailPassword  
FromLineOverride=YES  
UseSTARTTLS=YES  

Test if it works:  
echo "Test email" | ssmtp -F"Test Name" -v recipient@emailadress
