SHELL=/bin/bash

install:
	# Installing localstack...
	pip install localstack

	# Starting docker container...
	localstack start --docker -d
	export AWS_ACCESS_KEY_ID=accesskeytest
	export AWS_SECRET_ACCESS_KEY=secretkeytest
	export AWS_DEFAULT_REGION=us-east-1
	export AWS_ENDPOINT=http://localhost:4566
	
	# Provising and applying terraform resources...
	cd src &&	terraform init
	cd src && terraform apply -auto-approve