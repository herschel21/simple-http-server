#!/bin/bash

# Define filenames and directories
SCRIPT_NAME="server.sh"
SCRIPT_PATH="$HOME/bin/$SCRIPT_NAME"
BIN_DIR="$HOME/bin"

# Create the server.sh file with the required content
echo "Creating $SCRIPT_NAME with 'python3 -m http.server'..."
echo "python3 -m http.server" > "$SCRIPT_PATH"

# Create ~/bin if it doesn't exist
echo "Creating ~/bin directory if it doesn't exist..."
mkdir -p "$BIN_DIR"

# Move the script to ~/bin
echo "Moving $SCRIPT_NAME to $BIN_DIR..."
mv "$SCRIPT_PATH" "$BIN_DIR/"

# Make the script executable
echo "Making $SCRIPT_NAME executable..."
chmod +x "$BIN_DIR/$SCRIPT_NAME"

# Ensure ~/bin is in the PATH
echo "Updating PATH..."
if ! grep -q "$BIN_DIR" "$HOME/.bashrc"; then
    echo "Adding $BIN_DIR to PATH in ~/.bashrc..."
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
fi

# Reload ~/.bashrc
echo "Reloading ~/.bashrc..."
source "$HOME/.bashrc"

echo "Setup complete. You can now use $SCRIPT_NAME from anywhere."

