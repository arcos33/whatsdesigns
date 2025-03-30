#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
PID_FILE="$APP_DIR/prod.pid"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log messages
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" | tee -a "$LOG_DIR/stop-prod.log"
}

# Function to send notifications
notify() {
    if [ -f "$NOTIFY_SCRIPT" ]; then
        "$NOTIFY_SCRIPT" "Production Server" "$1"
    fi
}

# Function to check if a process is running
is_process_running() {
    local pid_file="$1"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null; then
            return 0
        fi
    fi
    return 1
}

# Function to stop a process
stop_process() {
    local pid_file="$1"
    local process_name="$2"
    
    log "Stopping $process_name..."
    notify "Stopping WhatsDesigns $process_name..."

    if is_process_running "$pid_file"; then
        local pid=$(cat "$pid_file")
        log "Found $process_name process with PID: $pid"
        
        # Send SIGTERM first
        kill -TERM "$pid"
        log "Sent SIGTERM to process $pid"
        
        # Wait for process to terminate
        for i in {1..10}; do
            if ! ps -p "$pid" > /dev/null; then
                log "$process_name stopped successfully"
                notify "WhatsDesigns $process_name stopped successfully"
                rm -f "$pid_file"
                return 0
            fi
            sleep 1
        done
        
        # If still running, send SIGKILL
        if ps -p "$pid" > /dev/null; then
            log "$process_name did not stop gracefully, sending SIGKILL"
            kill -KILL "$pid"
            sleep 2
            if ! ps -p "$pid" > /dev/null; then
                log "$process_name stopped forcefully"
                notify "WhatsDesigns $process_name stopped forcefully"
                rm -f "$pid_file"
                return 0
            fi
        fi
    else
        log "No running $process_name found"
        notify "No running WhatsDesigns $process_name found"
        return 0
    fi
}

# Main execution
log "Starting production environment shutdown..."

# Stop the production server
stop_process "$PID_FILE" "production server"

# Stop any Node.js processes running on port 3002
if lsof -i :3002 > /dev/null 2>&1; then
    log "Stopping process on port 3002..."
    kill $(lsof -t -i :3002)
    sleep 2
fi

# Stop Nginx
log "Stopping Nginx..."
if sudo brew services stop nginx; then
    log "Nginx stopped successfully"
else
    log "${RED}Failed to stop Nginx${NC}"
fi

# Stop MongoDB
log "Stopping MongoDB..."
if brew services stop mongodb-community; then
    log "MongoDB stopped successfully"
else
    log "${RED}Failed to stop MongoDB${NC}"
fi

# Clean up temporary files
log "Cleaning up temporary files..."
rm -f "$APP_DIR/.next/server/app/_not-found/page.js.nft.json" 2>/dev/null

# Final cleanup
log "Production environment shutdown completed"
notify "Production environment stopped" 