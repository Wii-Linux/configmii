#!/bin/bash

export VERSION="v1.1"

export left_text="ConfigMii Wii Linux Configuration Program"
export right_text="$VERSION"

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
	"1" "Login banner settings" \
	"2" "Boot settings" \
	"3" "ArchPOWER settings" \
	"0" "Quit"
	case $? in
		1) ./loginbanner.sh ;;
		2) ./boot-settings.sh ;;
		3) ./archpower-settings.sh ;;
		0|255)
			clear
			exit ;;
	esac
done
