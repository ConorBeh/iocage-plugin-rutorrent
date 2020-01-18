#!/bin/sh

# Enable and start the web server and php
sysrc -f /etc/rc.conf lighttpd_enable="YES"
sysrc -f /etc/rc.conf php_fpm_enable="YES"
service php-fpm start 2>/dev/null
service lighttpd start 2>/dev/null

# Create the autodl config directory and populate it
mkdir /root/.autodl
echo "[options]" >> /root/.autodl/autodl.cfg
echo "rt-address = 127.0.0.1:6000" >> /root/.autodl/autodl.cfg
echo "gui-server-port = 6002" >> /root/.autodl/autodl.cfg
echo "gui-server-password = 3PicP4ssw0rd" >> /root/.autodl/autodl.cfg

# Create staging directories 
mkdir /root/rutorrent-stage
mkdir /root/rutorrent-stage-2
mkdir /root/rutorrent-stage-3

# Grab ruTorrent and drop it into our web server directory and delete the stock plugins folder, we dont need it
git clone https://github.com/Novik/ruTorrent.git rutorrent-stage
rm -r rutorrent-stage/plugins/
cp -rf rutorrent-stage/. /usr/local/www/rutorrent/

# Grabs the newest plugins and puts them in the rutorrent plugins folder.
git clone https://github.com/Novik/ruTorrent/trunk/plugins rutorrent-stage-2/plugins
cp -rf rutorrent-stage-2/plugins /usr/local/www/rutorrent/

# Dump the stock autodl-irssi plugin as we are grabbing the newest version
rm -r /usr/local/www/rutorrent/plugins/autodl-irssi

# Grab the autodl rutorrent plugin and put it in the rutorrent plugin directory
git clone https://github.com/autodl-community/autodl-rutorrent.git rutorrent-stage-3
mkdir /usr/local/www/rutorrent/plugins/autodl-irssi 
cp -rf rutorrent-stage-3/. /usr/local/www/rutorrent/plugins/autodl-irssi

# Stage some configs and put them in their place from overlay. They are overwritten so copying them manually ensures they are there. 
mkdir config-stage
git clone https://github.com/RogerAirgood/iocage-plugin-rutorrent.git config-stage
cp -f config-stage/overlay/usr/local/www/rutorrent/plugins/autodl-irssi/conf.php /usr/local/www/rutorrent/plugins/autodl-irssi/conf.php
cp -f config-stage/overlay/usr/local/www/rutorrent/conf/config.php /usr/local/www/rutorrent/conf/config.php

# Put autodl scripts in irssi's directory
mkdir -p ~/.irssi/scripts/autorun
cd ~/.irssi/scripts
fetch https://github.com/autodl-community/autodl-irssi/releases/download/2.6.1/autodl-irssi-v2.6.1.zip
unzip -o autodl-irssi-v2.6.1.zip
cp autodl-irssi.pl autorun/

# Head back home
cd

# Add a crontab to restart rutorrent and autodl at jail boot, using screen. I'd prefer to use services too dont worry.
(crontab -l 2>/dev/null; echo "@reboot screen -dmS screen_rtorrent rtorrent") | crontab -
(crontab -l 2>/dev/null; echo "@reboot screen -S autodl -fa -d -m irssi") | crontab -

# Populate rtorrent's config directory, mostly just a non-standard port. 
touch .rtorrent.rc
echo "scgi_port = 127.0.0.1:6000" >> .rtorrent.rc
echo "session.path.set = /root/.session" >> .rtorrent.rc

# Permissions on the stock torrents directory and the settings directory. 
chmod -R 777 /usr/local/www/rutorrent/share/torrents
chmod -R 777 /usr/local/www/rutorrent/share/settings
mkdir .session
chmod -R 777 /root/.session

# Start rtorrent and autodl with screen
screen -dmS screen_rtorrent rtorrent
screen -S autodl -fa -d -m irssi

# Nuke staging directories 
rm -rf config-stage
rm -rf rutorrent-stage
rm -rf rutorrent-stage-2
rm -rf rutorrent-stage-3

exit
