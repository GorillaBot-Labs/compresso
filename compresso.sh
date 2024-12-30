#!/bin/bash

# Help function
show_help() {
    echo "☕ Compresso - Lightweight images, heavy impact"
    echo
    echo "Usage: $(basename "$0") [SOURCE_DIR] [options]"
    echo
    echo "Arguments:"
    echo "  SOURCE_DIR                 Directory containing images (default: current directory)"
    echo
    echo "Options:"
    echo "  -f, --format FORMAT       Choose your brew: 'webp' or 'avif' (default: webp)"
    echo "  -s, --size PIXELS         Cup size in pixels (default: 1920)"
    echo "  -h, --help               Show brewing instructions"
    echo
    echo "Examples:"
    echo "  $(basename "$0")                           # Brew from current directory"
    echo "  $(basename "$0") ./images                  # Select your beans (directory)"
    echo "  $(basename "$0") ./images -f avif          # Try our AVIF roast"
    echo "  $(basename "$0") ./images -s 800           # Small batch (800px)"
    echo "  $(basename "$0") ./images -f webp -s 600   # Custom order (WebP, 600px)"
}

# Default values
SOURCE_DIR=${1:-"."}
FORMAT="webp"
MAX_DIMENSION="1920"
QUALITY=75

shift # Remove the first argument (SOURCE_DIR) from processing

# Parse named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) 
            show_help
            exit 0 
            ;;
        -f|--format) 
            FORMAT="$2"
            if [[ "$FORMAT" != "webp" && "$FORMAT" != "avif" ]]; then
                echo "Error: Format must be either 'webp' or 'avif'"
                exit 1
            fi
            shift 
            ;;
        -s|--size) 
            if ! [[ "$2" =~ ^[0-9]+$ ]]; then
                echo "Error: Size must be a positive number"
                exit 1
            fi
            MAX_DIMENSION="$2"
            shift 
            ;;
        *) 
            echo "Error: Unknown parameter '$1'"
            echo "Use --help to see brewing instructions"
            exit 1 
            ;;
    esac
    shift
done

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "☕ Oops! Looks like we're missing our brewing equipment (ImageMagick)"
    echo "Let's get that installed first:"
    echo "  Mac: brew install imagemagick"
    echo "  Ubuntu/Debian: sudo apt-get install imagemagick"
    exit 1
fi

# Create the dist folder relative to the source directory
DEST_DIR="$SOURCE_DIR/dist"
mkdir -p "$DEST_DIR"

# Process each file in the source directory
for file in "$SOURCE_DIR"/*; do
    # Get file extension and name
    extension="${file##*.}"
    base_name=$(basename "$file" ."$extension")

    # Check if it's an image
    if [[ "$extension" =~ ^(heic|HEIC|png|PNG|jpeg|JPEG|jpg|JPG)$ ]]; then
        echo "☕ Brewing '$file' to $FORMAT in $DEST_DIR..."
        
        # Use magick for conversion
        magick "$file" \
            -strip \
            -resize "${MAX_DIMENSION}x${MAX_DIMENSION}>" \
            -quality "$QUALITY" \
            "$DEST_DIR/$base_name.$FORMAT"
        
        # Check if the command succeeded
        if [[ $? -ne 0 ]]; then
            echo "⚠️  Oops! Couldn't process '$file'. Skipping this batch..."
        fi
    else
        echo "Skipping '$file' (not the right beans for this brew)."
    fi
done

echo "☕ Your fresh batch is ready! Files served in $DEST_DIR as $FORMAT."
