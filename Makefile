# Default target
.DEFAULT_GOAL := help

# Variables
TERRAFORM_IMAGE = hashicorp/terraform:latest

# Help target
help:
	@echo "Available targets:"
	@echo "  droplet-create   - Create and setup a new droplet"
	@echo "  droplet-cleanup  - Destroy droplet infrastructure"

# Droplet targets
# Pattern rule for droplet commands
droplet-%: droplet-%
	@true

# Hidden implementation targets
_droplet-init:
	cd droplet && docker run --rm -v $(PWD)/droplet:/workspace -w /workspace $(TERRAFORM_IMAGE) init

_droplet-apply:
	cd droplet && docker run --rm -v $(PWD)/droplet:/workspace -w /workspace \
		-e TF_VAR_do_token \
		-e DIGITALOCEAN_API_TOKEN \
		-e TF_VAR_ssh_key_ids \
		$(TERRAFORM_IMAGE) apply -auto-approve

_droplet-destroy:
	cd droplet && docker run --rm -v $(PWD)/droplet:/workspace -w /workspace -e TF_VAR_do_token -e DIGITALOCEAN_API_TOKEN $(TERRAFORM_IMAGE) destroy -auto-approve

_droplet-plan:
	cd droplet && docker run --rm -v $(PWD)/droplet:/workspace -w /workspace \
		-e TF_VAR_do_token \
		-e DIGITALOCEAN_API_TOKEN \
		-e TF_VAR_ssh_key_ids \
		$(TERRAFORM_IMAGE) plan

_droplet-fmt:
	cd droplet && docker run --rm -v $(PWD)/droplet:/workspace -w /workspace $(TERRAFORM_IMAGE) fmt

_droplet-validate:
	cd droplet && docker run --rm -v $(PWD)/droplet:/workspace -w /workspace $(TERRAFORM_IMAGE) validate



# Public target that combines init and apply
droplet-create: _droplet-init _droplet-apply

droplet-cleanup: _droplet-destroy

.PHONY: help _droplet-init _droplet-apply droplet-create droplet-plan droplet-destroy droplet-fmt droplet-validate

