PACKAGE  = terraform-opsgenie-incident-management
GOEXE   ?= /usr/bin/go
GOPATH   = $(CURDIR)/.gopath
GOBIN    = $(GOPATH)/bin
BASE     = $(GOPATH)/src/$(PACKAGE)
PATH 	  := $(PATH):$(GOBIN)
TF_VAR_opsgenie_provider_api_key ?= ${TF_VAR_opsgenie_provider_api_key}

export TF_DATA_DIR ?= $(CURDIR)/.terraform
export TF_CLI_ARGS_init ?= -get-plugins=true
export GOPATH

.PHONY: all
## Default target
all: test

ifneq (,$(wildcard /sbin/apk))
## Install go, if not installed
$(GOEXE):
	apk add --update go
endif

ifneq ($(findstring $(shell uname -s),Linux Darwin),)
## Install all `dep`, if not installed
$(GOBIN)/dep:
	@mkdir -p $(GOBIN)
	@curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
endif

## Prepare the GOPATH
$(BASE): $(GOEXE)
	@mkdir -p $(dir $@)
	@ln -sf $(CURDIR) $@

## Download vendor dependencies to vendor/
$(BASE)/vendor: $(BASE) $(GOBIN)/dep
	cd $(BASE) && dep ensure

.PHONY : init
## Initialize tests
init: $(BASE)/vendor

.PHONY : test
## Run tests
test: init
	cd $(BASE) && go test -v -timeout 5m -run TestExamplesAlertPolicy
	cd $(BASE) && go test -v -timeout 5m -run TestExamplesApiIntegration
	cd $(BASE) && go test -v -timeout 5m -run TestExamplesEscalation
	cd $(BASE) && go test -v -timeout 5m -run TestExamplesNotificationPolicy
	cd $(BASE) && go test -v -timeout 5m -run TestExamplesTeam
	cd $(BASE) && go test -v -timeout 5m -run TestExamplesTeamRoutingRule
	cd $(BASE) && go test -v -timeout 10m -run TestExamplesComplete

.PHONY : clean
## Clean up files
clean:
	rm -rf .gopath/ vendor/ $(TF_DATA_DIR)
