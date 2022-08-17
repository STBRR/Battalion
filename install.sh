#!/bin/bash

function banner {
    echo ""
    echo "⠀⠀⠙⢦⡀⠀"
    echo "⠀⠀⠀⠈⢿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀"
    echo "⠀⠀⠀⠀⠀⠻⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⢸⣆⠀⠀⠀⠀⠀⠀⠀⢰"
    echo "⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⣸⣿⣦⡀⠀⠀⠀⠀⠀⢸⡇"
    echo "⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⢀⣾⣿ "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣾⣿⣿⡆"
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠉⠙⠻⢿⣿⣿⡇"
    echo "⠀⠀⠀⠐⠲⢶⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿"
    echo "⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣶⣶⣶⣦⠀⠀⠀⠀⢹⣿"
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⡇⠙⢿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⢸⡿"
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡀⠀⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⣼⠇"
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠏"
    echo "⠀⠀⠀⠀⠀⠀⠚⠛⠻⠿⢿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣀⣀⣠⣤⡶⠟⠁"
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠙⠛⠛⠉⠉⠉"
    echo ""
    echo " Battalion: Legacy Server Installer "
    echo "        Made with <3 by STBRR       "
    echo "             [LIAM#9934]            "
    echo ""

}

function install {
    # create a new user for steamcmd
    adduser steam
    usermod -aG sudo steam
    su - steam

    # 'steamcmd' is within the non-free repo for debian and multiverse on ubuntu.
    if grep 'Debian' -q /etc/issue 2>/dev/null; then
        echo "You're running on Debian."
        sudo echo "deb http://deb.debian.org/debian stretch main contrib non-free" >> /etc/aptsources.list
        sudo echo "deb-src http://deb.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list

        sudo echo "deb http://deb.debian.org/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list
        sudo echo "deb-src http://deb.debian.org/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list

        sudo echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
        sudo echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
        
    elif grep 'Ubuntu' -q /etc/issue 2>/dev/null; then 
        echo "You're running on Ubuntu"
        sudo add-apt-repository multiverse
    else
        echo "You're probably running another distro that this script hasn't had in mind.."
        exit
    fi

    sudo apt install software-properties-common
    sudo dpkg --add-architecture i386
    sudo apt update -y && sudo apt install -y steamcmd

    clear
    banner
    echo "[!] SteamCMD is now installed."

    # now steamcmd is installed, lets install battalion server from it.
    cd ~ && mkdir BattalionServerData && cd BattalionServerData

    clear
    banner
    steamcmd +login anonymous +force_install_dir $(pwd) +app_update 805140 +quit

    if [ -f "steamclient.so"]; then
        clear
        banner
        echo "[*] Battalion Dedicated Server is installed!"
        echo "[*] You can launch the server with the 'launch-server.sh' script."
        echo "[!] Thank you for using. Reach out on Discord if you need anything."
    else
        echo "[!] Something went wrong. Please re-run the script and try again."
    fi

}

if [ `whoami` != root ]; then
    banner
    echo "Error: Please run this script as root or using sudo"
    exit
else
    clear
    banner
    sleep 1
    install
fi
