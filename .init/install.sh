#!/bin/bash

echo "Welcome to the MarkWare VCMake Linux Installers!"
echo "Please select your Linux distribution:"
echo "1) Debian-based"
echo "2) Fedora"
echo "3) Arch"
echo "4) OpenSUSE"
echo "5) Exit"

read -p "Enter your choice [1-5]: " choice

case $choice in
    1)
        echo "Running Debian-based installer..."
        bash DebianBasedInstaller.sh
        ;;
    2)
        echo "Running Fedora installer..."
        bash FedoraInstaller.sh
        ;;
    3)
        echo "Running Arch installer..."
        bash ArchInstaller.sh
        ;;
    4)
        echo "Running OpenSUSE installer..."
        bash OpenSUSEInstaller.sh
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac