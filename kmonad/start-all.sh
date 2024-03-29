#!/usr/bin/env bash

base=/home/umut/dotfiles/kmonad/kbd.kbd

kbds=(
    "/dev/input/by-id/usb-OBINLB_USB-HID_Keyboard_SN0000000001-event-kbd"                                     # AnnePro2 usb
    "/dev/input/$(grep -B 8 -A 4 12001 /proc/bus/input/devices | grep AnnePro -A 4 | grep -oE 'event[0-9]+')" # Bluetooth
    "/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd"                                               # Logitech
)


if ! [ -f "/tmp/disable-kb" ]; then
   kbds+=("/dev/input/by-path/platform-i8042-serio-0-event-kbd") # Builtin
fi

for i in "${kbds[@]}"; do
    fname="/tmp/kmonad-$(basename $i).kbd"
    sed "s%KBD_FILE%\"${i}\"%" $base >$fname
    if [ -e "$i" ]; then
        echo "Started kmonad for $i"
        /usr/bin/kmonad $fname &
    else
        echo "Not connected: $i"
    fi

done

for job in $(jobs -p); do
    wait $job
done
