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
mkdir /root/rutorrent-stage-2
mkdir /roo/rutorrent-stage-3

git clone https://github.com/Novik/ruTorrent.git rutorrent-stage
rm -r rutorrent-stage/plugins/
cp -rf rutorrent-stage/. /usr/local/www/rutorrent/

svn checkout https://github.com/Novik/ruTorrent/trunk/plugins rutorrent-stage-3/plugins
cp -rf rutorrent-stage-3/plugins /usr/local/www/rutorrent/

rm -r /usr/local/www/rutorrent/autodl-irssi



git clone https://github.com/autodl-community/autodl-rutorrent.git rutorrent-stage-2
cp -rf rutorrent-stage-2/autodl-irssi /usr/local/www/rutorrent/plugins/


mkdir config-stage
git clone https://github.com/RogerAirgood/iocage-plugin-rutorrent.git config-stage
cp -f config-stage/overlay/usr/local/www/rutorrent/plugins/autodl-irssi/conf.php /usr/local/www/rutorrent/plugins/autodl-irssi/conf.php
cp -f config-stage/overlay/usr/local/www/rutorrent/conf/config.php /usr/local/www/rutorrent/conf/config.php

(crontab -l 2>/dev/null; echo "@reboot sh /root/torrenting.sh") | crontab -

screen -dmS screen_rtorrent rtorrent
screen -S autodl -fa -d -m irssi

