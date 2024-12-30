#!/bin/bash

# Help function
show_help() {
    echo "Image Conversion and Compression Tool"
    echo
    echo "Usage: $(basename "$0") [SOURCE_DIR] [options]"
    echo
    echo "Arguments:"
    echo "  SOURCE_DIR                 Directory containing images (default: current directory)"
    echo
    echo "Options:"
    echo "  -f, --format FORMAT       Output format: 'webp' or 'avif' (default: webp)"
    echo "  -s, --size PIXELS         Maximum dimension in pixels (default: 1920)"
    echo "  -h, --help               Show this help message"
    echo
    echo "Examples:"
    echo "  $(basename "$0")                           # Process current directory"
    echo "  $(basename "$0") ./images                  # Process specific directory"
    echo "  $(basename "$0") ./images -f avif          # Convert to AVIF format"
    echo "  $(basename "$0") ./images -s 800           # Resize to max 800px"
    echo "  $(basename "$0") ./images -f webp -s 600   # Convert and resize"
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
                echo "Error: Format must be 'webp' or 'avif'"
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
            echo "Use --help to see usage information"
            exit 1 
            ;;
    esac
    shift
done

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick is not installed"
    echo "Please install it first:"
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
        echo "Converting '$file' to $FORMAT in $DEST_DIR..."
        
        # Use magick for conversion
        magick "$file" \
            -strip \
            -resize "${MAX_DIMENSION}x${MAX_DIMENSION}>" \
            -quality "$QUALITY" \
            "$DEST_DIR/$base_name.$FORMAT"
        
        # Check if the command succeeded
        if [[ $? -ne 0 ]]; then
            echo "Error processing '$file'. Skipping..."
        fi
    else
        echo "Skipping '$file' (not an image)."
    fi
done

echo "Conversion complete. Files saved in $DEST_DIR as $FORMAT."
