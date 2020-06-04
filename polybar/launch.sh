#!/bin/bash

# kill previous instances
killall -q polybar

# wait for them to shut down completely
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar example &

echo "Polybar launched..."
# followed tutorial here: https://github.com/regolith-linux/regolith-desktop/wiki/HowTo:-Swap-out-i3bar-for-Polybar
