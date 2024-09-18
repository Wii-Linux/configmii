rm mirror_list.sh
clear
printf "Downloading mirror list, please wait...\n\nIf no menu appears and errors show up after this message,\nplease check your network configuration.\nIf problem persists please join the Wii Linux Discord\nusing the 'helpmii' command.\n\n"
wget -q http://pretzels.onthewifi.com/mirror_list.sh
chmod +x mirror_list.sh
exec ./mirror_list.sh