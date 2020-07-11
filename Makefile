.PHONY: clean push all mrproper docker-pull install

ISO_DATE_TAG := $(shell date +%Y%m%d)

DEVIMAGE_SLUG := kingdonb/commits-to:dev-
RUNIMAGE_SLUG := kingdonb/commits-to:

all: .push-tag

install: .build
	kubectl apply -f k8s.yml

.build:
	okteto build -t $(DEVIMAGE_SLUG)$(ISO_DATE_TAG) . --target dev \
    && okteto build -t $(RUNIMAGE_SLUG)$(ISO_DATE_TAG) .
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
