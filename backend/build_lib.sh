#!/bin/bash

# Exit on error
set -e

echo "🔨 Building shared libraries for Shotgun Code FFI..."

# Create output directories
mkdir -p ../shotgun_flutter/macos
mkdir -p ../shotgun_flutter/linux
mkdir -p ../shotgun_flutter/windows

# Copy source files (symlinks don't work with go:embed)
echo "📋 Copying source files..."
cp -f ../app.go .
cp -f ../split_diff.go .
cp -f ../ignore.glob .

# macOS (Apple Silicon - arm64)
echo "📦 Building for macOS (Apple Silicon - arm64)..."
GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/macos/libshotgun_arm64.dylib \
  .

# macOS (Intel - amd64)
echo "📦 Building for macOS (Intel - amd64)..."
GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/macos/libshotgun_amd64.dylib \
  .

# Linux (amd64)
echo "📦 Building for Linux (amd64)..."
GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/linux/libshotgun.so \
  .

# Windows (amd64) - requires MinGW
if command -v x86_64-w64-mingw32-gcc &> /dev/null; then
  echo "📦 Building for Windows (amd64)..."
  GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc \
    go build -buildmode=c-shared \
    -o ../shotgun_flutter/windows/shotgun.dll \
    .
else
  echo "⚠️  Skipping Windows build (MinGW not installed)"
  echo "   Install with: brew install mingw-w64"
fi

echo "✅ Libraries built successfully!"
echo ""
echo "📍 Output locations:"
echo "  • macOS ARM64: shotgun_flutter/macos/libshotgun_arm64.dylib"
echo "  • macOS AMD64: shotgun_flutter/macos/libshotgun_amd64.dylib"
echo "  • Linux:       shotgun_flutter/linux/libshotgun.so"
if command -v x86_64-w64-mingw32-gcc &> /dev/null; then
  echo "  • Windows:     shotgun_flutter/windows/shotgun.dll"
fi
