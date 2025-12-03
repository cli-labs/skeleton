#!/bin/sh
set -e

echo "Installing skeleton CLI setup..."

# Step 1: Create .cli-labs and skeleton folder
CLI_DIR="$HOME/.cli-labs"
SKELETON_DIR="$CLI_DIR/skeleton"
BIN_DIR="$SKELETON_DIR/bin"

mkdir -p "$BIN_DIR"

# Step 2: Write skeleton env file (plain text, no execute permission needed)
ENV_FILE="$SKELETON_DIR/env"
touch "$ENV_FILE"
# Ensure env file is NOT executable
chmod 644 "$ENV_FILE"

cat > "$ENV_FILE" << EOF
#!/bin/sh
# Skeleton CLI environment
# affix colons on either side of \$PATH variable to simplify matching
# add skeleton CLI bin to \$PATH if not already present
case ":\$PATH:" in
    *:"\$HOME/.cli-labs/skeleton/bin":*)
        ;;
    *)
        export PATH="\$HOME/.cli-labs/skeleton/bin:\$PATH"
        ;;
esac
EOF

# Step 3: Add env sourcing to shell profiles (bash, zsh compatible if zsh reads profile)
for PROFILE in "$HOME/.bash_profile" "$HOME/.profile" "$HOME/.zshenv"; do
    SOURCE_LINE='. "$HOME/.cli-labs/skeleton/env"'

    if [ -f "$PROFILE" ]; then
        # Only add the sourcing line if it doesn't already exist
        if ! grep -Fxq "$SOURCE_LINE" "$PROFILE"; then
            echo "$SOURCE_LINE" >> "$PROFILE"
        fi
    fi
done

# Step 4: Download skeleton binary from GitHub Releases
SKELETON_URL="https://github.com/cli-labs/skeleton/releases/latest/download/skeleton"

echo "Downloading skeleton executable..."
curl -L "$SKELETON_URL" -o "$BIN_DIR/skeleton"

chmod +x "$BIN_DIR/skeleton"

echo "Skeleton CLI installed successfully!"
echo "Binary location: $BIN_DIR/skeleton"
echo "Reload your terminal or run: . \"$ENV_FILE\""
echo "Then you can run 'skeleton' from anywhere in your terminal."
