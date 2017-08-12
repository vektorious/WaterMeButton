Works only with GMAIl

cd /home/pi
sudo git clone https://github.com/vektorious/WaterMeButton.git
cd WaterMeButton
sudo chmod +x install.sh
sudo ./install.sh

sudo nano /etc/ssmtp/ssmtp.conf

root=postmaster
mailhub=smtp.gmail.com:587
hostname=raspberrypi
AuthUser=InsertGMailUserName@gmail.com
AuthPass=InsertGMailPassword
FromLineOverride=YES
UseSTARTTLS=YES

Test if it works:
echo "Test email" | ssmtp -F"Test Name" -v recipient@emailadress
