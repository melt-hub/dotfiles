#!/bin/bash

# Trova automaticamente la batteria (che sia BAT0 o BAT1)
BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" | head -n 1)

# Se non trova nessuna batteria, esce silenziosamente
if [ -z "$BAT_PATH" ]; then
    exit 0
fi

THRESHOLD=15
BATTERY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

# Se la batteria è sotto la soglia e si sta scaricando
if [ "$BATTERY" -le "$THRESHOLD" ] && [ "$STATUS" = "Discharging" ]; then
    # -u critical: colore rosso/urgenza alta
    # -t 10000: sparisce dopo 10 secondi (10000ms)
    # -r 9991: sostituisce la notifica precedente invece di crearne di nuove (evita lo spam)
    notify-send -u critical -t 10000 -r 9991 "Low Battery" "Level: ${BATTERY}%"
fi