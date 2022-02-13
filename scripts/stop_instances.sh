#!/bin/bash
echo "# Getting targets..."
targets="$(aws ec2 describe-instances --query 'Reservations[].Instances[][].{Instances: InstanceId}' --output text --filters "Name=tag:Designation,Values=jenkins-development-environment-production" --output=text)"

echo "# Stopping targets..."
aws ec2 stop-instances --instance-ids ${targets}

echo "# Waiting for targets to stop..."
aws ec2 wait instance-stopped --instance-ids ${targets}

echo "# Stop complete!"
