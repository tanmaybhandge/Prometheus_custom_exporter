#!/bin/bash
sudo yum update -y

# Update system and install required packages
sudo yum install git -y
sudo yum install wget -y
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Install Python 3 and required dependencies
sudo yum install python3 python3-pip python3-devel gcc openssl-devel libffi-devel python3-setuptools -y

# Install Flask and virtual environment
pip3 install flask
sudo yum install python-virtualenv -y

# Configure NGINX repository and install NGINX
sudo tee /etc/yum.repos.d/nginx.repo <<EOL
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOL

sudo yum install nginx -y

sudo systemctl start nginx
sudo systemctl enable nginx

# Create and configure Flask application directory
sudo mkdir -p /opt/flask_app
sudo chown -R root:nginx /opt/flask_app
sudo chmod -R 775 /opt/flask_app
cd /opt/flask_app

# Create a virtual environment
python3 -m venv venv
source venv/bin/activate

# Upgrade pip and install required Python packages
pip install --upgrade pip
pip install wheel
pip install gunicorn flask
pip3 install prometheus_client requests

# Deactivate virtual environment
deactivate

# Download Flask application files from Git
sudo wget -O /opt/flask_app/flaskapp.py https://raw.githubusercontent.com/tanmaybhandge/Prometheus_custom_exporter/main/flaskapp.py

# Create a systemd service file for Flask app
sudo tee /etc/systemd/system/flask_app.service <<EOL
[Unit]
Description=Flask App Service
After=network.target

[Service]
Group=nginx
WorkingDirectory=/opt/flask_app
ExecStart=/usr/bin/python3 /opt/flask_app/flaskapp.py
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Start and enable Flask app service
sudo systemctl enable flask_app
sudo systemctl start flask_app

# Check Flask app service status
sudo systemctl status flask_app
exit 0
