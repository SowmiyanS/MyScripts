#!/usr/bin/env bash

# Thanks to ysap for his based script!

while IFS=: read -r ssid passwd; do
    # if we just do passwd it will contains a _ space character because I put a space in the file.
    echo  "$ssid:$passwd"
    # so we use simple find and replace using parameter expansion
    pass=${passwd/ /}
    # store that value to a new variable
    sudo su -l -c "wpa_passphrase $ssid $pass >> wpa_supplicant.conf"
    # it successfully generated the wpa_supplicant.conf file in root's home director
    # which I copied and pasted to /etc/wpa_supplicant/wpa_supplicant-wlx000911020cd.conf
done < wifi.txt
