#  vpc module

**Inputs:**

* vpc_cidr_block(Mandatory): User must supply cidr block for vpc.
* instance_tenancy(Optional): Default value is "default". If user want a dedicated vpc, then they can opt for "dedicated".
* enable_dns_hostnames(Optional): Default value is "true". The other option is "false".
* common_tags(Optional): Default is "Terraform = "true", user can provide tags in map structure.
* vpc_tags(Optional): Default is empty. User can provide tags in map structure.
* project_name(Mandatory): User must supply project name.
* environment(Mandatory): User must supply project environment.
* public_subnet_cidr_blocks(Mandatory): User must supply two public CIDR blocks for the subnet.
* map_public_ip_on_launch(Optional): Default is "true". The other option is "false".
* public_subnet_tags(Optional): Default is empty. User can provide tags in map structure.
* private_subnet_cidr_blocks(Mandatory): User must supply two private CIDR blocks for the subnet.
* private_subnet_tags(Optional): Default is empty. User can provide tags in map structure.
* database_subnet_cidr_blocks(Mandatory): User must supply two database CIDR blocks for the subnet.
* database_subnet_tags(Optional): Default is empty. User can provide tags in map structure.
* igw_tags(Optional): Default is empty. User can provide tags in map structure.
* eip_tags(Optional): Default is empty. User can provide tags in map structure.
* nat_tags(Optional): Default is empty. User can provide tags in map structure.
* public_route_tags(Optional): Default is empty. User can provide tags in map structure.
* private_route_tags(Optional): Default is empty. User can provide tags in map structure.
* database_route_tags(Optional): Default is empty. User can provide tags in map structure.


**Outputs:**

* vpc_info: Information about the created vpc will be displayed.