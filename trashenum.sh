#!/bin/bash
# Run nmap to get open ports and store in namp.txt
nmap -p- -T4 $1 > nmap.txt
# Run through nmap.txt for open ports and store the ports in open_ports.txt
while IFS= read -r line; do
        echo $line | grep "/tcp" | cut -d / -f 1 >> "open_ports.txt"
done < "nmap.txt"

# Run through open_ports.txt to enumerate the ports
while IFS= read -r port; do
        if [[ $port -eq 21 ]]
        then
                echo "$(tput setaf 3)FTP Port open..$(tput sgr 0)"
                echo "$(tput setaf 4)Connecting to ftp with anonymous$(tput sgr 0)"
                # ftp command
        elif [[ $port -eq 80 ]]
        then
                echo "$(tput setaf 1)HTML Port open...$(tput sgr 0)"
                echo "$(tput setaf 2)Running go buster...$(tput sgr 0)"
                #gobuster command
        else
                echo "$(tput setaf 5)Other interesing port found: $port$(tput sgr 0)"
                #send interesting port to file
        fi
done < "open_ports.txt"
