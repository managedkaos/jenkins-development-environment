web:
	open "http://$(shell terraform output | grep jenkins | grep ec2 | cut -d\" -f2)"
ssh:
	ssh -i ./keys/amazon.pem ubuntu@$(shell terraform output | grep jenkins_public_dns | cut -d\" -f2)

stop start password:
	./scripts/$(@).sh

apply:
	terraform apply -auto-approve

