#!/bin/bash

export VERSION="v1.3"

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
	"2" "ArchPOWER settings" \
	"3" "Install a DE/WM" \
	"9" "About ConfigMii" \
	"0" "Quit"
	case $? in
		1) ./loginbanner.sh ;;
		2) ./archpower-settings.sh ;;
		3) yesno "WARNING!" "Xorg performance is VERY slow due to a lack of a proper GPU driver and there's nothing that can be done about that for the time being.\n\nAre you sure you want to continue?" 12 60
			case $? in
				0) ./de-installer.sh ;;
				1) clear ;;
			esac ;;
		9) info "About" "ConfigMii - The Wii Linux Configuration Program.\n\nConfigMii Version $VERSION\nUsing $UTIL_VER_STR\n\nConfigMii was made by Techflash, Tech64, and other contributors.\nThis program is licensed under the terms of the GNU General Public License, version 2.\nYou may find these terms under the ConfigMii install directory, under the LICENSE file." 15 70 ;;
		0|255)
			clear
			exit 0;;
	esac
done
