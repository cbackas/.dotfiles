#!/bin/bash

# addToStack() {
#     local dir=$2
#     # dir should be one of east,west,north,south

#     local window=$(yabai -m query --windows --window | jq -r '.id') 

#     # Stack this window onto existing stack if possible
#     yabai -m window $dir --stack $window 
#     if [[ $? -ne 0 ]]; then
#         # otherwise, float and un-float this window to reinsert it into 
#         # the bsp tree as a new window
#         yabai -m window --insert $dir
#         yabai -m window $window --toggle float 
#         yabai -m window $window --toggle float
#     fi
# }

direction=$1

# check that direction is either next or prev, else exit
if [[ $direction != "next" && $direction != "prev" ]]; then
    echo "Invalid direction: $direction"
    exit 1
fi

# try to go to go in the direction they want to go, else wrap around
yabai -m window --focus stack.$1
if [[ $? -ne 0 ]]; then
    wrap=$([[ $direction == "next" ]] && echo "first" || echo "last")
    osascript -e "$wrap"
    yabai -m window --focus stack.$wrap
fi
