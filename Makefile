TAG_NAME = eu.gcr.io/itg-mimercadona/
VERSION ?= v0.17.0
PROJECT ?= stolon-proxy-read-replica
PGVERSION ?= 13

PROJDIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# change to project dir so we can express all as relative paths
$(shell cd $(PROJDIR))

REPO_PATH=github.com/sorintlab/stolon

VERSION ?= $(shell scripts/git-version.sh)

LD_FLAGS="-w -X $(REPO_PATH)/cmd.Version=$(VERSION)"

$(shell mkdir -p bin )


.PHONY: all
all: build-linux

.PHONY: build-linux
build-linux: sentinel-linux keeper-linux proxy-linux stolonctl-linux

.PHONY: test
test: build
	./test

.PHONY: sentinel-linux keeper-linux proxy-linux stolonctl-linux docker

keeper-linux:
	GO111MODULE=on go build -ldflags $(LD_FLAGS) -o $(PROJDIR)/bin/stolon-keeper $(REPO_PATH)/cmd/keeper

sentinel-linux:
	CGO_ENABLED=0 GO111MODULE=on go build -ldflags $(LD_FLAGS) -o $(PROJDIR)/bin/stolon-sentinel $(REPO_PATH)/cmd/sentinel

proxy-linux:
	CGO_ENABLED=0 GO111MODULE=on go build -ldflags $(LD_FLAGS) -o $(PROJDIR)/bin/stolon-proxy $(REPO_PATH)/cmd/proxy

stolonctl-linux:
	CGO_ENABLED=0 GO111MODULE=on go build -ldflags $(LD_FLAGS) -o $(PROJDIR)/bin/stolonctl $(REPO_PATH)/cmd/stolonctl

.PHONY: build

build:
	docker build --build-arg PGVERSION=${PGVERSION} -t $(TAG_NAME)$(PROJECT):$(VERSION) -f examples/kubernetes/image/docker/Dockerfile .

push:
	docker push $(TAG_NAME)$(PROJECT):$(VERSION)

authorize:
	gcloud docker --authorize-only
