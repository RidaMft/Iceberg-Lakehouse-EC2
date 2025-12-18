#!/bin/bash
nohup abctl local install --disable-auth --insecure-cookies --low-resource-mode > /home/ec2-user/airbyte_install.log 2>&1 &
echo "Docker and Airbyte services started successfully."