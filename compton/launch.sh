#!/bin/bash

# kill previous instances
killall -q compton

# wait for them to shut down completely
while pgrep -u $UID -x compton >/dev/null; do sleep 1; done

compton --config $HOME/.config/desktop-environment/compton/config &

#echo "Compton launched..." >> $HOME/test.txt
