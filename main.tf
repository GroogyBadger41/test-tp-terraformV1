#VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}
#coucou
#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

#Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
}

#Default Route to Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#Subnet A
resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_a_ip
}

#Subnet B
resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_b_ip
}

#Associate Subnet A with Route Table
resource "aws_route_table_association" "subnet_a_assoc" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

#Associate Subnet B with Route Table
resource "aws_route_table_association" "subnet_b_assoc" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table.id
}

#Créer une clé SSH
 data "aws_key_pair" "my_key" {
   key_name   = "vockey"
}

#Groupe de sécurité pour SSH
resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "Autorise les connexions SSH sur le port 22"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permet l'accès SSH depuis n'importe où (à restreindre pour plus de sécurité)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Instance Ubuntu
resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Remplacez par l'AMI Ubuntu 2023 (voir étape suivante)
  instance_type = "t2.micro"    # Instance gratuite (dans les limites du Free Tier)

  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "Ubuntu-2023"
  }
}
