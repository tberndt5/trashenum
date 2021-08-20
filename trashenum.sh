#!/bin/bash
# Run nmap to get open ports and store in namp.txt
echo "$(tput setaf 10)Running nmap scan...$(tput sgr 0)"
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
                curl ftp://$1 --user anonymous:anonymous
	elif [[ $port -eq 22 ]]
	then
		echo "$(tput setaf 3)SSHPort open...$(tput sgr 0)"
		echo "$(tput setaf 8)Attempting to grab banner.$(tput sgr 0)"
		#nc -v $1 22
        elif [[ $port -eq 80 ]]
        then
                echo "$(tput setaf 1)HTML Port open...$(tput sgr 0)"
                echo "$(tput setaf 2)Running go buster...$(tput sgr 0)"
                gobuster dir -u $1 -w /usr/share/wordlists/dirbuster/directory-list-1.0.txt > gobuster.txt
                echo "$(tput setaf 6)Gobuster scan complete!$(tput sgr 0)"
		echo "$(tput setaf 9)Directories found$(tput sgr 0)"
		echo "------------------------------"
		while IFS= read -r line; do
        		echo $line | grep "(Status:"
		done < "gobuster.txt"
		echo "-----------------------------"
                echo "$(tput setaf 7)Running nikto against $1...$(tput sgr 0)"
                nikto -h http://$1 > nikto.txt
                echo "$(tput setaf 8)Nikto scan complete!$(tput sgr 0)"
        else
                echo "$(tput setaf 5)Other interesing port found: $port$(tput sgr 0)"
                #send interesting port to file
        fi
done < "open_ports.txt"
