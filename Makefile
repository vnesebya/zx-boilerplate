BUILD_FOLDER := build

ifeq ($(PROJECT_NAME),)
	PROJECT_NAME := $(shell basename "`pwd`")
endif

ifeq ($(EMULATOR_BINARY),)
	EMULATOR_BINARY := unreal
endif

ifeq ($(COPY_SNAPSHOT_TO),)
	COPY_SNAPSHOT_TO := /tmp/quicksave.sna
endif

.PHONY: all clean build run copy

all: build

build: ## Default: build project
	@printf "\033[32mBuilding '$(PROJECT_NAME)'\033[0m\n"
	@printf "\033[32mEMULATOR_BINARY '$(EMULATOR_BINARY)'\033[0m\n"
	@printf "\033[32mCOPY_SNAPSHOT_TO '$(COPY_SNAPSHOT_TO)'\033[0m\n"


	mkdir -p $(BUILD_FOLDER)
	rm -f $(BUILD_FOLDER)/*

	sjasmplus --fullpath --lst=$(BUILD_FOLDER)/.list \
		--sld=$(BUILD_FOLDER)/$(PROJECT_NAME).sld --inc=. \
		-DSNA_FILENAME=\"$(BUILD_FOLDER)/$(PROJECT_NAME).sna\" \
		-DBIN_FILENAME=\"$(BUILD_FOLDER)/$(PROJECT_NAME).bin\" \
		-DTAP_FILENAME=\"$(BUILD_FOLDER)/$(PROJECT_NAME).tap\" \
		-DTRD_FILENAME=\"$(BUILD_FOLDER)/$(PROJECT_NAME).trd\" \
		src/main.asm

run: build ## Build and run snapshot in emulator
	$(EMULATOR_BINARY) $(BUILD_FOLDER)/$(PROJECT_NAME).sna

copy: build ## Build and copy snapshot to given path
	cp --force $(BUILD_FOLDER)/$(PROJECT_NAME).sna $(COPY_SNAPSHOT_TO)
	@printf "\033[32mdone\033[0m\n"

clean: ## Remove artifacts
	rm -rfd $(BUILD_FOLDER)

help: 	## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' 