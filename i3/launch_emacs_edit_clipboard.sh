#!/bin/bash

# arg 1 - clipboard contents
# arg 2 - file to save to

TEMPFILE=/tmp/emacsclipboardedit

# hacky, read focused window, wait until it changes and set that new focused to floating
focus=$(xdotool getwindowfocus)

xsel -bo > $TEMPFILE
emacsclient --quiet --create-frame --alternate-editor "" $TEMPFILE &

newfocus=$focus

# wait until new focus is different
while [[ "$newfocus" == "$focus" ]]; do
    newfocus=$(xdotool getwindowfocus)
    sleep 0.2;
done;

i3-msg floating enable

wait

cat $TEMPFILE | xsel -bi
