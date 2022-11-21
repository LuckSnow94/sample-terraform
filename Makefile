SHELL=/bin/bash

install:
	pip install localstack

deploy:
	docker kill $(docker ps --filter name=localstack --quiet) || true
	localstack start --docker -d
	export AWS_ENDPOINT=http://localhost:4566