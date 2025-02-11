#vpc block
resource "aws_vpc" main {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = "${var.project_name}-${var.environment}"
        }
    )
}

#public subnet block
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr_blocks)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr_blocks[count.index]
    availability_zone = local.availability_zones[count.index]
    map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = merge(
        var.common_tags,
        var.public_subnet_tags,
        {
            Name = "${var.project_name}-${var.environment}-public-${local.availability_zones[count.index]}"
        }
    )
}

#private subnet block
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr_blocks)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr_blocks[count.index]
    availability_zone = local.availability_zones[count.index]

    tags = merge(
        var.common_tags,
        var.private_subnet_tags,
        {
            Name = "${var.project_name}-${var.environment}-private-${local.availability_zones[count.index]}"
        }
    )
}

#database subnet block
resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidr_blocks)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr_blocks[count.index]
    availability_zone = local.availability_zones[count.index]

    tags = merge(
        var.common_tags,
        var.database_subnet_tags,
        {
            Name = "${var.project_name}-${var.environment}-database-${local.availability_zones[count.index]}"
        }
    )
}

#internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        Name= "${var.project_name}-${var.environment}"
    }
  )
}

#elastic IP
resource "aws_eip" "nat" {
  domain   = "vpc"

  tags = merge(
    var.common_tags,
    var.eip_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )
}

# NAT gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

#public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_tags,
    {
        Name = "${var.project_name}-${var.environment}-public"
    }
  )
}

#private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_route_tags,
    {
        Name = "${var.project_name}-${var.environment}-private"
    }
  )
}

#database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_route_tags,
    {
        Name = "${var.project_name}-${var.environment}-database"
    }
  )
}

#public route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#private route table association
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#database route table association
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr_blocks)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

#public route table routes
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

#private route table routes
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

#database route table routes
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}