#!/bin/bash

# Configuration
APP_DIR="/Users/joelbiz/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
PID_FILE="$APP_DIR/dev.pid"
NOTIFY_SCRIPT="$APP_DIR/notify.sh"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_DIR/dev.log"
}

# Function to send notifications
notify() {
    "$NOTIFY_SCRIPT" "$1"
}

# Function to check if server is running
is_server_running() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null; then
            return 0
        fi
    fi
    return 1
}

# Function to start the server
start_server() {
    log "Starting development server..."
    notify "Starting WhatsDesigns development server..."

    if is_server_running; then
        log "Development server is already running"
        notify "WhatsDesigns development server is already running"
        return 1
    fi

    # Start the server in the background and save its PID
    cd "$APP_DIR" && npm run dev > "$LOG_DIR/dev-output.log" 2> "$LOG_DIR/dev-error.log" &
    echo $! > "$PID_FILE"

    # Wait for server to start
    for i in {1..30}; do
        if curl -s http://localhost:3000 > /dev/null; then
            log "Development server started successfully"
            notify "WhatsDesigns development server started successfully"
            return 0
        fi
        sleep 1
    done

    log "Development server failed to start"
    notify "WhatsDesigns development server failed to start"
    return 1
}

# Main execution
start_server 