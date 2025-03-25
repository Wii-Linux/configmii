#!/bin/sh

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi


while true; do
	menu "Boot settings" \
		"OK" "Cancel" \
		"Select an option:" \
		"1" "Edit Kernel command line" \
		"2" "Edit Initrd loader settings" \
		"3" "Edit loader.img settings"
	case $? in
		1)
			info "TODO" "TODO - fancy crap with baedit" 6 60 ;;
		2)
			info "TODO" "TODO - even more fancy crap with baedit" 6 60 ;;
		3)
			info "TODO" "TODO - even more fancy crap with baedit" 6 60 ;;
		255)
			exit 0 ;;
	esac
done
