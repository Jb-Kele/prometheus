#!/bin/bash
#-------------------------------------------------------------------------------
#--------- Script to Install Prometheus Node_Exporter on Linux Ubuntu-----------
#
#------------------------- Developed by JB in 2025 -----------------------------

NODE_EXPORTER_VERSION="1.9.1"                                                    #You can change for last NODE_EXPORTER_VERSION

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
tar xvfz node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
cd node_exporter-$NODE_EXPORTER_VERSION.linux-amd64

mv node_exporter /usr/bin/
rm -rf /tmp/node_exporter*

useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/bin/node_exporter

cat <<EOF> /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node_Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
systemctl status node_exporter
node_exporter --version
