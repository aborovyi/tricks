#!/bin/bash

# This script enables Screen sharing for Zoom and Slack, I depend on.

# Tweak ~/.config/autostart/slack.desktop to enable sharing in slack
SLACK_AUTOSTART_FILE="${HOME}/.config/autostart/slack.desktop"
OS_RELEASE_FILE="/etc/os-release"

echo -n "Checking Slack: "
if test -f "$SLACK_AUTOSTART_FILE"; then
    if [[ $(grep -E -q "/bin/slack %U$" "$SLACK_AUTOSTART_FILE") == 0 ]]; then
        echo "updated."
        sed -i \
            's/\/bin\/slack %U/\/bin\/slack %U --enable-features=WebRTCPipeWireCapturer/' \
            "$SLACK_AUTOSTART_FILE"
    else
        echo "no need to update."
    fi
else
    echo "Slack not in autostart. Skipping."
fi

# Tweak /etc/os-release to enable desktop sharing in Zoom
echo -e "Checking /etc/os-release to enable screen sharing in Zoom."
VERSION_ID=$(grep VERSION_ID $OS_RELEASE_FILE)
if [[ $VERSION_ID == "" ]]; then
    echo "No VERSION_ID. Adding new one."
    echo "VERSION_ID=999" >> "$OS_RELEASE_FILE"
else 
    if [[ $(echo "$VERSION_ID" | cut -d= -f2) != "999" ]]; then
        echo "VERSION_ID exists. Updating."
        sed -i "s/$VERSION_ID/VERSION_ID=999/" "$OS_RELEASE_FILE"
    else
        echo "VERSION_ID is OK."
    fi
fi
