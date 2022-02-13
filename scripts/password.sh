#!/bin/bash
target="$(aws ec2 describe-instances --query 'Reservations[].Instances[][].{Instances: InstanceId}' --output text --filters "Name=tag:Name,Values=windows-server" "Name=instance-state-name,Values=running" --output=text)"

aws ec2 get-password-data --instance-id="${target}" --priv-launch-key=~/.ssh/windows-server.pem --output=text
