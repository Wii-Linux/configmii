#!/bin/bash

# secondary_mirror_installer.sh
# Automatically set up a secondary ArchPower mirror with a custom domain and port, syncing from the primary mirror
#
# don't run this on a wii, tysm.

set -e

# Variables
PRIMARY_MIRROR="rsync://arch.packages.wii-linux.org/archpower/"
LOCAL_MIRROR_DIR="/srv/archpower"  # Sync packages into /srv/archpower for ArchPower
SYNC_SCRIPT="/usr/local/bin/sync_secondary_mirror.sh"
NGINX_CONF="/etc/nginx/sites-available/custom_archpower"
DOMAIN=""
PORT=""
LOCATION_FILE="/srv/archpower/location.txt"
CRON_JOB="0 * * * * /usr/local/bin/sync_secondary_mirror.sh >> /var/log/secondary_mirror_sync.log 2>&1"

# Function to prompt for custom domain and port
get_custom_domain_and_port() {
    read -p "Enter your custom domain (e.g., thecheese.io): " DOMAIN
    read -p "Enter the port you want the mirror to run on (e.g., 8080): " PORT
}

# Check if the script is run as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: This script must be run as root. Exiting."
    exit 1
fi

# Install necessary packages
echo "Installing rsync, Nginx, and Certbot for Let's Encrypt..."
pacman -Sy --noconfirm rsync nginx certbot

# Prompt for custom domain and port
get_custom_domain_and_port

# Validate domain and port
if [[ -z "$DOMAIN" || -z "$PORT" ]]; then
    echo "Error: Domain and port cannot be empty."
    exit 1
fi

# Create mirror directory
echo "Creating mirror directory at $LOCAL_MIRROR_DIR..."
mkdir -p "$LOCAL_MIRROR_DIR"
chown nobody:nobody "$LOCAL_MIRROR_DIR"
chmod 755 "$LOCAL_MIRROR_DIR"

# Save location information
echo "Saving location information to $LOCATION_FILE..."
echo "Mirror Location: Custom Domain - $DOMAIN, Port - $PORT" > "$LOCATION_FILE"

# Create synchronization script
echo "Creating synchronization script..."
cat > "$SYNC_SCRIPT" <<EOF
#!/bin/bash

# sync_secondary_mirror.sh
# Script to sync the secondary mirror with the primary mirror

PRIMARY_MIRROR="$PRIMARY_MIRROR"
LOCAL_MIRROR_DIR="$LOCAL_MIRROR_DIR"

echo "\$(date '+%Y-%m-%d %H:%M:%S') - Starting synchronization with \$PRIMARY_MIRROR"

rsync -av --delete --delay-updates "\$PRIMARY_MIRROR" "\$LOCAL_MIRROR_DIR"

echo "\$(date '+%Y-%m-%d %H:%M:%S') - Synchronization completed."
EOF

chmod +x "$SYNC_SCRIPT"

# Set up cron job for regular synchronization
echo "Setting up cron job for synchronization..."
if ! crontab -l | grep -q "$SYNC_SCRIPT"; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added."
else
    echo "Cron job already exists. Skipping."
fi

# Validate primary mirror
echo "Validating primary mirror..."
if ! rsync --list-only "$PRIMARY_MIRROR" &>/dev/null; then
    echo "Error: Unable to connect to primary mirror at $PRIMARY_MIRROR"
    exit 1
fi
echo "Primary mirror is reachable."

# Set up Nginx to serve the mirror using the custom domain and port
echo "Configuring Nginx to serve the ArchPower mirror on $DOMAIN:$PORT..."
cat > "$NGINX_CONF" <<EOF
server {
    listen $PORT;
    server_name $DOMAIN;
    
    location / {
        root $LOCAL_MIRROR_DIR;
        autoindex on;
        autoindex_exact_size off;
        autoindex_format html;
        autoindex_localtime on;
    }
}
EOF

ln -s "$NGINX_CONF" /etc/nginx/sites-enabled/
systemctl restart nginx

# Set up HTTPS with Let's Encrypt for the custom domain
echo "Setting up HTTPS with Let's Encrypt for $DOMAIN..."
certbot --nginx -d "$DOMAIN" --agree-tos --redirect --non-interactive --email your-email@example.com

echo "Secondary mirror setup completed successfully for $DOMAIN on port $PORT."
echo "If u want ur repo in the repo choosing dm Selim at discord or join the Wii-Linux Discord"
