#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "☕ Installing Compresso..."

# Define the installation directory
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="compresso"

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo:"
    echo "sudo ./install.sh"
    exit 1
fi

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "⚠️  ImageMagick is required but not installed."
    echo "Please install it first:"
    echo "  Mac: brew install imagemagick"
    echo "  Ubuntu/Debian: sudo apt-get install imagemagick"
    exit 1
fi

# Copy the script to the installation directory
cp compresso.sh "$INSTALL_DIR/$SCRIPT_NAME"

# Make it executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo -e "${GREEN}✨ Compresso has been successfully installed!${NC}"
echo -e "${BLUE}You can now run 'compresso' from anywhere.${NC}"
echo
echo "Quick start:"
echo "  compresso                  # Process current directory"
echo "  compresso ./images         # Process specific directory"
echo "  compresso --help          # Show all options" 