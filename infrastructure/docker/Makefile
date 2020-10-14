# base version target
base_version := 0.1

# Use a hash of the Dockerfile for the tag, so when the Dockerfile changes,
# it automatically rebuilds
build_version := $(shell sha256sum Dockerfile | head -c 10)

# version
VERSION ?= $(base_version)-$(build_version)

# proxy config
PROXY ?= ${HTTP_PROXY}

# Alastria node start type and node name
TYPE ?= 
NAME ?= 
# Network ports
CONSTELLATION_PORT ?= 9000:9000
GETH_PORT_TCP ?= 21000-21010:21000-21010/tcp
GETH_PORT_UDP ?= 21000-21010:21000-21010/udp
RPC_PORT ?= 22000-22010:22000-22010
ETHSTATS_PORT ?=3000:3000
#    ___  ____    ___            _           _
#   / _ \/ ___|  |_ _|_ __   ___| |_   _  __| | ___
#  | | | \___ \   | || '_ \ / __| | | | |/ _` |/ _ \
#  | |_| |___) |  | || | | | (__| | |_| | (_| |  __/
#   \___/|____/  |___|_| |_|\___|_|\__,_|\__,_|\___|
#

# At this moment we only support linux OS
osinclude := linux.mk
include ./includes/$(osinclude)

#   _____                    _
#  |_   _|_ _ _ __ __ _  ___| |_ ___
#    | |/ _` | '__/ _` |/ _ \ __/ __|
#    | | (_| | | | (_| |  __/ |_\__ \
#    |_|\__,_|_|  \__, |\___|\__|___/
#                 |___/

build: build-base-image build-alastria

build-base-image:
	docker build --build-arg http_proxy=$(PROXY) -t alastria-base -f Dockerfile.base .

build-alastria:
	docker build --build-arg http_proxy=$(PROXY) -t alastria-node:$(VERSION) .

node-shell: build
	docker run -it alastria-node:$(VERSION) bash -l

install-test-complete:
	docker run  -p $(CONSTELLATION_PORT) -p $(GETH_PORT_TCP) -p $(GETH_PORT_UDP) -p $(RPC_PORT) \
	--name $(NAME) -d alastria-node:$(VERSION) bash -c "./start.sh $(TYPE)"

install-test-basic:
	docker run --name $(NAME) -d alastria-node:$(VERSION) bash -c "./start.sh $(TYPE)"

complete:
	docker run -p $(CONSTELLATION_PORT) -p $(GETH_PORT_TCP) -p $(GETH_PORT_UDP) -p $(RPC_PORT) -p $(ETHSTATS_PORT) \
        -it -d alastria-node:$(VERSION) bash -c "/opt/test-environment/infrastructure/testnet/bin/start_network.sh clean 2 3 && tail -f /dev/null"
clean:
	docker images -a | grep "alastria" | awk '{print $$3}' | xargs docker rmi -f

stop:
	docker ps -a | grep "alastria" | awk '{print $$1}' | xargs -I % sh -c 'docker stop %; docker rm %;'
	
