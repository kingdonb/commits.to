.PHONY: build tag-latest push-tag push-latest push

ISO_DATE_TAG := $(shell date +%Y%m%d)

all: build push

build:
	docker build -t kingdonb/commits-to:dev-$(ISO_DATE_TAG) . --target dev \
    && docker build -t kingdonb/commits-to:$(ISO_DATE_TAG) .

tag-latest: build
	docker tag kingdonb/commits-to:dev-$(ISO_DATE_TAG) kingdonb/commits-to:dev
	docker tag kingdonb/commits-to:$(ISO_DATE_TAG) kingdonb/commits-to:latest

push-tag: build
	docker push kingdonb/commits-to:dev-$(ISO_DATE_TAG)
	docker push kingdonb/commits-to:$(ISO_DATE_TAG)

push-latest: tag-latest
	docker push kingdonb/commits-to:dev
	docker push kingdonb/commits-to:latest

push: push-tag push-latest
