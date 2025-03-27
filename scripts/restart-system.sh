#!/bin/bash

# Configuration
APP_DIR="/Users/joelbiz/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
PROD_PID_FILE="$APP_DIR/prod.pid"
DEV_PID_FILE="$APP_DIR/dev.pid"
NOTIFY_SCRIPT="$APP_DIR/notify.sh"

# Function to log messages
log() {
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_DIR/system_restart.log"
}

# Function to send notifications
notify() {
    if [ -f "$NOTIFY_SCRIPT" ]; then
        "$NOTIFY_SCRIPT" "$1"
    else
        echo "Notification: $1"
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
log "Starting system restart process..."

# Stop the production server
stop_process "$PROD_PID_FILE" "production server"

# Stop the development server
stop_process "$DEV_PID_FILE" "development server"

# Clean up temporary files
log "Cleaning up temporary files..."
rm -f "$APP_DIR/.next/server/app/_not-found/page.js.nft.json" 2>/dev/null

# Final cleanup
log "System restart process completed"

# Notify user about restart
notify "WhatsDesigns servers stopped. System will restart in 5 seconds..."

# Wait 5 seconds to ensure all cleanup is complete
sleep 5

# Restart the computer
log "Executing system restart command..."
osascript -e 'tell app "System Events" to restart' 