# Disable all the default make stuff
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

## Display a list of the documented make targets
.PHONY: help
help:
	@echo Documented Make targets:
	@perl -e 'undef $$/; while (<>) { while ($$_ =~ /## (.*?)(?:\n# .*)*\n.PHONY:\s+(\S+).*/mg) { printf "\033[36m%-30s\033[0m %s\n", $$2, $$1 } }' $(MAKEFILE_LIST) | sort

.PHONY: .FORCE
.FORCE:

.score-compose/state.yaml:
	score-compose init \
    	--no-sample \
    	--patch-templates https://raw.githubusercontent.com/score-spec/community-patchers/refs/heads/main/score-compose/microcks.tpl \
    	--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/endpoint/score-compose/10-endpoint-with-microcks.provisioners.yaml

compose.yaml: score-frontend.yaml score-backend.yaml .score-compose/state.yaml Makefile
	score-compose generate score-frontend.yaml
# score-compose generate score-backend.yaml

## Generate a compose.yaml file from the score spec and launch it.
.PHONY: compose-up
compose-up: compose.yaml
	docker compose up -d --wait --remove-orphans

## Delete the containers running via compose down.
.PHONY: compose-down
compose-down:
	docker compose down -v --remove-orphans || true

.score-k8s/state.yaml:
	score-k8s init \
    	--no-sample \
    	--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/endpoint/score-k8s/10-endpoint-with-microcks-cli.provisioners.yaml

manifests.yaml: score-frontend.yaml score-backend.yaml .score-k8s/state.yaml Makefile
	score-k8s generate score-frontend.yaml
# score-compose generate score-backend.yaml

## Create a local Kind cluster.
.PHONY: kind-create-cluster
kind-create-cluster:
	./scripts/setup-kind-cluster.sh

NAMESPACE ?= default
## Generate a manifests.yaml file from the score spec, deploy it to Kubernetes and wait for the Pods to be Ready.
.PHONY: k8s-up
k8s-up: manifests.yaml
	kubectl apply -f manifests.yaml -n ${NAMESPACE}

## Delete the deployment of the local container in Kubernetes.
.PHONY: k8s-down
k8s-down:
	kubectl delete -f manifests.yaml -n ${NAMESPACE}