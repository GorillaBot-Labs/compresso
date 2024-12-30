#!/usr/bin/env bats

setup() {
    # Create temporary test directory
    TEST_DIR="$(mktemp -d)"
    TEST_IMAGE="$TEST_DIR/test.jpg"
    
    # Create a test image using ImageMagick (v7 syntax)
    magick -size 100x100 xc:white "$TEST_IMAGE"
}

teardown() {
    # Clean up test directory
    rm -rf "$TEST_DIR"
}

@test "help command shows usage" {
    run ./compresso.sh --help
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" =~ "☕ Compresso - Lightweight images, heavy impact" ]]
}

@test "invalid format option fails" {
    run ./compresso.sh -f jpg
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: Format must be either 'webp' or 'avif'" ]]
}

@test "invalid size option fails" {
    run ./compresso.sh -s abc
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: Size must be a positive number" ]]
}

@test "processes single image to webp" {
    run ./compresso.sh "$TEST_DIR"
    [ "$status" -eq 0 ]
    [ -f "$TEST_DIR/dist/test.webp" ]
}

@test "processes single image to avif" {
    run ./compresso.sh "$TEST_DIR" -f avif
    [ "$status" -eq 0 ]
    [ -f "$TEST_DIR/dist/test.avif" ]
}

@test "resizes image correctly" {
    run ./compresso.sh "$TEST_DIR" -s 50
    [ "$status" -eq 0 ]
    
    # Check if the output image is 50px (using v7 syntax)
    SIZE=$(magick identify -format "%w" "$TEST_DIR/dist/test.webp")
    [ "$SIZE" -eq 50 ]
}

@test "version command shows version" {
    run ./compresso.sh --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Compresso v1.0.0" ]]
} 