 resource "aws_instance" "server1" {
          ami  = "ami-00e801948462f718a"
          instance_type = "t2.micro"

          tags = {
            Name = "${var.env}-server"
}
}

        # Create a VPC
        resource "aws_vpc" "my_vpc1" {
          cidr_block = "10.0.0.0/16"
          tags = {
            Name = "My_VPC"
          }
        }
        # Internet Gateway
        resource "aws_internet_gateway" "my_igw1" {
          vpc_id = aws_vpc.my_vpc1.id
          tags = {
            Name = "My_igw"
          }
        }
        # Create a subnet
        resource "aws_subnet" "my_subnet1" {
          vpc_id                  = aws_vpc.my_vpc1.id
          cidr_block              = "10.0.1.0/24"
          map_public_ip_on_launch = true
          availability_zone       = "us-east-1a"
          tags = {
            Name = "My_Subnet"
          }
        }
        # Create a route table
        resource "aws_route_table" "my_rt1" {
          vpc_id = aws_vpc.my_vpc1.id
          route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.my_igw1.id
          }
          tags = {
            Name = "My_RouteTable"
          }
        }
        # Associate route table with subnet
        resource "aws_route_table_association" "my_rta1" {
          subnet_id      = aws_subnet.my_subnet1.id
          route_table_id = aws_route_table.my_rt1.id
        }

        # Security group
        resource "aws_security_group" "my_sg1" {
          vpc_id = aws_vpc.my_vpc1.id
          name   = "my-sg"
          ingress {
            description = "Allow SSH"
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }
          ingress {
            description = "Allow HTTP"
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }
          egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
          tags = {
            Name = "My_SG"
          }
        }

