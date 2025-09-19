variable "region-primary" {
  default = "us-south"
  description = "au-syd, in-che, jp-osa, jp-tok, kr-seo, eu-de, eu-gb, ca-tor, us-south, us-east, br-sao"
}

variable "ssh_keyname" {
  description = "ssh key name"
}

variable "resource_group" {
  description = "resource group name"
}

variable "vpc_name" {
  description = "Unique name to your VPC"
}
