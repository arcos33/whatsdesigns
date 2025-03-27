#!/bin/bash

# Exit on error
set -e

# Load Node.js environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Define paths
APP_DIR="/Users/joelbiz/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
NPM_PATH="/Users/joelbiz/.nvm/versions/node/v20.19.0/bin/npm"

# Log current directory
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Current directory before navigation: $(pwd)" >> "$LOG_DIR/directory-tracking.log"

# Navigate to the project directory
cd "$APP_DIR"

# Log directory after navigation
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Current directory after navigation: $(pwd)" >> "$LOG_DIR/directory-tracking.log"

# Log directory contents
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Directory contents:" >> "$LOG_DIR/directory-tracking.log"
ls -la >> "$LOG_DIR/directory-tracking.log"

# Check if npm exists
if [ ! -f "$NPM_PATH" ]; then
    echo "Error: npm not found at $NPM_PATH" >> "$LOG_DIR/prod-error.log"
    exit 1
fi

# Load environment variables
source "$APP_DIR/config/.env.production"

# Start the production server
"$NPM_PATH" run start:prod 