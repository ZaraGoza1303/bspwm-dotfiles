#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[WARNING] This uninstall script was created based on the README and general dotfiles practices.${NC}"
echo -e "${YELLOW}            This script does NOT know exactly what the original install.sh did.${NC}"
echo -e "${YELLOW}            It is recommended to check the install.sh file first for more accurate steps.${NC}"
echo ""
read -p "Continue with the uninstall process? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${RED}Uninstall cancelled.${NC}"
    exit 1
fi

echo -e "${YELLOW}Starting uninstall process...${NC}"

# 1. Restore original configuration files from backup (if any)
CONFIG_DIR="$HOME/.config"
BACKUP_SUFFIX=".bak"

APPS=("bspwm" "sxhkd" "polybar" "rofi" "alacritty" "picom")

echo -e "${YELLOW}Restoring configuration backups (if found)...${NC}"
for app in "${APPS[@]}"; do
    if [ -d "$CONFIG_DIR/$app" ] && [ -d "$CONFIG_DIR/$app$BACKUP_SUFFIX" ]; then
        echo "Restoring $app from backup..."
        rm -rf "$CONFIG_DIR/$app"
        mv "$CONFIG_DIR/$app$BACKUP_SUFFIX" "$CONFIG_DIR/$app"
        echo -e "${GREEN}  -> $app configuration restored.${NC}"
    elif [ -L "$CONFIG_DIR/$app" ]; then
        # If it's just a symlink, remove the symlink
        echo "Removing $app symlink..."
        rm "$CONFIG_DIR/$app"
        echo -e "${GREEN}  -> $app symlink removed.${NC}"
    fi
done

# 2. Delete specific files/directories if no backup exists (and not a symlink)
echo -e "${YELLOW}Cleaning up other possible configuration directories...${NC}"
# This script will not delete the .config folder if it contains other data
# Only flags directories that are specifically from these dotfiles
for app in "${APPS[@]}"; do
    if [ -d "$CONFIG_DIR/$app" ] && [ ! -L "$CONFIG_DIR/$app" ]; then
        # Check if the directory still exists? Safer to ask user to delete manually
        echo -e "${YELLOW}  - Directory $CONFIG_DIR/$app still exists. Delete manually if not needed.${NC}"
    fi
done

# 3. Clean up Betterlockscreen
echo -e "${YELLOW}Cleaning up Betterlockscreen...${NC}"
if command -v betterlockscreen &> /dev/null; then
    echo "Clearing betterlockscreen cache..."
    betterlockscreen -u "REMOVE" 2>/dev/null # Common way to clear cache
    rm -rf "$HOME/.cache/betterlockscreen"
    echo -e "${GREEN}  -> Betterlockscreen cache deleted.${NC}"
else
    echo -e "${YELLOW}  - betterlockscreen not found, skipping.${NC}"
fi

# 4. Remove GTK Theme (ONLY IF INSTALLED BY THIS SCRIPT)
echo -e "${YELLOW}Cleaning up GTK Theme (Nordic-darker)...${NC}"
THEME_DIR="/usr/share/themes/Nordic-darker"
if [ -d "$THEME_DIR" ]; then
    echo "Deleting Nordic-darker theme (requires sudo)..."
    sudo rm -rf "$THEME_DIR"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  -> Theme deleted.${NC}"
    else
        echo -e "${RED}  -> Failed to delete theme. Manual sudo might be required.${NC}"
    fi
else
    echo -e "${YELLOW}  - Nordic-darker theme not found in /usr/share/themes, skipping.${NC}"
fi

# 5. Remove betterlockscreen wallpaper (if stored in common location)
echo -e "${YELLOW}Cleaning up wallpapers for betterlockscreen...${NC}"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
if [ -d "$WALLPAPER_DIR" ]; then
    echo -e "${YELLOW}  - Directory $WALLPAPER_DIR found. Delete manually if it was specific to these dotfiles.${NC}"
fi

# 6. Final Notes
echo ""
echo -e "${GREEN}Uninstall process complete.${NC}"
echo -e "${YELLOW}IMPORTANT NOTES:${NC}"
echo -e "${YELLOW}1. This script DOES NOT remove packages (dependencies) like bspwm, sxhkd, polybar, etc.${NC}"
echo -e "${YELLOW}   Remove them manually using your package manager (apt, pacman, etc.) if desired.${NC}"
echo -e "${YELLOW}2. Check the $HOME/.config directory for any remaining configuration leftovers.${NC}"
echo -e "${YELLOW}3. If there were other manual steps from the README (like setting wallpaper), please revert them manually.${NC}"
