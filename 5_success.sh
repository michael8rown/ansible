#!/bin/bash

echo "Success!!
If you see this message, it means installation was successful.
Now you must run
    unmount -a && reboot
and enjoy your new setup!"

secs=$((10))
while [ $secs -gt 0 ]; do
   echo -ne "  Message ends in > $secs\033[0K\r"
   sleep 1
   : $((secs--))
done
echo

