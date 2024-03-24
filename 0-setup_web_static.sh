#!/usr/bin/env bash
set -e

# Install nginx if not already installed
if ! command -v nginx &> /dev/null
then
    sudo apt-get -y update
    sudo apt-get -y install nginx
	sudo ufw allow 'Nginx HTTP'

fi

# Create necessary folders if they don't exist
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file for testing
sudo bash -c 'echo "<html>
    <head>
	</head>
	<body>
	    Holberton School
	</body>
</html>" > /data/web_static/releases/test/index.html'

# Create or recreate the symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership of /data/ folder recursively to ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
sudo sed -i '/server_name _;/a \\n\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' $config_file

# Restart Nginx
sudo service nginx restart

exit 0
