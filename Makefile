include help.mk

workdir=/usr/share/local/app
app_path=next-app

buildarg=--build-arg USER_ID=$(shell id -u) \
				 --build-arg GROUP_ID=$(shell id -g) \
				 --build-arg WORKDIR=$(workdir) \
				 --build-arg APP_PATH=$(app_path)

run=docker run \
	--network host \
	--rm \
	--user $(shell id -u) \

imagebase=node:12
devimage=next-dev-image:latest

.PHONY: init-project
init-project: ##@ Builds development image
	@if [ -d $(shell pwd)/$(app_path) ]; then \
		echo "Next App project exists"; \
	else \
		echo "Next App not exists, creating..."; \
		$(run) -v `pwd`:$(workdir) node:12 \
			npx create-next-app --typescript $(workdir)/$(app_path); \
	fi

.PHONY: build-dev
build-dev: ##@dev Build dev image
	docker build -t $(devimage) $(buildarg) --build-arg ENV=dev -f build/Dockerfile .

.PHONY: run-dev
run-dev: build-dev ##@dev Run development stack
	$(run) \
		-v `pwd`/$(app_path):$(workdir) \
		--name next-app-dev $(devimage) \
		npm run dev
