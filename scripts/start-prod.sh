#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"
PID_FILE="$APP_DIR/prod.pid"
NEXT_PID_FILE="$APP_DIR/.next/server/app/page.js.pid"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to ensure required directories exist
ensure_directories() {
    local dirs=(
        "$LOG_DIR"
        "$APP_DIR/.next/server/app"
        "$APP_DIR/public"
        "$APP_DIR/config"
    )
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            chmod 755 "$dir"
            log "Created directory: $dir"
        fi
    done
}

# Function to log messages
log() {
    ensure_directories
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] $1" | tee -a "$LOG_DIR/prod.log"
}

# Function to send notifications
notify() {
    if [ -f "$NOTIFY_SCRIPT" ]; then
        "$NOTIFY_SCRIPT" "WhatsDesigns Production" "$1"
    else
        log "Notification script not found at $NOTIFY_SCRIPT"
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
    
    if is_process_running "$pid_file"; then
        local pid=$(cat "$pid_file")
        log "Stopping $process_name (PID: $pid)..."
        
        # Try graceful shutdown first
        kill -TERM "$pid"
        
        # Wait for process to terminate
        for i in {1..10}; do
            if ! ps -p "$pid" > /dev/null; then
                log "${GREEN}$process_name stopped successfully${NC}"
                rm -f "$pid_file"
                return 0
            fi
            sleep 1
        done
        
        # If still running, force kill
        if ps -p "$pid" > /dev/null; then
            log "${YELLOW}$process_name did not stop gracefully, sending SIGKILL${NC}"
            kill -KILL "$pid"
            sleep 2
            if ! ps -p "$pid" > /dev/null; then
                log "${GREEN}$process_name stopped forcefully${NC}"
                rm -f "$pid_file"
                return 0
            fi
        fi
    else
        log "No running $process_name found"
        return 0
    fi
}

# Function to check if server is already running
check_server() {
    # Check main PID file
    if is_process_running "$PID_FILE"; then
        local pid=$(cat "$PID_FILE")
        log "${YELLOW}Production server is already running with PID: $pid${NC}"
        notify "WhatsDesigns Production server is already running on port 3002"
        exit 1
    fi
    
    # Check Next.js PID file
    if is_process_running "$NEXT_PID_FILE"; then
        local pid=$(cat "$NEXT_PID_FILE")
        log "${YELLOW}Found stale Next.js process with PID: $pid${NC}"
        stop_process "$NEXT_PID_FILE" "Next.js process"
    fi
    
    # Check for any processes on port 3002
    if lsof -i :3002 > /dev/null 2>&1; then
        local pid=$(lsof -t -i :3002)
        log "${YELLOW}Found process running on port 3002 (PID: $pid)${NC}"
        kill "$pid"
        sleep 2
    fi
}

# Function to check and start Caffeine
check_caffeine() {
    log "Checking Caffeine status..."
    
    # Check if we're on Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        log "Detected Apple Silicon Mac (M1/M2/M3)"
        
        # Check if Rosetta 2 is installed
        if ! /usr/bin/pgrep -q oahd; then
            log "${YELLOW}Rosetta 2 is not installed. Installing Rosetta 2...${NC}"
            notify "📦 Installing Rosetta 2 for M1/M2/M3 compatibility..."
            
            # Install Rosetta 2
            if ! softwareupdate --install-rosetta --agree-to-license > /dev/null 2>&1; then
                log "${RED}Failed to install Rosetta 2${NC}"
                notify "❌ Rosetta 2 Installation Failed - Check logs for details"
                return 1
            fi
            
            log "${GREEN}Rosetta 2 installed successfully${NC}"
            notify "✅ Rosetta 2 Installed Successfully"
        else
            log "${GREEN}Rosetta 2 is already installed${NC}"
        fi
    fi
    
    # Check if Caffeine is installed
    if ! command -v caffeinate &> /dev/null; then
        log "${YELLOW}Using built-in caffeinate command instead of Caffeine app${NC}"
        
        # Start caffeinate command (built-in to macOS)
        caffeinate -d -i &
        CAFFEINE_PID=$!
        
        # Store the PID
        echo $CAFFEINE_PID > "$APP_DIR/caffeine.pid"
        
        log "${GREEN}System caffeinate started (PID: $CAFFEINE_PID)${NC}"
        notify "✅ System Caffeinate Running"
        return 0
    elif ! ps aux | grep -v grep | grep -q "Caffeine.app"; then
        log "${YELLOW}Caffeine app is not running. Starting Caffeine app...${NC}"
        notify "⚡ Starting Caffeine App..."
        open -a Caffeine
        sleep 2
        
        # Verify Caffeine is running
        if ps aux | grep -v grep | grep -q "Caffeine.app"; then
            log "${GREEN}Caffeine app is running${NC}"
            notify "✅ Caffeine App Running"
            return 0
        else
            log "${YELLOW}Falling back to built-in caffeinate command${NC}"
            
            # Start caffeinate command (built-in to macOS)
            caffeinate -d -i &
            CAFFEINE_PID=$!
            
            # Store the PID
            echo $CAFFEINE_PID > "$APP_DIR/caffeine.pid"
            
            log "${GREEN}System caffeinate started (PID: $CAFFEINE_PID)${NC}"
            notify "✅ System Caffeinate Running"
            return 0
        fi
    else
        log "${GREEN}Caffeine is already running${NC}"
        notify "✅ Caffeine App Already Running"
        return 0
    fi
}

# Function to start the server
start_server() {
    log "Starting production server..."
    notify "🔄 Starting WhatsDesigns Production Server"
    
    # Change to app directory
    cd "$APP_DIR"
    
    # Clean up any stale files
    rm -f "$PID_FILE" "$NEXT_PID_FILE"
    rm -f "$APP_DIR/.next/server/app/_not-found/page.js.nft.json" 2>/dev/null
    
    # Ensure we have a fresh build
    log "Building application..."
    notify "🏗️ Building WhatsDesigns Production Application..."
    if ! npm run build:prod; then
        log "${RED}Build failed${NC}"
        notify "❌ Build Failed - Check logs for details"
        exit 1
    fi
    
    # Copy static files to standalone directory
    log "Copying static files..."
    cp -r public .next/standalone/
    cp -r .next/static .next/standalone/.next/
    
    # Make sure we also copy the production environment file
    log "Copying production environment file..."
    cp config/.env.production .next/standalone/.env.production
    
    # Start the server using standalone mode
    log "Starting Next.js server..."
    notify "🚀 Launching Production Server on Port 3002"
    
    # Use a clearer server startup approach
    cd .next/standalone
    # Load the production environment variables
    set -a
    source .env.production
    set +a
    PORT=3002 NODE_ENV=production node server.js > "$LOG_DIR/prod-output.log" 2> "$LOG_DIR/prod-error.log" &
    SERVER_PID=$!
    
    # Store the PID
    echo $SERVER_PID > "$PID_FILE"
    log "Server started with PID: $SERVER_PID"
    
    # Detach the process from the terminal
    disown $SERVER_PID
    
    # Wait for server to start
    for i in {1..30}; do
        if curl -s http://localhost:3002 > /dev/null; then
            log "${GREEN}Production server started successfully with PID: $(cat "$PID_FILE")${NC}"
            notify "✅ Production Server Running - Access at https://whatsdesigns.com"
            return 0
        fi
        sleep 1
    done
    
    # If we get here, the server failed to start
    log "${RED}Server failed to start${NC}"
    log "Checking server process..."
    if ps -p $SERVER_PID > /dev/null; then
        log "${YELLOW}Server process is running but not responding${NC}"
    else
        log "${RED}Server process is not running${NC}"
    fi
    notify "❌ Server Failed to Start - Check logs for details"
    exit 1
}

# Main execution
log "Starting production environment setup..."
notify "🚀 Starting WhatsDesigns Production Environment Setup"

# Run prerequisites check
if ! ./scripts/check-prerequisites.sh; then
    log "${RED}Prerequisites check failed. Please fix the issues and try again.${NC}"
    notify "❌ Prerequisites Check Failed - Check logs for details"
    exit 1
fi

# Check and start Caffeine (but make it optional)
if ! check_caffeine; then
    log "${YELLOW}Caffeine service check failed, but continuing anyway...${NC}"
    notify "⚠️ Caffeine Service Failed - Server will still start"
fi

# Start the server
check_server
ensure_directories
start_server

log "${GREEN}Production environment setup completed${NC}"
notify "✅ WhatsDesigns Production Server Ready - Access at https://whatsdesigns.com" 