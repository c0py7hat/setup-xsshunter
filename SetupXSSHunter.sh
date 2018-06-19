sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install language-pack-sv -y
sudo apt-get install certbot -y
sudo apt-get install nginx postgresql postgresql-contrib -y
sudo -i -u postgres 
psql template1
echo "Enter password for database user"
read password
psql -c "CREATE USER xsshunter WITH PASSWORD '$password';"
psql -c "CREATE DATABASE xsshunter;" 
exit
git clone https://github.com/mandatoryprogrammer/xsshunter
cd xsshunter/
sudo apt install python-pip -y
pip install pyyaml
./generate_config.py
sudo cp default /etc/nginx/sites-enabled/default
cd ~/
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
echo "Enter DNS name"
read DNSname
sudo ./certbot-auto certonly --server https://acme-v02.api.letsencrypt.org/directory --manual --preferred-challenges dns -d *.$DNSname -d $DNSname
sudo sed -i -e "s/\/etc\/nginx\/ssl\/$DNSname.crt;/\/etc\/letsencrypt\/live\/$DNSname\/cert.pem;/g" /etc/nginx/sites-enabled/default 
sudo sed -i -e "s/\/etc\/nginx\/ssl\/$DNSname.key;/\/etc\/letsencrypt\/live\/$DNSname\/privkey.pem;/g" /etc/nginx/sites-enabled/default 
sudo apt-get install python-virtualenv python-dev libpq-dev libffi-dev -y
cd ~/xsshunter/api/
virtualenv env
cd ~/xsshunter/gui/
virtualenv env
sudo mkdir /opt/xsshunter
sudo cp ~/xsshunter/* /opt/xsshunter/ -r
sudo mkdir /opt/xsshunter/api/uploads
sudo adduser xsshunter --shell /usr/sbin/nologin --disabled-login --disabled-password
sudo addgroup --system certs
sudo adduser xsshunter certs
sudo chgrp -R certs /etc/letsencrypt/
sudo chmod -R g+rx /etc/letsencrypt/
sudo chown -R xsshunter /opt/xsshunter
sudo -u xsshunter -s
cd /opt/xsshunter/api
. env/bin/activate && pip install -r requirements.txt
deactivate
wget https://gist.githubusercontent.com/jonasonline/603677d347558e1c062e3019d0eaa9f6/raw/9fdda8467d74c37cd576e40e1ff18b2c0d8fb167/xsshunter.api.start.sh -O /opt/xsshunter/api/start.sh
chmod +x /opt/xsshunter/api/start.sh
cd /opt/xsshunter/gui
. env/bin/activate && pip install -r requirements.txt
deactivate
wget https://gist.githubusercontent.com/jonasonline/5d38b2c140c8670268c0b3be3d6af65c/raw/f3da863245b58d4ca207f44c89c490f5e2ec839d/xsshunter.gui.start.sh -O /opt/xsshunter/gui/start.sh
chmod +x /opt/xsshunter/api/start.sh
exit
sudo chmod +x /opt/xsshunter/api/start.sh
sudo chmod +x /opt/xsshunter/gui/start.sh
sudo wget https://gist.githubusercontent.com/jonasonline/711b7c351e5ecfb6d3d57b1ac250ac33/raw/59ef43607a437e6ac668e8e95d4b3a64bb8949a2/xsshunterapi.service -O /etc/systemd/system/xsshunterapi.service
sudo wget https://gist.githubusercontent.com/jonasonline/23e899827e62b847106bb6fceee71e64/raw/38940ae7498eefe8b50ac76018aeeb31e25ade31/xsshuntergui.service -O /etc/systemd/system/xsshuntergui.service
sudo systemctl daemon-reload
sudo systemctl enable xsshunterapi
sudo systemctl start xsshunterapi
sudo systemctl status xsshunterapi
sudo systemctl enable xsshuntergui
sudo systemctl start xsshuntergui
sudo systemctl status xsshuntergui