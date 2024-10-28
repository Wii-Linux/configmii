#!/bin/bash

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi


while true; do
	menu "Login banner settings" \
		"OK" "Cancel" \
		"Select an option:" \
		"1" "Set the Wii Linux login banner"\
		"2" "Set the ArchPOWER login banner"
	case "$?" in
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
		255)
			exit 0 ;;
	esac
done
