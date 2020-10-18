.PHONY: clean push all mrproper docker-pull install

ISO_DATE_TAG := $(shell date +%Y%m%d)
IMAGE_TAG := $(shell ./image-tag.sh)

DEVIMAGE_SLUG := okteto.dev/commitsto:dev-
RUNIMAGE_SLUG := okteto.dev/commitsto:
IMAGE := $(RUNIMAGE_SLUG)$(IMAGE_TAG)

all: .push-tag

install: .build
	kubectl apply -f k8s.yml

quay:
	docker build -t $(IMAGE) . && docker push $(IMAGE)

.build:
	okteto build -t $(DEVIMAGE_SLUG)$(ISO_DATE_TAG) . --target dev \
    && okteto build -t $(IMAGE) .
	touch .build

docker-pull:
	docker pull $(DEVIMAGE_SLUG)$(ISO_DATE_TAG)
	docker pull $(RUNIMAGE_SLUG)$(ISO_DATE_TAG)

# build:
# 	docker build -t kingdonb/commits-to:dev-$(ISO_DATE_TAG) . --target dev \
#     && docker build -t kingdonb/commits-to:$(ISO_DATE_TAG) .

.tag-latest: .build
	docker tag $(DEVIMAGE_SLUG)$(ISO_DATE_TAG) $(RUNIMAGE_SLUG)dev
	docker tag $(RUNIMAGE_SLUG)$(ISO_DATE_TAG) $(RUNIMAGE_SLUG)latest
	touch .tag-latest

.push-tag: .build
	docker push $(DEVIMAGE_SLUG)$(ISO_DATE_TAG)
	docker push $(RUNIMAGE_SLUG)$(ISO_DATE_TAG)
	touch .push-tag

.push-latest: .tag-latest
	docker push $(RUNIMAGE_SLUG)dev
	docker push $(RUNIMAGE_SLUG)latest
	touch .push-latest

clean:
	rm -f .build

mrproper: clean
	rm .tag-latest .push-tag .push-latest

push: .push-tag .push-latest
