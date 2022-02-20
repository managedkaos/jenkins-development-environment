#!/bin/bash
echo "# Getting targets..."
targets="$(/usr/local/bin/aws ec2 describe-instances --query 'Reservations[].Instances[][].{Instances: InstanceId}' --output text --filters "Name=tag:Designation,Values=jenkins-development-environment-production" --output=text)"

echo "# $(date) Stopping targets..."
/usr/local/bin/aws ec2 stop-instances --instance-ids ${targets}

echo "# $(date) Waiting for targets to stop..."
/usr/local/bin/aws ec2 wait instance-stopped --instance-ids ${targets}

echo "# $(date) Stop complete!"
