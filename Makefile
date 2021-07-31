include help.mk

app_name=next-app
dev_image=next-dev-image:latest
prod_image=next-prod-image:latest
workdir=$(app_name)

buildarg=--build-arg WORKDIR=$(workdir)

run_app=docker run -d --rm \
	--user $(shell id -u) \
	-v `pwd`/next-app:/$(workdir) \
	--name $(app_name) $(dev_image) \

.PHONY: init-project
init-project: ##@ Builds development image
	@if [ -d $(shell pwd)/next-app ]; then \
		echo "Next App project exists"; \
	else \
		echo "Next App not exists, creating..."; \
		$(run) -v `pwd`:$(workdir) node:alpine \
			yarn create next-app --typescript $(workdir)/$(app_name); \
	fi

.PHONY: build-dev-image
build-dev-image: ##@dev Build dev image
	docker build -t $(dev_image) $(buildarg) -f build/dev/Dockerfile .

.PHONY: run-dev
run-dev: build-dev-image ##@dev Run development stack
	$(run_app) \
		yarn run dev; \
		docker logs $(app_name) -f

.PHONY: stop-dev
stop-dev: ##@dev Stop dev process
	docker rm -f $(app_name)

.PHONY: build-app
build-app: ##@build Build app
	docker build -t $(prod_image) -f build/prod/Dockerfile $(app_name)
