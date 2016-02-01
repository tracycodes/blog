BRANCH = $(shell git rev-parse --symbolic-full-name --abbrev-ref HEAD | sed -e 's/[^A-Za-z0-9_.-]/-/g')
GITHASH = $(shell git rev-parse --short HEAD)
PROJECT = blog
IMAGE = $(USER)/$(PROJECT)
RELEASE = $(PROJECT)-$(BRANCH)-$(GITHASH)
BLOG_POST_LOCATION = ~/Dropbox/Notes/blog
HUGO_THEME ?= casper
FORWARDED_PORT ?= 0.0.0.0:1313:1313


docker-build:
	docker build --tag=$(IMAGE) .

shell: docker-build
	docker run --rm -it -p $(FORWARDED_PORT) -v $(shell pwd):/opt/$(PROJECT) $(IMAGE) /bin/bash

update_posts: docker-build
	./generate.sh $(BLOG_POST_LOCATION) $(shell pwd)/hugo

server: update_posts
	echo "Starting hugo server. Connect at `docker-machine ip dev`"
	docker run --rm -it -p $(FORWARDED_PORT) -v $(shell pwd):/opt/$(PROJECT) -e PROJECT=$(PROJECT) $(IMAGE) /bin/bash start.sh

build: docker-build

# push to google cloud storage with version tag and creds
# push: build

.PHONY: docker-build shell server new-post build push
