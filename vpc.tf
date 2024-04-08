resource "aws_vpc" "terraform-vpc" { # creating vpc
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "terraform-subnet-public-1" { # creating public subnet
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = "us-east-1a"
  tags = {
    Name = "terraform-subnet-public-1"
  }
}


resource "aws_internet_gateway" "terraform-igw" { # internet Gateway
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "terraform-public-rt" { # public route table
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route_table_association" "terraform-crta-public-subnet-1" { # route table association with public subnet
  subnet_id      = aws_subnet.terraform-subnet-public-1.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

