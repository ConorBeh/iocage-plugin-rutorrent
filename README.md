# iocage-plugin-rutorrent

This is an iocage plugin to install an iocage jail on FreeBSD 11.3 with lighttpd, php73, rtorrent, ruTorrent, irssi, autodl-irssi, and the autodl-irssi plugin for ruTorrent. 

Here are a few things you need to know:

1. This has no authentication, this can be set up by the user later if he/she wishes but is not out of the box. Any old guide for basic HTTP authentication in lighttpd will work. 

2. There is a default password for autodl-irssi communcation, feel free to change this. 

3. You will need to hardcode your IRC username in .irssi/config as the default is "root" and will get you insta banned on most IRC servers. You can do this with a text editor of your chosing. 

4. rtorrent and autodl are started via screen, a simple crontab @reboot entry does this. 

5. Permissions and general security could be better but I'm assuming this wont be sitting on the internet.

6. You need to use the command line in FreeNAS to install this as there is no custom-plugin section in the GUI.

# To install run this in the FreeNAS shell run the following:

iocage fetch -P path-to-json-file.json ip4_addr="vnet0|ip_address/24" defaultrouter="ip_address" allow_raw_sockets=1 vnet=on

