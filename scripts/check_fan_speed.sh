#!/bin/bash

# extract only the numeric value of the fan speed
# we use grep -oP to grab the first digits group found after 'fan'
RPM=$(sensors 2>/dev/null | grep -i 'fan' | grep -oP '\d+' | head -n 1)

# handle passive cooling or missing sensors
if [[ -z "$RPM" || "$RPM" -eq 0 ]]; then
    echo "OFF"
else
    echo "${RPM}RPM"
fi