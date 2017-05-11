
IMAGE_NAME = vboxton/alpine-sshdb

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .
