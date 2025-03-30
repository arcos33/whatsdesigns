#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log messages
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] $1" | tee -a "$LOG_DIR/prerequisites.log"
}

# Function to send notifications
notify() {
    if [ -f "$NOTIFY_SCRIPT" ]; then
        "$NOTIFY_SCRIPT" "Prerequisites Check" "$1"
    fi
}

# Function to check Homebrew
check_homebrew() {
    log "Checking Homebrew installation..."
    
    if ! command -v brew &> /dev/null; then
        log "${RED}Homebrew is not installed. Please install it first:${NC}"
        log "Visit https://brew.sh/ for installation instructions"
        notify "Homebrew is not installed"
        return 1
    fi
    
    log "${GREEN}Homebrew is installed${NC}"
    return 0
}

# Function to check Nginx
check_nginx() {
    log "Checking Nginx status..."
    
    # Check if Nginx is installed
    if ! command -v nginx &> /dev/null; then
        log "${RED}Nginx is not installed${NC}"
        notify "Nginx is not installed"
        return 1
    fi
    
    # Check if Nginx is running using ps instead of brew services
    if ! ps aux | grep -v grep | grep -q "nginx: master"; then
        log "${YELLOW}Nginx is not running. Starting Nginx...${NC}"
        # Try starting with sudo
        if sudo nginx; then
            log "${GREEN}Nginx started successfully${NC}"
            sleep 2
        else
            log "${RED}Failed to start Nginx. Please start it manually with: sudo nginx${NC}"
            notify "Failed to start Nginx"
            return 1
        fi
    else
        log "${GREEN}Nginx is running${NC}"
    fi
    
    # Test Nginx configuration
    if ! sudo nginx -t &> /dev/null; then
        log "${RED}Nginx configuration test failed${NC}"
        notify "Nginx configuration test failed"
        return 1
    fi
    
    # Verify Nginx is listening on required ports
    if ! sudo lsof -i :80 | grep -q "nginx"; then
        log "${YELLOW}Nginx not listening on port 80${NC}"
        if sudo nginx -s reload; then
            log "${GREEN}Nginx configuration reloaded${NC}"
        else
            log "${RED}Failed to reload Nginx${NC}"
            return 1
        fi
    fi
    
    log "${GREEN}Nginx is running and configured correctly${NC}"
    return 0
}

# Function to check SSL certificates
check_ssl() {
    log "Checking SSL certificates..."
    
    # Skip SSL check in development
    if [ "$NODE_ENV" = "development" ]; then
        log "${GREEN}Skipping SSL check in development environment${NC}"
        return 0
    fi
    
    # Check production certificate
    local prod_cert="/etc/letsencrypt/live/whatsdesigns.com/fullchain.pem"
    if [ ! -f "$prod_cert" ]; then
        log "${RED}Production SSL certificate not found. Please run: sudo ./scripts/setup-domain.sh${NC}"
        notify "Production SSL certificate not found"
        return 1
    fi
    
    # Check certificate expiration
    local expiry=$(openssl x509 -enddate -noout -in "$prod_cert" | cut -d= -f2)
    local expiry_epoch=$(date -j -f "%b %d %H:%M:%S %Y %Z" "$expiry" "+%s")
    local now=$(date "+%s")
    local days_left=$(( ($expiry_epoch - $now) / 86400 ))
    
    if [ $days_left -lt 30 ]; then
        log "${YELLOW}SSL certificate expires in $days_left days${NC}"
        notify "SSL certificate expires in $days_left days"
    fi
    
    log "${GREEN}SSL certificates are valid${NC}"
    return 0
}

# Function to check MongoDB
check_mongodb() {
    log "Checking MongoDB status..."
    
    # Check if MongoDB is installed
    if ! command -v mongod &> /dev/null; then
        log "${RED}MongoDB is not installed${NC}"
        notify "MongoDB is not installed"
        return 1
    fi
    
    # Check if MongoDB is running using ps instead of brew services
    if ! ps aux | grep -v grep | grep -q "mongod"; then
        log "${YELLOW}MongoDB is not running. Starting MongoDB...${NC}"
        mongod --dbpath /usr/local/var/mongodb --logpath /usr/local/var/log/mongodb/mongo.log --fork
        sleep 2
    fi
    
    # Test MongoDB connection
    if ! mongosh --eval "db.runCommand({ping: 1})" &> /dev/null; then
        log "${RED}MongoDB connection test failed${NC}"
        notify "MongoDB connection test failed"
        return 1
    fi
    
    log "${GREEN}MongoDB is running and accessible${NC}"
    return 0
}

# Function to check environment variables
check_env() {
    log "Checking environment variables..."
    
    # Check environment file based on NODE_ENV
    local env_file="$APP_DIR/config/.env.development"
    if [ "$NODE_ENV" = "production" ]; then
        env_file="$APP_DIR/config/.env.production"
    fi
    
    if [ ! -f "$env_file" ]; then
        log "${RED}Environment file not found: $env_file${NC}"
        notify "Environment file not found: $env_file"
        return 1
    fi
    
    # Check required variables
    local required_vars=(
        "NODE_ENV"
        "NEXTAUTH_URL"
        "NEXTAUTH_SECRET"
        "MONGODB_URI"
        "OPENAI_API_KEY"
    )
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "^$var=" "$env_file"; then
            log "${RED}Required variable $var is missing in $env_file${NC}"
            notify "Required variable $var is missing"
            return 1
        fi
    done
    
    log "${GREEN}Environment variables are properly configured${NC}"
    return 0
}

# Function to check and create required directories
check_directories() {
    log "Checking required directories..."
    
    # Create logs directory if it doesn't exist
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
        chmod 755 "$LOG_DIR"
        log "Created logs directory"
    fi
    
    # Create .next directory if it doesn't exist
    if [ ! -d "$APP_DIR/.next/server/app" ]; then
        mkdir -p "$APP_DIR/.next/server/app"
        chmod -R 755 "$APP_DIR/.next"
        log "Created Next.js build directories"
    fi
    
    # Create config directory if it doesn't exist
    if [ ! -d "$APP_DIR/config" ]; then
        mkdir -p "$APP_DIR/config"
        chmod 755 "$APP_DIR/config"
        log "Created config directory"
    fi
    
    log "${GREEN}All required directories exist${NC}"
    return 0
}

# Function to check build
check_build() {
    log "Checking application build..."
    
    # Check if build exists
    if [ ! -d "$APP_DIR/.next" ]; then
        log "${YELLOW}No build found. Building application...${NC}"
        cd "$APP_DIR"
        
        # Use appropriate build command based on environment
        if [ "$NODE_ENV" = "production" ]; then
            npm run build:prod
        else
            npm run build
        fi
        
        if [ $? -ne 0 ]; then
            log "${RED}Build failed${NC}"
            notify "Application build failed"
            return 1
        fi
    fi
    
    log "${GREEN}Application build is ready${NC}"
    return 0
}

# Main execution
log "Starting prerequisites check..."

# Check Homebrew first
if ! check_homebrew; then
    log "${RED}Prerequisites check failed. Please install Homebrew and try again.${NC}"
    exit 1
fi

# Check Nginx
if ! check_nginx; then
    log "${RED}Prerequisites check failed. Please fix Nginx issues and try again.${NC}"
    exit 1
fi

# Set default environment if not set
if [ -z "$NODE_ENV" ]; then
    NODE_ENV="development"
    log "${YELLOW}NODE_ENV not set, defaulting to development${NC}"
fi

# Run all checks
check_directories
check_ssl
check_mongodb
check_env
check_build

log "${GREEN}All prerequisites are met${NC}"
exit 0 