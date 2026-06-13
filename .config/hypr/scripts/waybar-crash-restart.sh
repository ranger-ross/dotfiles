#!/usr/bin/env bash
# Does not launch waybar itself; let hyprland.conf handle the initial exec-once.
#
# This is work around due to unplugging my dock crashing waybar.
# A patch upstream has been merged but is not released and I don't want to build from source.

echo "[waybar-watchdog] started, waiting for waybar to appear..."

until pgrep -x waybar > /dev/null; do
    sleep 1
done

echo "[waybar-watchdog] waybar detected (pid $(pgrep -x waybar)), watching..."

while true; do
    while pgrep -x waybar > /dev/null; do
        sleep 2
    done

    echo "[waybar-watchdog] waybar is gone — restarting in 2s..."
    sleep 2
    waybar &
    echo "[waybar-watchdog] waybar launched (pid $!), waiting for it to appear..."

    until pgrep -x waybar > /dev/null; do
        sleep 1
    done

    echo "[waybar-watchdog] waybar detected (pid $(pgrep -x waybar)), watching..."
done
