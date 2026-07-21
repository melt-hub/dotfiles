#!/bin/bash

# Identifica il dispositivo disco principale
DISK=$(lsblk -no NAME,TYPE | grep 'disk' | head -n 1 | awk '{print $1}')

# Controlla se iostat è installato
if ! command -v iostat &> /dev/null; then
    exit 1
fi

# Ottiene le statistiche del disco (media su 1 secondo)
# $3 = kB_read/s, $4 = kB_wrtn/s
STATS=$(iostat -dk 1 2 2>/dev/null | grep "$DISK" | tail -n 1)

# Se il disco non restituisce statistiche, esce silenziosamente
if [ -z "$STATS" ]; then
    exit 0
fi

# Estrazione, conversione (kB -> MB) e stampa condizionale.
# Stampa il risultato tra parentesi solo se lettura o scrittura >= 0.05 MB/s.
# Altrimenti non restituisce nulla, permettendo a Waybar di nascondersi.
echo "$STATS" | awk '{
    r = $3 / 1024;
    w = $4 / 1024;
    if (r >= 0.05 || w >= 0.05) {
        printf "R:%.1fMB W:%.1fMB\n", r, w;
    }
}'