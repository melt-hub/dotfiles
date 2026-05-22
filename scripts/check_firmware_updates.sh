#!/bin/bash

# Esegue un refresh silenzioso dei metadati (senza scaricare il firmware)
# Solo se non è stato fatto recentemente
fwupdmgr get-updates -q > /dev/null 2>&1

# Conta quante linee di aggiornamenti ci sono (escludendo l'intestazione)
updates=$(fwupdmgr get-updates -q | grep -c "·")

if [ "$updates" -gt 0 ]; then
    echo "󰚰 $updates"
else
    echo ""
fi