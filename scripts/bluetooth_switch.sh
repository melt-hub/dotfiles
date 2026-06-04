#!/bin/bash

ERROR_LOG=$(mktemp)
POUT=$(bluetoothctl show 2>$ERROR_LOG | grep -c 'PowerState: off' 2>$ERROR_LOG)

echo $POUT

if [ $POUT -eq 1 ]; then
    bluetoothctl power on
else
    bluetoothctl power off
fi

# cleanup: delete the temporary log file
rm -f "$ERROR_LOG"