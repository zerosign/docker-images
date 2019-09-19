REGISTRY ?= docker.pkg.github.com
ORG      ?= zerosign
PROJECT  ?= docker-images/vault-operator
VERSION  ?= $(strip $(shell git show -q --format=%h))

all: build

build:
	docker build -f vault-operator/Dockerfile -t $(REGISTRY)/$(ORG)/repo/$(PROJECT):$(VERSION) vault-operator

release: build
	docker tag $(REGISTRY)/$(ORG)/repo/$(PROJECT):$(VERSION) $(REGISTRY)/$(ORG)/repo/$(PROJECT):latest
