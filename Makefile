web:
	open "http://$(shell terraform output | grep jenkins | grep ec2 | cut -d\" -f2)"
ssh:
	ssh -i ./keys/jenkins-server.key ubuntu@$(shell terraform output | grep jenkins | grep ec2 | cut -d\" -f2)
