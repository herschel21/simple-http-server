#!/bin/bash

# Define filenames and directories
CLIENT_SCRIPT_NAME="client.sh"
CLIENT_SCRIPT_PATH="$HOME/bin/$CLIENT_SCRIPT_NAME"
BIN_DIR="$HOME/bin"

# Create the client.sh file with the required content
echo "Creating $CLIENT_SCRIPT_NAME with the client script content..."
cat << 'EOF' > "$CLIENT_SCRIPT_PATH"
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
EOF

# Create ~/bin if it doesn't exist
echo "Creating ~/bin directory if it doesn't exist..."
mkdir -p "$BIN_DIR"

# Move the script to ~/bin
echo "Moving $CLIENT_SCRIPT_NAME to $BIN_DIR..."
mv "$CLIENT_SCRIPT_PATH" "$BIN_DIR/"

# Make the script executable
echo "Making $CLIENT_SCRIPT_NAME executable..."
chmod +x "$BIN_DIR/$CLIENT_SCRIPT_NAME"

# Ensure ~/bin is in the PATH
echo "Updating PATH..."
if ! grep -q "$BIN_DIR" "$HOME/.bashrc"; then
    echo "Adding $BIN_DIR to PATH in ~/.bashrc..."
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
fi

# Reload ~/.bashrc
echo "Reloading ~/.bashrc..."
source "$HOME/.bashrc"

echo "Setup complete. You can now use $CLIENT_SCRIPT_NAME from anywhere."

