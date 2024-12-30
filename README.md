# Compresso

> Lightweight images, heavy impact

A powerful command-line tool that transforms your images into optimized web formats while preserving quality. Perfect for developers and designers who care about performance and aesthetics.

<div align="center">
  <img src="assets/compresso-logo.png" width="180" alt="Compresso Logo">
</div>

## ☕ Why Compresso?

- **Effortless Optimization**: Convert images to WebP or AVIF with a single command
- **Smart Resizing**: Maintain aspect ratios while reducing dimensions
- **Batch Processing**: Handle multiple images in one go
- **Quality Preserved**: Optimal compression without visible quality loss
- **Modern Formats**: Support for HEIC, PNG, JPEG, and JPG conversion

## 🚀 Quick Start

### Prerequisites

First, make sure you have ImageMagick installed:

- **macOS:**

  ```bash
  brew install imagemagick
  ```

- **Ubuntu/Debian:**
  ```bash
  sudo apt-get install imagemagick
  ```

### Installation

1. Download Compresso:

   ```bash
   git clone https://github.com/yourusername/compresso.git
   cd compresso
   ```

2. Make the scripts executable:

   ```bash
   chmod +x install.sh compresso.sh
   ```

3. Run the installer:

   ```bash
   sudo ./install.sh
   ```

4. Verify the installation:
   ```bash
   compresso --help
   ```

## ⚡ Usage

Compress all images in a directory:

```bash
./compresso.sh [SOURCE_DIR]
```

### Options

| Option | Long Form  | Description                      | Default |
| ------ | ---------- | -------------------------------- | ------- |
| `-f`   | `--format` | Output format (`webp` or `avif`) | `webp`  |
| `-s`   | `--size`   | Maximum dimension in pixels      | `1920`  |
| `-h`   | `--help`   | Show brewing instructions        | -       |

### Examples

```bash
./compresso.sh [SOURCE_DIR] [options]

# Process current directory
./compresso.sh

# Process specific directory
./compresso.sh ./images

# Convert to AVIF format
./compresso.sh ./images -f avif

# Resize to max 800px
./compresso.sh ./images -s 800

# Convert and resize
./compresso.sh ./images -f webp -s 600
```

## 📦 Output

Your freshly compressed images are served in a `dist` folder within the source directory, maintaining original filenames with new format extensions.

## ✨ Pro Tips

- Original images are always preserved
- Large images are automatically resized while maintaining quality
- Small images stay untouched - no unnecessary upscaling
- We use a carefully chosen 75% quality setting for the perfect balance

## 📄 Testing

### Prerequisites

Install BATS (Bash Automated Testing System):

**macOS:**

```bash
brew install bats-core
```

**Ubuntu/Debian:**

```bash
sudo apt-get install bats
```

### Running Tests

Run all tests:

```bash
bats tests/compresso.bats
```

### Test Coverage

The test suite verifies:

- Command-line argument validation
- Format conversion functionality
- Image resizing capabilities
- Help text display
- Error handling
- Output file generation

### Adding New Tests

Tests are written using BATS syntax. See `tests/compresso.bats` for examples.

## 📄 License

MIT License - Feel free to use Compresso in your projects!

## 🤝 Contributing

Love Compresso? Contributions are welcome! Feel free to submit a Pull Request.

---

<div align="center">
  <p>Crafted with ☕ by the Compresso team</p>
</div>
