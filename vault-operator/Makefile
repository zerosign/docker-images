REGISTRY   ?= docker.pkg.github.com
ORG        ?= zerosign
PROJECT    ?= docker-images
SUBPROJECT ?= vault-operator
VERSION    ?= $(strip $(shell git show -q --format=%h))

all: build

build:
	docker build -f vault-operator/Dockerfile -t $(REGISTRY)/$(ORG)/$(PROJECT)/$(SUBPROJECT):$(VERSION) -t $(ORG)/$(PROJECT)  vault-operator

tag: build
	docker tag $(REGISTRY)/$(ORG)/repo/$(PROJECT)/$(SUBPROJECT):$(VERSION) $(REGISTRY)/$(ORG)/$(SUBPROJECT):latest
	docker tag $(REGISTRY)/$(ORG)/repo/$(PROJECT)/$(SUBPROJECT):$(VERSION) $(ORG)/$(SUBPROJECT):latest

release: tag
	docker push $(ORG)/$(SUBPROJECT):latest
