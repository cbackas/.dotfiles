#!/bin/bash

# Query the active space
active_space=$(yabai -m query --spaces --display | jq -r '.[] | select(."has-focus" == true) .index')

# Query all windows in the active space
windows=$(yabai -m query --windows --space $active_space)

# Parse out IDs of windows where the app is "Code" (Visual Studio Code)
vscode_windows=$(echo $windows | jq '.[] | select(.app == "Code") | .id')

# Check the number of VS Code windows
vscode_windows_count=$(echo $vscode_windows | wc -w)

# If there is more than one VS Code window
if [ $vscode_windows_count -gt 1 ]; then
    # Get the first window ID for initial stacking
    first_window=$(echo $vscode_windows | awk '{print $1}')

    # Iterate over all the window IDs, stacking each one
    for window in $vscode_windows; do
        if [ "$window" != "$first_window" ]; then
            yabai -m window $first_window --stack $window
        fi
    done

    echo "All Visual Studio Code windows in space $active_space have been stacked."
else
    echo "There is $vscode_windows_count Visual Studio Code window(s) in space $active_space. No stacking needed."
fi

