#!/bin/bash
echo "# Getting targets..."
targets="$(aws ec2 describe-instances --query 'Reservations[].Instances[][].{Instances: InstanceId}' --output text --filters "Name=tag:Designation,Values=jenkins-development-environment-production" --output=text)"

echo "# $(date) Starting targets..."
aws ec2 start-instances --instance-ids ${targets}

echo "# $(date) Waiting for targets to start..."
aws ec2 wait instance-running --instance-ids ${targets}

echo "# $(date) Waiting for target status to be OK..."
aws ec2 wait instance-status-ok --instance-ids ${targets}

echo "# $(date) Start complete!"
