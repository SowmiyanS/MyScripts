#!/bin/bash

# Function in bash
UpdateInterfaces() {
    echo "Editing the /etc/network/interfaces file"
    sed -i '14 s/.*/auto '"${interface}"'/' /etc/network/interfaces
    sed -i '15 s/.*/iface '"${interface}"' inet dhcp/' /etc/network/interfaces
}

# 'Declaring' the variable called interface and 'intializing' it with the usb "/enx/(regular expression)" interface
interface=$(ip add | awk -F ":" '/enx/ {print $2}')

# If condition to check if the interface variable contains the regular expression starting with 'enx' since the usb interface is renamed from usb0 to an enx{mac address} format in debian 12 bookworm
if [[ $interface =~ "enx" ]]
then
    echo $interface
    # Calling the function to make changes to the /etc/network/interfaces file (requires sudo previlages)
    UpdateInterfaces
    # Using DHCP client to get the ip address from the usb interface (requires sudo previlages)
    ifup $interface
else
    echo $interface
    # Else there is no valid usb interface found so should not touch the /etc/network/interfaces file and exit the program with message
    echo "USB Interface Not Found!"
fi

