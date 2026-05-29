#!/bin/bash

ERROR_LOG=$(mktemp)
POUT=$(bluetoothctl show | grep -c 'PowerState: off')

echo $POUT

if [ $POUT -eq 1 ]; then
    bluetoothctl power on
else
    bluetoothctl power off
fi