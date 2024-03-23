#!/bin/bash

# logs:
# tail -f /tmp/yabai_$USER.out.log

# Function to execute a command and return the output
executeCommand() {
    /opt/homebrew/bin/yabai -m $@
}

# Function to set padding
setSpacePadding() {
    local space=$1
    local x=$2
    local y=$3

    local currentXPadding=$(executeCommand "config --space $space right_padding")
    local currentYPadding=$(executeCommand "config --space $space bottom_padding")
    if [[ $currentXPadding -eq $x && $currentYPadding -eq $y ]]; then
        echo "[Padding] Space $space | x: $x, y: $y | No change"
        return
    fi

    executeCommand "space $space --padding abs:$y:$y:$x:$x"
    echo "[Padding] Space $space | x: $x, y: $y"
}

# Function to set Global padding
setGlobalPadding() {
    local x=$1
    local y=$2

    local currentXPadding=$(executeCommand "config right_padding")
    local currentYPadding=$(executeCommand "config bottom_padding")

    # if neither are equal, change them both
    if [[ $currentXPadding -ne $x && $currentYPadding -ne $y ]]; then
        executeCommand "config left_padding $x"
        executeCommand "config right_padding $x"
        executeCommand "config top_padding $y"
        executeCommand "config bottom_padding $y"
        echo "[Padding] Global | x: $x, y: $y | Changed x and y"
        return
        elif [[ $currentXPadding -eq $x && $currentYPadding -eq $y ]]; then
        echo "[Padding] Global | x: $x, y: $y | No change"
        return
        elif [[ $currentXPadding -eq $x ]]; then
        executeCommand "config top_padding $y"
        executeCommand "config bottom_padding $y"
        echo "[Padding] Global | x: $x, y: $y | Changed y"
        return
        elif [[ $currentYPadding -eq $y ]]; then
        executeCommand "config left_padding $x"
        executeCommand "config right_padding $x"
        echo "[Padding] Global | x: $x, y: $y | Changed x"
        return
    fi
}

# Function to set top padding
setTopPadding() {
    local padding=$1

    local currentTopPadding=$(executeCommand "config external_bar")
    if [[ $currentTopPadding == "main:$padding:0" ]]; then
        echo "[Padding] Top | $padding | No change"
        return
    fi

    executeCommand "config external_bar main:$padding:0"
    echo "[Padding] Top | $padding"
}

# Main script
DOCKED_DISPLAY_UUIDS=("8FF27EAB-3516-48F7-9A01-863B497FE55D" "75BAF4D4-694E-48EB-B60E-B9530B00A5EA")

# Get the UUID of the main display
mainDisplay=$(executeCommand "query --displays" | jq -r '.[0] | {uuid: .uuid, index: .index}')
mainDisplayUUID=$(echo "$mainDisplay" | jq -r '.uuid')
mainDisplayIndex=$(echo "$mainDisplay" | jq -r '.index')

# Check if the main display is docked
if [[ " ${DOCKED_DISPLAY_UUIDS[@]} " =~ " ${mainDisplayUUID} " ]]; then
    setTopPadding 550

    # Get the list of spaces
    spaces=$(executeCommand "query --spaces" | jq -c '.[] | {index: .index, display: .display, isVisible: .["is-visible"], isNativeFullscreen: .["is-native-fullscreen"]}')

    for spaceData in $spaces; do
        # Extract the attributes for the space
        space=$(echo "$spaceData" | jq -r '.index')
        display=$(echo "$spaceData" | jq -r '.display')
        isVisible=$(echo "$spaceData" | jq -r '.isVisible')
        isNativeFullscreen=$(echo "$spaceData" | jq -r '.isNativeFullscreen')

        # Skip the space if it's not visible or is in native fullscreen mode
        if [[ $isVisible == "false" || $isNativeFullscreen == "true" ]]; then
            continue
        fi

        if [[ $display -ne $mainDisplayIndex ]]; then
            setSpacePadding "$space" 5 5
            continue
        fi

        # Get the number of visible windows in the space
        numVisibleWindows=$(
        executeCommand "query --windows --space $space" | \
        jq -r '[.[] |
            select(."is-hidden" == false and
                ."is-minimized" == false and
                ."is-floating" == false and
                ."stack-index" <= 1) |
            select(."app" != "Arc" or
                ."title" != "" or
                ."subrole" != "AXSystemDialog")
        ] | length'
        )

        # Set the padding based on the number of visible windows
        if [[ $numVisibleWindows -eq 0 || $numVisibleWindows -eq 1 ]]; then
            setSpacePadding "$space" 500 40
        elif [[ $numVisibleWindows -eq 2 ]]; then
            setSpacePadding "$space" 200 30
        elif [[ $numVisibleWindows -eq 3 ]]; then
            setSpacePadding "$space" 50 15
        else
            setSpacePadding "$space" 5 5
        fi
    done
else
    setTopPadding 0

    # Get the list of spaces
    spaces=$(executeCommand "query --spaces" | jq -c '.[] | {index: .index}')

    for spaceData in $spaces; do
        space=$(echo "$spaceData" | jq -r '.index')
        setSpacePadding "$space" 5 5
    done
fi

# Check if the log file size is more than 1MB (1MB = 1048576 bytes)
if [ $(stat -f%z ~/logs/yabai.log) -ge 1048576 ]; then
    # If it is, rotate the log
    /opt/homebrew/bin/logrotate -s ~/logs/logrotate.status ~/logs/yabai.logrotate
fi
