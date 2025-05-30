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
	menu "ArchPOWER settings" \
		"OK" "Cancel" \
		"Select an option:" \
		"1" "Perform a system update" \
		"2" "Remove depenencies from uninstalled packages (\"orphaned packages\")" \
		"3" "Clean downloaded package cache" \
		"4" "Enable the \"testing\" repositories" \
		"5" "Disable the \"testing\" repositories"
	case "$?" in
		1)
			script -c 'pacman -Syu; echo $? > /tmp/pacman-ret' /tmp/pacman-log.txt
			ret="$(cat /tmp/pacman-ret)"
			if [ "$ret" != "0" ]; then
				head -n -1 /tmp/pacman-log.txt | tail -n +2 > ~/pacman-log.txt
				info "Error" "pacman exited with a non-zero status code ($ret)!\nAn error report has been saved to ~/pacman-log.txt.\nIf you need help, please contact support!" 9 60
			else
				info "Success" "System upgrade success!" 6 30
			fi
			rm -f /tmp/pacman-log.txt /tmp/pacman-ret ;;
							
		2)
			if [ "$(pacman -Qdtq)" = "" ]; then
				info "Info" "Nothing to remove!" 6 30
				continue
			fi

			script -c 'pacman -Rnsc $(pacman -Qdtq); echo $? > /tmp/pacman-ret' /tmp/pacman-log.txt
			ret="$(cat /tmp/pacman-ret)"
			if [ "$ret" != "0" ]; then
				head -n -1 /tmp/pacman-log.txt | tail -n +2 > ~/pacman-log.txt
				info "Error" "Pacman failed to remove packages with error ($ret)!\nAn error report has been saved to ~/pacman-log.txt.\nIf you need help, please contact support!" 9 60
			else
				info "Done" "Obsolete packages removed!" 6 30
			fi
			rm -f /tmp/pacman-log.txt /tmp/pacman-ret ;;
		3)
			script -c 'yes | pacman -Scc; echo $? > /tmp/pacman-ret' /tmp/pacman-log.txt
			ret="$(cat /tmp/pacman-ret)"
			if [ "$ret" != "0" ]; then
				head -n -1 /tmp/pacman-log.txt | tail -n +2 > ~/pacman-log.txt
				info "Error" "Pacman failed to clean cache with error ($ret)!\nAn error report has been saved to ~/pacman-log.txt.\nIf you need help, please contact support!" 9 60
			else
				info "Done" "Package cache cleaned!" 6 30
			fi
			rm -f /tmp/pacman-log.txt /tmp/pacman-ret ;;
		4)
			info "TODO" "TODO - write this" 6 30 ;;
		5)
			info "TODO" "TODO - write this" 6 30 ;;
		255)
			exit 0 ;;
	esac
done
