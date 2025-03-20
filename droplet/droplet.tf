# Configure the DigitalOcean Provider
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


# Define variable for DO token
variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
  default     = null # Allow it to be optional
}

# Define variable for SSH key IDs
variable "ssh_key_ids" {
  description = "List of DigitalOcean SSH key IDs"
  type        = list(string)
  default     = [] # Empty list as default
}

# Configure the provider with token from environment variable
# Will use DIGITALOCEAN_TOKEN by default, or TF_VAR_do_token if provided
provider "digitalocean" {
  # If do_token is provided via TF_VAR_do_token, use it; otherwise provider will automatically use DIGITALOCEAN_TOKEN
  token = var.do_token
}

# Create a new Droplet
resource "digitalocean_droplet" "ubuntu_droplet" {
  name     = "ubuntu-22-04-droplet"
  size     = "s-2vcpu-4gb"  # 4GB RAM, 2 CPUs, 80GB NVMe SSD
  image    = "ubuntu-22-04-x64"
  region   = "blr1"  # New York 1 region
  
  # Enable monitoring
  monitoring = true
  
  # SSH keys from environment variable
  ssh_keys = var.ssh_key_ids
  
  # User data script to set up the environment
  user_data = file("${path.module}/scripts/init.sh")
}

# Output the droplet IP
output "droplet_ip" {
  value = digitalocean_droplet.ubuntu_droplet.ipv4_address
}

