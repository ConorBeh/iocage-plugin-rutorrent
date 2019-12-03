#!/bin/sh

sysrc -f /etc/rc.conf lighttpd_enable="YES"
sysrc -f /etc/rc.conf php_fpm_enable="YES"
service php-fpm start 2>/dev/null
service lighttpd start 2>/dev/null

mkdir /root/.autodl
echo "[options]" >> /root/.autodl/autodl.cfg
echo "rt-address = 127.0.0.1:6000" >> /root/.autodl/autodl.cfg
echo "gui-server-port = 6002" >> /root/.autodl/autodl.cfg
echo "gui-server-password = 3PicP4ssw0rd" >> /root/.autodl/autodl.cfg

mkdir /root/rutorrent-stage
git clone https://github.com/Novik/ruTorrent.git rutorrent-stage
rm -r rutorrent-stage/plugins
svn checkout https://github.com/Novik/ruTorrent/trunk/plugins rutorrent-stage-3/plugins
cp -rf rutorrent-stage-3/plugins. /usr/local/www/rutorrent/plugins/


rm -r rutorrent-stage/plugins/autodl-irssi

git clone https://github.com/autodl-community/autodl-rutorrent.git rutorrent-stage-2/plugins/autodl-irssi 

cp -rf rutorrent-stage/. /usr/local/www/rutorrent/
cp -rf rutorrent-stage-2/. /usr/local/www/rutorrent/

mkdir config-stage
git clone https://github.com/RogerAirgood/iocage-plugin-rutorrent.git config-stage
cp -f config-stage/overlay/usr/local/www/rutorrent/plugins/autodl-irssi/conf.php /usr/local/www/rutorrent/plugins/autodl-irssi/conf.php
cp -f config-stage/overlay/usr/local/www/rutorrent/conf/config.php /usr/local/www/rutorrent/conf/config.php

(crontab -l 2>/dev/null; echo "@reboot sh /root/torrenting.sh") | crontab -

screen -dmS screen_rtorrent rtorrent
screen -S autodl -fa -d -m irssi

