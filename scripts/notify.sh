#!/bin/bash

# Check if we have both title and message
if [ $# -ne 2 ]; then
    echo "Usage: $0 <title> <message>"
    exit 1
fi

# Send a macOS notification
osascript -e "display notification \"$2\" with title \"$1\"" 