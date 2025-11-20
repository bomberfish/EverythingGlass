#!/bin/bash

# Simple PKG builder for BrokenGlass

# Paths
BUILD_FILE="./build/Debug/libBrokenGlass.dylib"
PKG_NAME="BrokenGlass.pkg"
TEMP_DIR="$(mktemp -d)"
PAYLOAD_DIR="$TEMP_DIR/payload"
SCRIPTS_DIR="$TEMP_DIR/scripts"

# Check build exists
if [ ! -f "$BUILD_FILE" ]; then
    echo "Error: $BUILD_FILE not found"
    exit 1
fi

# Create directory structure
mkdir -p "$PAYLOAD_DIR/var/ammonia/core/tweaks"
mkdir -p "$SCRIPTS_DIR"

# Copy tweak dylib
cp "$BUILD_FILE" "$PAYLOAD_DIR/var/ammonia/core/tweaks/"

# Create postinstall script
cat > "$SCRIPTS_DIR/postinstall" << 'EOF'
#!/bin/bash

# Touch empty blacklist file
touch /var/ammonia/core/tweaks/libBrokenGlass.dylib.blacklist

exit 0
EOF

chmod +x "$SCRIPTS_DIR/postinstall"

# Build PKG
pkgbuild \
    --root "$PAYLOAD_DIR" \
    --scripts "$SCRIPTS_DIR" \
    --identifier com.bedtime.brokenglass \
    --version 1.0 \
    --install-location "/" \
    "$PKG_NAME"

# Clean up
rm -rf "$TEMP_DIR"

echo "Created package: $PKG_NAME"
