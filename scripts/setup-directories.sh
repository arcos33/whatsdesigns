#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
CONFIG_DIR="$APP_DIR/config"
BUILD_DIR="$APP_DIR/.next"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to send notifications
notify() {
    "$NOTIFY_SCRIPT" "$1"
}

# Function to create directory with proper permissions
create_directory() {
    local dir="$1"
    local description="$2"
    
    if [ ! -d "$dir" ]; then
        log "Creating $description directory: $dir"
        mkdir -p "$dir"
        chmod 755 "$dir"
        log "Created $description directory with permissions 755"
    else
        log "$description directory already exists: $dir"
    fi
}

# Main execution
log "Starting directory setup process..."
notify "Setting up WhatsDesigns directories..."

# Create logs directory
create_directory "$LOG_DIR" "logs"

# Create config directory
create_directory "$CONFIG_DIR" "configuration"

# Create Next.js build directories
create_directory "$BUILD_DIR" "Next.js build"
create_directory "$BUILD_DIR/server" "Next.js server"
create_directory "$BUILD_DIR/server/app" "Next.js server app"
chmod -R 755 "$BUILD_DIR"

# Create src directory structure if it doesn't exist
create_directory "$APP_DIR/src" "source"
create_directory "$APP_DIR/src/app" "Next.js app router"
create_directory "$APP_DIR/src/components" "React components"
create_directory "$APP_DIR/src/pages" "Next.js pages"
create_directory "$APP_DIR/src/utils" "utilities"

# Create public directory for static assets
create_directory "$APP_DIR/public" "public assets"

log "Directory setup completed successfully"
notify "WhatsDesigns directories have been set up successfully" 