# ANSI color codes
RESET  := \\033[0m
BOLD   := \\033[1m
RED    := \\033[31m
GREEN  := \\033[32m
YELLOW := \\033[33m

# Colored prefix
OK_STRING := $(GREEN)[OK]$(RESET)
ERROR_STRING := $(RED)[ERROR]$(RESET)
WARN_STRING := $(YELLOW)[WARNING]$(RESET)

# Global variables
HELP_TARGET_MAX_LENGTH=24
DEPENDENCIES_PATH := dependencies

# Ansible variables
ANSIBLE_GALAXY_REQUIREMENTS := requirements.yml
ANSIBLE_DEPENDENCIES_ROLES_PATH := $(DEPENDENCIES_PATH)/roles
ifeq ($(strip $(ANSIBLE_PLAYBOOKS_PATH)),)
ANSIBLE_PLAYBOOKS_PATH := playbooks
endif
ifeq ($(strip $(ANSIBLE_USER)),)
ANSIBLE_USER := ansible
endif
ifeq ($(strip $(ANSIBLE_HOSTS)),)
ANSIBLE_HOSTS := hosts
endif

## Show this help
help:
	@echo "Usage:\n  ${BOLD}make <target> [options]${RESET}"
	@echo "Options:"
	@echo ""
	@echo "Targets:"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		msg = match(previousLine, /^## (.*)/); \
		if (msg) { \
			cmd = substr($$1, 0, index($$1, ":")-1); \
			msg = substr(previousLine, RSTART + 3, RLENGTH); \
			printf "  '${BOLD}'%-$(HELP_TARGET_MAX_LENGTH)s'${RESET}' %s\n", cmd, msg; \
		} \
	} \
	{ previousLine = $$0 }' $(MAKEFILE_LIST)
	@echo ""
	@echo "Options:"
	@echo "  ${BOLD}ANSIBLE_PLAYBOOKS_PATH${RESET}   Playbooks path (Default: $(ANSIBLE_PLAYBOOKS_PATH))"
	@echo "  ${BOLD}ANSIBLE_USER${RESET}             Remote user (Default: $(ANSIBLE_USER))"
	@echo "  ${BOLD}ANSIBLE_HOSTS${RESET}            Inventory hosts path (Default: $(ANSIBLE_HOSTS))"

check_git_ssh_keys:
# 	@ssh -T git@bitbucket.org &> /dev/null || (echo "$(ERROR_STRING) Bitbucket identitiy is absent on SSH agent"; exit 1)
# 	@echo "$(OK_STRING) Bitbucket identitiy is present on SSH agent"
	@ssh -T git@github.com &> /dev/null; ([ $$? == 1 ] || (echo "$(ERROR_STRING) Github identitiy is absent on SSH agent"; exit 1))
	@echo "$(OK_STRING) Github identitiy is present on SSH agent"

ansible_roles: check_git_ssh_keys
	@mkdir -p $(ANSIBLE_DEPENDENCIES_ROLES_PATH)
	@ansible-galaxy install -r $(ANSIBLE_GALAXY_REQUIREMENTS) -p $(ANSIBLE_DEPENDENCIES_ROLES_PATH)
	@echo "$(OK_STRING) Required Ansible roles installed"

## Install dependencies
get: ansible_roles

## Process Ansible Playbook site.yml within ANSIBLE_PLAYBOOKS_PATH
site: ansible_roles
	@ansible-playbook -u $(ANSIBLE_USER) -i $(ANSIBLE_HOSTS) $(ANSIBLE_PLAYBOOKS_PATH)/site.yml

## Clean dependencies and built assets
clean:
	@rm -rf $(DEPENDENCIES_PATH)

.PHONY=help prerequisites check_git_ssh_keys ansible_roles all get site db clean
.DEFAULT_GOAL=help
