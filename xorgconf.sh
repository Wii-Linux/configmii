#!/bin/bash

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
	menu "Xorg Driver Selection" \
		"OK" "Cancel" \
		"Please select your prefferred driver for X11" \
		"1" "fbdev (More compatible, no hardware acceleration)" \
		"2" "Flipper/Hollywood Driver (Less compatible, w/ hardware accel)"
	ret=$?
	case $ret in
		1)
			exec ./placeholder.sh ;;
		2)
			exec ./placeholder.sh ;;
		255)
			exit 0 ;;
	esac
done
