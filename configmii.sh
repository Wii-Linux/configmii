#!/bin/bash

VERSION="v1.1"

left_text="ConfigMii Wii Linux Configuration Program"
right_text="$VERSION"

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi

while true; do
	menu "Main Menu" \
	"OK" "Cancel" \
	"Select an option:" \
	"1" "Set the Wii Linux login banner"\
	"2" "Set the ArchPOWER login banner" \
	"3" "Edit Kernel command line" \
	"4" "Edit Initrd loader settings" \
	"5" "Edit loader.img settings" \
	"6" "Switch Xorg driver" \
	"0" "Quit"
	case $? in
		1)
			yesno "Confirmation" "Are you sure you want to set the login banner to the Wii Linux default? This action cannot be undone." 6 60
			case $? in
				0)
					err=$(cp ./etc-issue/banner_wii-linux.txt /etc/issue 2>&1)
					ret=$?
					if [ $ret != 0 ]; then
						info "Error" "There was a problem setting the banner: $err ($ret)" 6 60
					fi ;;
				1) clear ;;
			esac ;;
		2)
			yesno "Confirmation" "Are you sure you want to set the login banner to the ArchPOWER default? This action cannot be undone." 6 60
			case $? in
				0)
					err=$(cp ./etc-issue/banner_stock.txt /etc/issue 2>&1)
					ret=$?
					if [ $ret != 0 ]; then
						info "Error" "There was a problem setting the banner: $err ($ret)" 6 60
					fi ;;
				1) clear ;;
			esac ;;
		3)
			yesno "WARNING!" "Editing these settings could potentially break your\nWii Linux install!\nOnly proceed if you know what you're doing." 7 60
			case $? in
				0) exec ./placeholder.sh;;
				1) clear ;;
			esac ;;
		4)
			yesno "WARNING!" "Editing these settings could potentially break your\nWii Linux install!\nOnly proceed if you know what you're doing." 7 60
			case $? in
				0) exec ./placeholder.sh;;
				1) clear ;;
			esac ;;
		5)
			yesno "WARNING!" "Editing these settings could potentially break your\nWii Linux install!\nOnly proceed if you know what you're doing." 7 60
			case $? in
				0) exec ./placeholder.sh;;
				1) clear ;;
			esac ;;
		6)
			exec ./xorgconf.sh ;;
		0|255)
			clear
			exit ;;
	esac
done
