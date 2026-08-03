#!/bin/sh

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi

# FIXME: should go in CDU
info_autoclose() {
	dialog $DIALOG_COMMON \
		--backtitle "$BACKTITLE" \
		--title "$1" \
		--infobox "$2" \
		"$3" "$4" # height, width -- 0, 0 is ugly.
}

while true; do
	bcm_fw_installed="No"
	openfwwf_installed="No"
	if [ -f /lib/firmware/b43/ucode5.fw ]; then
		bcm_fw_installed="Yes"
	elif [ -f /lib/firmware/b43.bak/ucode5.fw ]; then
		bcm_fw_installed="Yes (inactive)"
	fi
	if [ -f /lib/firmware/b43-open/ucode5.fw ]; then
		if [ "$bcm_fw_installed" = "Yes" ]; then
			openfwwf_installed="Yes (inactive)"
		else
			openfwwf_installed="Yes"
		fi
	elif [ -f /lib/firmware/b43-open.bak/ucode5.fw ]; then
		openfwwf_installed="Yes (inactive)"
	fi

	menu "WiFi Firmware Settings" \
	"OK" "Cancel" \
	"Current firmware installation status:\nOpenFWWF: $openfwwf_installed\nProprietary Broadcom FW: $bcm_fw_installed\n\nSelect an option:" \
	"1" "Enable proprietary Broadcom firmware" \
	"2" "Enable OpenFWWF firmware" \
	"3" "Install proprietary Broadcom firmware" \
	"4" "Help"

	case $? in
		1)
			if [ "$bcm_fw_installed" = "Yes" ]; then
				info "Warning" "Proprietary Broadcom firmware already enabled, nothing to do!" 15 40
			elif [ "$bcm_fw_installed" = "No" ]; then
				info "Warning" "Proprietary Broadcom firmware not yet installed; install it first!" 15 40
			elif [ "$bcm_fw_installed" = "Yes (inactive)" ]; then
				if [ "$openfwwf_installed" = "Yes" ]; then
					if ! yesno "Question" "The OpenFWWF firmware is currently enabled.  Disable it to enable the proprietary Broadcom firmware?" 15 40; then
						continue
					fi

					mv /lib/firmware/b43-open /lib/firmware/b43-open.bak
				fi

				mv /lib/firmware/b43.bak /lib/firmware/b43
				if [ -f /lib/firmware/b43-open/ucode5.fw ]; then
					mv /lib/firmware/b43-open /lib/firmware/b43-open.bak
				fi

				# disable QoS or else it's not at all stable
				echo "options b43 qos=0" > /etc/modprobe.d/b43.conf

				info_autoclose "Please wait" "Done!  Reloading Wi-Fi config, please wait..." 15 40
				rmmod b43
				modprobe b43
			fi
			;;
		2)
			if [ "$openfwwf_installed" = "Yes" ]; then
				info "Warning" "OpenFWWF already enabled, nothing to do!" 15 40
			elif [ "$openfwwf_installed" = "No" ]; then
				info "Warning" "OpenFWWF not installed??" 15 40
			elif [ "$openfwwf_installed" = "Yes (inactive)" ]; then
				if [ "$bcm_fw_installed" = "Yes" ]; then
					if ! yesno "Question" "The proprietary Broadcom firmware is currently enabled.  Disable it to enable OpenFWWF?" 15 40; then
						continue
					fi
					mv /lib/firmware/b43 /lib/firmware/b43.bak
				fi

				if [ -f /lib/firmware/b43-open.bak/ucode5.fw ]; then
					mv /lib/firmware/b43-open.bak /lib/firmware/b43-open
				fi

				if [ -f /etc/modprobe.d/b43.conf ]; then
					rm /etc/modprobe.d/b43.conf
				fi

				info_autoclose "Please wait" "Done!  Reloading Wi-Fi config, please wait..." 15 40
				rmmod b43
				modprobe b43
			fi
			;;
		4)
			info "Help" "The Wii uses a Broadcom 4318 Wi-Fi Card.  This card requires firmware to operate.  Wii-Linux ships with the \"OpenFWWF\" open-source implementation of the firmware for this card.  For legal reasons, it cannot ship with the proprietary Broadcom firmware.  The proprietary Broadcom firmware requires extraction from a proprietary driver blob.  The proprietary Broadcom firmware offers about double the Wi-Fi performance (9mbps download/2mbps upload) compared to OpenFWWF.  ConfigMii can download and install the proprietary Broadcom firmware for you (existing internet connection via OpenFWWF or USB Ethernet is required) if you are OK with using proprietary firmware and would like the improved performance." 20 70 ;;
		0|255)
			clear
			exit 0;;
	esac

done
