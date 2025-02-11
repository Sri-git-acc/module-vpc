variable "project_name" {

}

variable "environment" {

}

variable "vpc_cidr_block" {
    
}

variable "instance_tenancy" {
    default = "default"
}

variable "enable_dns_hostnames" {
    default = true
}

variable "common_tags" {
    default = {
        Terraform = true
    }
}

variable "vpc_tags" {
    default = {}
}

variable "public_subnet_cidr_blocks" {
    type = list
    validation {
        condition = length(var.public_subnet_cidr_blocks) == 2
        error_message = "Please provide two valid public CIDR blocks"
    }
}

variable "map_public_ip_on_launch" {
    default = true
}

variable "public_subnet_tags" {
    default = {}
}

variable "private_subnet_cidr_blocks" {
    type = list
    validation {
        condition = length(var.private_subnet_cidr_blocks) == 2
        error_message = "Please provide two valid private CIDR blocks"
    }
}

variable "private_subnet_tags" {
    default = {}
}

variable "database_subnet_cidr_blocks" {
    type = list
    validation {
        condition = length(var.database_subnet_cidr_blocks) == 2
        error_message = "Please provide two valid database CIDR blocks"
    }
}

variable "database_subnet_tags" {
    default = {}
}

variable "igw_tags" {
    default = {}
}

variable "eip_tags" {
    default = {}
}

variable "nat_tags" {
    default = {}
}

variable "public_route_tags" {
    default = {}
}

variable "private_route_tags" {
    default = {}
}

variable "database_route_tags" {
    default = {}
}

variable "is_peering_required" {
    default = false
}

variable "vpc_peering_tags" {
    default = {}
}