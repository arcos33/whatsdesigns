#!/bin/bash

# =============================================================================
# ONE-TIME SETUP SCRIPT
# =============================================================================
# This script sets up the production environment as a macOS LaunchAgent service.
# It only needs to be run ONCE to configure automatic startup of the production
# environment when your system boots.
#
# After running this script:
# - The production environment will start automatically on system boot
# - You don't need to run this script again unless you need to reinstall the service
# - Use start-prod.sh to manually start the production environment
# - Use stop-prod.sh to stop the production environment
#
# To verify the setup:
#   launchctl list | grep whatsdesigns
# =============================================================================

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log messages
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] $1"
}

# Function to install a service
install_service() {
    local service_name="$1"
    local plist_file="$APP_DIR/scripts/$service_name.plist"
    local target_file="$LAUNCH_AGENTS_DIR/$service_name.plist"
    
    log "Installing $service_name service..."
    
    # Uninstall existing service first
    if [ -f "$target_file" ]; then
        launchctl unload "$target_file" 2>/dev/null
        rm -f "$target_file"
    fi
    
    # Copy plist file to LaunchAgents directory
    cp "$plist_file" "$target_file"
    if [ $? -ne 0 ]; then
        log "${RED}Failed to copy $service_name plist file${NC}"
        return 1
    fi
    
    # Set correct permissions
    chmod 644 "$target_file"
    
    # Load the service
    launchctl load "$target_file"
    if [ $? -ne 0 ]; then
        log "${RED}Failed to load $service_name service${NC}"
        return 1
    fi
    
    log "${GREEN}Successfully installed and loaded $service_name service${NC}"
    return 0
}

# Create LaunchAgents directory if it doesn't exist
if [ ! -d "$LAUNCH_AGENTS_DIR" ]; then
    mkdir -p "$LAUNCH_AGENTS_DIR"
    chmod 755 "$LAUNCH_AGENTS_DIR"
fi

# Install production service
install_service "com.whatsdesigns.prod"

log "${GREEN}Production service installation completed${NC}" 