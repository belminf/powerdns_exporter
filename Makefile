VERSION = $(shell git describe --always --tags --dirty)
pkgs    = $(shell go list ./... | grep -v /vendor/)

.PHONY: container test build version

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

version:
	@echo $(VERSION)

container: guard-IMAGE
	docker build -t $(IMAGE):$(VERSION) .
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest

test:
	go test -v ./...

build:
	go build -v ./...
	
archive:
	mkdir powerdns_exporter-$(VERSION).linux-amd64
	cp powerdns_exporter LICENSE README.md powerdns_exporter-$(VERSION).linux-amd64/
	tar cvzf powerdns_exporter-$(VERSION).linux-amd64.tar.gz powerdns_exporter-$(VERSION).linux-amd64

vet:
	go vet -v $(pkgs)