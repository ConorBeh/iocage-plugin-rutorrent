#!/bin/sh

sysrc -f /etc/rc.conf lighttpd_enable="YES"
sysrc -f /etc/rc.conf php_fpm_enable="YES"
service php-fpm start 2>/dev/null
service lighttpd start 2>/dev/null

mkdir /root/.autodl
touch /root/.autodl/autodl.cfg
echo "[options]" >> /root/.autodl/autodl.cfg
echo "rt-address = 127.0.0.1:6000" >> /root/.autodl/autodl.cfg
echo "gui-server-port = 6002" >> /root/.autodl/autodl.cfg
echo "gui-server-password = 3PicP4ssw0rd" >> /root/.autodl/autodl.cfg

cd /usr/local/www/rutorrent
git clone https://github.com/Novik/ruTorrent.git rutorrent
rm -r rutorrent/plugins
svn checkout https://github.com/Novik/ruTorrent/trunk/plugins rutorrent/plugins


rm -rf plugins/autodl-irssi

git clone https://github.com/autodl-community/autodl-rutorrent.git autodl-irssi 



# (crontab -l 2>/dev/null; echo "@reboot sh /root/torrenting.sh") | crontab -

screen -dmS screen_rtorrent rtorrent
screen -S autodl -fa -d -m irssi
