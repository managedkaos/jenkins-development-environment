#!/bin/bash
target="$(/usr/local/bin/aws --profile jenkins ec2 describe-instances --query 'Reservations[].Instances[][].{Instances: InstanceId}' --output text --filters "Name=tag:Name,Values=windows-server" "Name=instance-state-name,Values=running" --output=text)"

/usr/local/bin/aws --profile jenkins ec2 get-password-data --instance-id="${target}" --priv-launch-key=./keys/windows.pem --output=text
