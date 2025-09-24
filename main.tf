terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.29.0"
    }
  }
}

provider "ibm" {
  alias  = "primary"
  region = var.region_primary
}

data "ibm_resource_group" "group" {
  provider = ibm.primary
  name = var.resource_group
}

data "ibm_is_ssh_key" "sshkey" {
  provider = ibm.primary
  name = var.ssh_keyname
}


##############################################################################
# Create a VPC primary datacenter
##############################################################################

resource "ibm_is_vpc" "vpc-pr" {
  provider      = ibm.primary
  name          = "vpc-lb-demo-primary-${var.resource_group}"
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Create Subnet zone primary datacenter
##############################################################################

resource "ibm_is_public_gateway" "public_gateway_pr" {
  provider      = ibm.primary
  name = "lb-demo-gateway-1-${var.resource_group}"
  vpc  = ibm_is_vpc.vpc-pr.id
  zone = "${var.region_primary}-1"
  resource_group = data.ibm_resource_group.group.id
  timeouts {
    create = "90m"
  }
}

resource "ibm_is_public_gateway" "public_gateway_pr2" {
  provider      = ibm.primary
  name = "lb-demo-gateway-2-${var.resource_group}"
  vpc  = ibm_is_vpc.vpc-pr.id
  zone = "${var.region_primary}-2"
  resource_group = data.ibm_resource_group.group.id
  timeouts {
    create = "90m"
  }
}

##############################################################################
# Create subnet 1 on primary datacenter
##############################################################################

resource "ibm_is_subnet" "cce-subnet-pr-1" {
  provider = ibm.primary
  name            = "lb-demo-subnet-pr-1-${var.resource_group}"
  vpc             = ibm_is_vpc.vpc-pr.id
  zone            = "${var.region_primary}-1"
  total_ipv4_address_count= "256"
  public_gateway  = ibm_is_public_gateway.public_gateway_pr.id
  resource_group  = data.ibm_resource_group.group.id
}

##############################################################################
# Create subnet 2 on primary datacenter
##############################################################################

resource "ibm_is_subnet" "cce-subnet-pr-2" {
  provider = ibm.primary
  name            = "lb-demo-subnet-pr-2-${var.resource_group}"
  vpc             = ibm_is_vpc.vpc-pr.id
  zone            = "${var.region_primary}-2"
  total_ipv4_address_count= "256"
  public_gateway  = ibm_is_public_gateway.public_gateway_pr2.id
  resource_group  = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group" "security_group" {
  provider      = ibm.primary
  name           = "lb-demo-sg-${var.resource_group}"
  vpc            = ibm_is_vpc.vpc-pr.id
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group_rule" "security_group_rule_in" {
  provider      = ibm.primary
  group     = ibm_is_security_group.security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "security_group_rule_out" {
  provider      = ibm.primary
  group     = ibm_is_security_group.security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

##############################################################################
# Desploy instances on primary datacenter
##############################################################################

resource "ibm_is_instance" "cce-vsi-pr-1" {
  provider = ibm.primary
  name    = "lb-demo-1-${var.resource_group}"
  image   = "r006-5697e196-1f34-4bd0-8c1a-d316723ab37d"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.cce-subnet-pr-1.id
    security_groups = [ibm_is_security_group.security_group.id]
  }

  vpc       = ibm_is_vpc.vpc-pr.id
  zone      = "${var.region_primary}-1"
  keys      = [data.ibm_is_ssh_key.sshkey.id]
  user_data = file("./script.sh")
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_instance" "cce-vsi-pr-2" {
  provider = ibm.primary
  name    = "lb-demo-2-${var.resource_group}"
  image   = "r006-5697e196-1f34-4bd0-8c1a-d316723ab37d"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.cce-subnet-pr-2.id
    security_groups = [ibm_is_security_group.security_group.id]
  }

  vpc       = ibm_is_vpc.vpc-pr.id
  zone      = "${var.region_primary}-2"
  keys      = [data.ibm_is_ssh_key.sshkey.id]
  user_data = file("./script.sh")
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_lb" "lb-nginx" {
  provider      = ibm.primary
  name            = "lb-demo-${var.resource_group}"
  subnets         = [ibm_is_subnet.cce-subnet-pr-1.id, ibm_is_subnet.cce-subnet-pr-2.id]
  security_groups = [ibm_is_security_group.security_group.id]
  resource_group  = data.ibm_resource_group.group.id
}

resource "ibm_is_lb_pool" "lb-nginx-pool" {
  provider      = ibm.primary
  lb                 = ibm_is_lb.lb-nginx.id
  name               = "nginx-lb-pool-${var.resource_group}"
  protocol           = "http"
  algorithm          = "round_robin"
  health_delay       = "15"
  health_retries     = "2"
  health_timeout     = "5"
  health_type        = "http"
  health_monitor_url = "/"
}

resource "ibm_is_lb_pool_member" "lb-server-1" {
  provider      = ibm.primary
  lb             = ibm_is_lb.lb-nginx.id
  pool           = ibm_is_lb_pool.lb-nginx-pool.id
  port           = 80
  target_address     = ibm_is_instance.cce-vsi-pr-1.primary_network_interface[0].primary_ipv4_address
  weight         = 60
}

resource "ibm_is_lb_pool_member" "lb-server-2" {
  provider      = ibm.primary
  lb             = ibm_is_lb.lb-nginx.id
  pool           = ibm_is_lb_pool.lb-nginx-pool.id
  port           = 80
  target_address = ibm_is_instance.cce-vsi-pr-2.primary_network_interface[0].primary_ipv4_address 
  weight         = 60
}

resource "ibm_is_lb_listener" "lb-listener" {
  provider      = ibm.primary
  lb                   = ibm_is_lb.lb-nginx.id
  port                 = "80"
  protocol             = "http"
  default_pool         = element(split("/", ibm_is_lb_pool.lb-nginx-pool.id), 1)
}
