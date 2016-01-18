BRANCH = $(shell git rev-parse --symbolic-full-name --abbrev-ref HEAD | sed -e 's/[^A-Za-z0-9_.-]/-/g')
GITHASH = $(shell git rev-parse --short HEAD)
PROJECT = blog
IMAGE = $(USER)/$(PROJECT)
RELEASE = $(PROJECT)-$(BRANCH)-$(GITHASH)
BLOG_POST_NAME ?= journal-post-$(date +%m-%d-%y@%H:%M).md
HUGO_THEME ?= blog-theme


docker-build:
	docker build --tag=$(IMAGE) .

shell: docker-build
	docker run --rm -it -v $(shell pwd):/opt/$(PROJECT) $(IMAGE) /bin/bash

server: docker-build
	docker run --rm -it -v $(shell pwd):/opt/$(PROJECT) -e PROJECT=$(PROJECT) $(IMAGE) /bin/bash start.sh

new-post: docker-build
	docker run --rm -it -v $(shell pwd):/opt/$(PROJECT) $(IMAGE) /bin/bash -c ' \
	hugo new --theme $(HUGO_THEME) post/$(BLOG_POST_NAME)'

build: docker-build

# push to google cloud storage with version tag and creds
# push: build

.PHONY: docker-build shell server new-post build push

