SHELL=/bin/bash

install:
	pip install localstack
	docker kill $(docker ps --filter name=localstack --quiet) || true
	localstack start --docker -d
	export AWS_ACCESS_KEY_ID=accesskeytest
	export AWS_SECRET_ACCESS_KEY=secretkeytest
	export AWS_DEFAULT_REGION=us-east-1
	export AWS_ENDPOINT=http://localhost:4566
	cd src &&	terraform init
	cd src && terraform apply -auto-approve