#!/bin/bash

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    brew install certbot
fi

# Create SSL directory
mkdir -p /etc/letsencrypt/live/whatsdesigns.com

# Generate SSL certificate
echo "Generating SSL certificate..."
certbot certonly --standalone \
    -d whatsdesigns.com \
    -d www.whatsdesigns.com \
    --agree-tos \
    --email admin@whatsdesigns.com \
    --non-interactive

# Set proper permissions
chmod 755 /etc/letsencrypt/live
chmod 755 /etc/letsencrypt/archive
chmod 600 /etc/letsencrypt/live/whatsdesigns.com/privkey.pem
chmod 644 /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem

# Update hosts file
echo "Updating hosts file..."
echo "127.0.0.1 whatsdesigns.com www.whatsdesigns.com" >> /etc/hosts

# Restart the production server
echo "Restarting production server..."
launchctl unload ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist

echo "Domain setup complete!"
echo "Please ensure your DNS records are properly configured:"
echo "A Record: whatsdesigns.com -> Your server IP"
echo "A Record: www.whatsdesigns.com -> Your server IP" 