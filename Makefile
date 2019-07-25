IMAGE = $(DOCKER_REGISTRY)/$(USERNAME)/$(NAMESPACE)/hadoop-standalone
VERSION = $(HADOOP_VERSION)

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest \
		--build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
		--build-arg HADOOP_MIRROR=$(HADOOP_MIRROR) \
		--build-arg HADOOP_HOME=$(HADOOP_HOME) \
		--build-arg JAVA_VERSION=$(JAVA_VERSION) \
		--build-arg HADOOP_USER=$(HADOOP_USER) .

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest
