#!/bin/bash
echo "# Getting targets..."
targets="$(/usr/local/bin/aws --profile jenkins ec2 describe-instances --query 'Reservations[].Instances[][].{Instances: InstanceId}' --output text --filters "Name=tag:Designation,Values=jenkins-development-environment-production" --output=text)"

if [ "$?" -ne 0 ] || [ -z ${targets} ]; then
    echo "Target selection failed."
    exit 1
fi

echo "# $(date) Starting targets..."
/usr/local/bin/aws --profile jenkins ec2 start-instances --instance-ids ${targets}

echo "# $(date) Waiting for targets to start..."
/usr/local/bin/aws --profile jenkins ec2 wait instance-running --instance-ids ${targets}

echo "# $(date) Waiting for target status to be OK..."
/usr/local/bin/aws --profile jenkins ec2 wait instance-status-ok --instance-ids ${targets}

echo "# $(date) Start complete!"
