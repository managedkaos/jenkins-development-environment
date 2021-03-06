web: adminpassword
	open "http://$(shell terraform output | grep jenkins_public_dns | cut -d\" -f2)"

ssh:
	ssh -i ./keys/ubuntu.pem ubuntu@$(shell terraform output | grep jenkins_public_dns | cut -d\" -f2)

adminpassword:
	ssh -i ./keys/ubuntu.pem ubuntu@$(shell terraform output | grep jenkins_public_dns | cut -d\" -f2) \
		sudo cat /root/initialAdminPassword | pbcopy

buildserver:
	ssh -i ./keys/amazon.pem ec2-user@$(shell terraform output | grep build_public_dns | cut -d\" -f2)

up: start

down: stop

stop start password:
	./scripts/$(@).sh

tf apply:
	terraform apply -auto-approve

output:
	terraform output
