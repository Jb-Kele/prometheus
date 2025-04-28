#!/bin/bash
#-------------------------------------------------------------------------------
#------------ Script to Install Prometheus Monitor on Linux Ubuntu--------------
#
#------------------------- Developed by JB in 2025 -----------------------------

PROMETHEUS_VERSION="3.3.0"                                                       #You can change for last PROMETHEUS_VERSION
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"                                       #You can choose your folder
PROMETHEUS_FOLDER_TSDATA="/etc/prometheus/data"                                  #You can choose your folder

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
tar xvfz prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
cd prometheus-$PROMETHEUS_VERSION.linux-amd64

mkdir -p $PROMETHEUS_FOLDER_CONFIG
mkdir -p $PROMETHEUS_FOLDER_TSDATA

mv prometheus /usr/bin/
mv prometheus.yml $PROMETHEUS_FOLDER_CONFIG
rm -rf /tmp/prometheus*

useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown -R prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG

cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
  --config.file    /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /etc/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus --no-pager
prometheus --version
