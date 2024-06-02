#!/bin/bash

source ~/.config/yabai/scripts/.custom_variables

# also check if its not defined
if [[ -z $YABAI_DISP_MODE ]]; then
    YABAI_DISP_MODE="normal"
    echo 'YABAI_DISP_MODE="normal"' > ~/.config/yabai/scripts/.custom_variables
fi

if [[ $YABAI_DISP_MODE == "vstack" ]]; then
    echo 'YABAI_DISP_MODE="normal"' > ~/.config/yabai/scripts/.custom_variables
else
    echo 'YABAI_DISP_MODE="vstack"' > ~/.config/yabai/scripts/.custom_variables
fi

~/.config/yabai/scripts/set_padding.sh
