// create vpc

resource "aws_vpc" "vpc1" {
  cidr_block           = "172.120.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "utc-app"
    env  = "Dev"
    Team = "Devops"
  }
}
# Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "utc-app"
    env  = "Dev"
    Team = "Devops"
  }
}
# subnet 

resource "aws_subnet" "pusub1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "172.120.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-us-east-1a"

  }
}

resource "aws_subnet" "pusub2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "172.120.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "public-us-east-1b"

  }
}

// Private subnets 

resource "aws_subnet" "prisub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "172.120.3.0/24"
  #map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-us-east-1a"

  }
}

resource "aws_subnet" "prisub2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "172.120.4.0/24"
  #map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-us-east-1b"

  }
}

// Nat Gateway

resource "aws_eip" "eip1" {

}

resource "aws_nat_gateway" "gtw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.pusub1.id

  tags = {
    Name = "NATGW"
    env  = "Dev"
  }
}

// Private Route Table 

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gtw1.id
  }

}

// Public route table
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc1.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

// Private Route Table associatons

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.prisub1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.prisub2.id
  route_table_id = aws_route_table.rt1.id
}

// Public Route table Associatons

resource "aws_route_table_association" "pubrta1" {
  subnet_id      = aws_subnet.pusub1.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_route_table_association" "pubrta2" {
  subnet_id      = aws_subnet.pusub2.id
  route_table_id = aws_route_table.rt2.id
}
