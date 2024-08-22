#!/bin/bash

# Prompt user for IP address
read -p "Enter the IP address of the server: " SERVER_IP
SERVER_PORT=8000

# Check if the server is running
if ! curl -s http://$SERVER_IP:$SERVER_PORT > /dev/null; then
    echo "Starting HTTP server..."
    python3 -m http.server --bind $SERVER_IP $SERVER_PORT &
    sleep 2
fi

# Start a loop to allow multiple operations
while true; do
    # Display menu
    echo "1. List directory contents"
    echo "2. Download a file"
    echo "3. Open a file"
    echo "4. Exit"

    # Read the user's choice
    read -p "Choose an option: " option

    # Handle the user's choice
    case $option in
        1)
            echo "Listing directory contents..."
            curl -s http://$SERVER_IP:$SERVER_PORT | grep -oP '(?<=href=")[^"]*'
            ;;
        2)
            read -p "Enter the filename to download: " filename
            curl -O http://$SERVER_IP:$SERVER_PORT/$filename
            echo "$filename downloaded."
            ;;
        3)
            read -p "Enter the filename to open: " filename
            curl -s http://$SERVER_IP:$SERVER_PORT/$filename > $filename
            xdg-open $filename
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option! Please choose again."
            ;;
    esac

    # Wait for a moment before showing the menu again
    echo
done

