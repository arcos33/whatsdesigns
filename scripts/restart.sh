#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
PROD_PID_FILE="$APP_DIR/prod.pid"
DEV_PID_FILE="$APP_DIR/dev.pid"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"

# Function to ensure directories exist
ensure_directories() {
    # Create logs directory if it doesn't exist
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
        chmod 755 "$LOG_DIR"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created logs directory" >> "$LOG_DIR/restart.log"
    fi

    # Create .next directory if it doesn't exist
    if [ ! -d "$APP_DIR/.next/server/app" ]; then
        mkdir -p "$APP_DIR/.next/server/app"
        chmod -R 755 "$APP_DIR/.next"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created Next.js build directories" >> "$LOG_DIR/restart.log"
    fi
}

# Function to log messages
log() {
    # Ensure log directory exists
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_DIR/restart.log"
}

# Function to send notifications
notify() {
    "$NOTIFY_SCRIPT" "$1"
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

# Function to start a process
start_process() {
    local process_name="$1"
    local start_command="$2"
    local pid_file="$3"
    
    log "Starting $process_name..."
    notify "Starting WhatsDesigns $process_name..."
    
    # Start the process in the background
    $start_command > "$LOG_DIR/${process_name}.log" 2>&1 &
    
    # Save the PID
    echo $! > "$pid_file"
    
    # Wait a moment to check if it's still running
    sleep 2
    if ps -p $(cat "$pid_file") > /dev/null; then
        log "$process_name started successfully with PID: $(cat $pid_file)"
        notify "WhatsDesigns $process_name started successfully"
        return 0
    else
        log "Failed to start $process_name"
        notify "Failed to start WhatsDesigns $process_name"
        return 1
    fi
}

# Function to restart application only
restart_application() {
    log "Starting application restart process..."

    # Stop the production server
    stop_process "$PROD_PID_FILE" "production server"

    # Stop the development server
    stop_process "$DEV_PID_FILE" "development server"

    # Clean up temporary files
    log "Cleaning up temporary files..."
    rm -f "$APP_DIR/.next/server/app/_not-found/page.js.nft.json" 2>/dev/null

    # Wait 5 seconds to ensure all cleanup is complete
    sleep 5

    # Start the development server
    start_process "development server" "npm run dev" "$DEV_PID_FILE"

    # Build the application for production
    log "Building application for production..."
    notify "Building WhatsDesigns for production..."
    npm run build > "$LOG_DIR/build.log" 2>&1
    if [ $? -eq 0 ]; then
        log "Build completed successfully"
        notify "WhatsDesigns build completed successfully"
    else
        log "Build failed"
        notify "WhatsDesigns build failed"
        exit 1
    fi

    # Start the production server
    start_process "production server" "npm run start:prod" "$PROD_PID_FILE"

    # Final cleanup
    log "Application restart process completed"
    notify "WhatsDesigns servers have been restarted"
}

# Function to restart system
restart_system() {
    log "Starting system restart process..."
    notify "Initiating system restart..."

    # Stop the production service
    echo "Stopping production service..."
    launchctl unload ~/Library/LaunchAgents/com.whatsdesigns.prod.plist || true

    # Wait for the service to fully stop
    echo "Waiting for production service to stop..."
    while launchctl list | grep -q "com.whatsdesigns.prod"; do
        echo "Service still running, waiting..."
        sleep 2
    done

    # Stop any running dev server (process using port 3000)
    echo "Stopping development server if running..."
    if lsof -i:3000 > /dev/null 2>&1; then
        echo "Development server found, stopping..."
        kill $(lsof -t -i:3000) || true
        
        # Wait for dev server to stop
        while lsof -i:3000 > /dev/null 2>&1; do
            echo "Development server still running, waiting..."
            sleep 2
        done
        echo "Development server stopped"
    else
        echo "No development server running"
    fi

    echo "All servers have been stopped."

    # Enable auto-login for joelbiz
    echo "Configuring auto-login..."
    # Create kcpassword file for auto-login
    echo "Creating auto-login configuration..."
    sudo rm -f /etc/kcpassword
    sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null || true
    sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUserUID 2>/dev/null || true
    sudo security authorizationdb write system.login.console allow
    sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser joelbiz

    # Restart immediately
    sudo shutdown -r now
}

# Show usage
show_usage() {
    echo "Usage: $0 [--system]"
    echo "  --system    Restart the entire system"
    echo "  (no args)   Restart only the application"
    exit 1
}

# Main execution
ensure_directories

# Parse command line arguments
if [ "$1" = "--system" ]; then
    restart_system
else
    restart_application
fi 