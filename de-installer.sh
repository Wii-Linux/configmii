#!/bin/sh

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi

xorgPkgs="xorg-server xorg-xinit xf86-video-fbdev"

saveXinitrc() {
	if [ -f ~/.xinitrc ]; then
		mv ~/.xinitrc ~/.xinitrc.bak
	fi
}

updateXinitrc() {
	echo '#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi' > ~/.xinitrc
}

end() {
	info "Done" "The DE has been installed!\n\nYou can now run startx to start the Xorg server and your DE!" 9 60
}

end_node() {
	info "Done" "The DE has been installed!\n\nYou can now run startx to start the Xorg server!" 9 60
}

end_xfce() {
	info "Done" "The DE has been installed!\n\nYou can now run startxfce4 to start the Xorg server and your DE!" 9 60
}

pacmanWrapper() {
	script -c "pacman --needed -S $*; echo \$? > /tmp/pacman-ret" /tmp/pacman-log.txt
	ret="$(cat /tmp/pacman-ret)"
	if [ "$ret" != "0" ]; then
		head -n -1 /tmp/pacman-log.txt | tail -n +2 > ~/pacman-log.txt
		info "Error" "pacman exited with a non-zero status code ($ret)!\nAn error report has been saved to ~/pacman-log.txt.\nIf you need help, please contact support!" 9 60
		return 1
	fi
	sleep 1
	rm -f /tmp/pacman-log.txt /tmp/pacman-ret
	return 0
}

while true; do
	menu "DE Installer" \
		"OK" "Cancel" \
		"The DEs/WMs are rated (ABCDF) in tiers of performance.  Please select an option:" \
		"1" "[A] Install Xorg (no desktop)" \
		"2" "[B] Install Xorg with i3wm" \
		"3" "[C] Install Xorg with icewm (recommended for new users)" \
		"4" "[C] Install Xorg with fluxbox" \
		"5" "[C] Install Xorg with openbox" \
		"6" "[F] Install Xorg with xfce4"
	case "$?" in
		1)
			pacmanWrapper "$xorgPkgs" || {
				# failed...
				continue
			}

			end_node ;;
		2)
			pacmanWrapper "$xorgPkgs i3" || {
				# failed...
				continue
			}
			saveXinitrc
			updateXinitrc
			echo "exec i3" >> ~/.xinitrc
			end ;;
		3)
			pacmanWrapper "$xorgPkgs icewm ttf-dejavu xterm" || {
				# failed...
				continue
			}
			saveXinitrc
			echo "exec icewm-session" > ~/.xinitrc
			end ;;
		4)
			pacmanWrapper "$xorgPkgs fluxbox ttf-dejavu xterm" || {
				# failed...
				continue
			}
			saveXinitrc
			updateXinitrc
			echo "exec fluxbox" >> ~/.xinitrc
			end ;;
		5)
			pacmanWrapper "$xorgPkgs openbox ttf-dejavu xterm" || {
				# failed...
				continue
			}
			saveXinitrc
			echo "exec openbox-session" >> ~/.xinitrc
			end ;;
		6)
			pacmanWrapper "$xorgPkgs xfce4 xfce4-goodies ttf-dejavu xterm" || {
				# failed...
				continue
			}
			saveXinitrc
			echo "echo 'Use startxfce4 instead of startx for XFCE!' >&2" >> ~/.xinitrc
			end_xfce ;;
		255)
			exit 0 ;;
	esac
done
