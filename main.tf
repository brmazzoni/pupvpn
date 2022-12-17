terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  } 
}

# Set the variable value in *.tfvars file
# or as environment variable: "export TF_VAR_do_token=XXX"
# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "pubkey" {}
variable "domain" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

variable "region" {
  type = string
  default = "sgp1"
}

variable "droplet_size" {
  type = string
  default = "s-1vcpu-512mb-10gb"
}

data "digitalocean_ssh_key" "key" {
  name = var.pubkey
}

resource "digitalocean_droplet" "vpn" {
  image  = "ubuntu-22-04-x64"
  name   = "vpn-${var.region}"
  region = var.region
  size   = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.key.id]

  #provisioner "local-exec" {
  #  command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.ipv4_address},' -u root -e 'domain=${var.domain}' playbook.yml"
  #}
}

resource "digitalocean_domain" "default" {
  name = var.domain
  ip_address = digitalocean_droplet.vpn.ipv4_address
}

output "server_ip" {
  value = digitalocean_droplet.vpn.ipv4_address
}

output "domain" {
  value = var.domain
}

output "monthly_cost" {
  value = digitalocean_droplet.vpn.price_monthly
}
