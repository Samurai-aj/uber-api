#create a vpc
resource "aws_vpc" "eks-vpc" {

    cidr_block = var.vpc-cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
    Name = "${var.project-name}-vpc"
    }
    
  
}

#create an internet gateway for the vpc
resource "aws_internet_gateway" "eks-gw"{

    vpc_id =  aws_vpc.eks-vpc.id

    tags = {
      Name = "${var.project-name}-gw" 
    }
    
}

#create a route table for the vpc
resource "aws_route_table" "eks-routetable" {

    vpc_id = aws_vpc.eks-vpc.id

     route {
             cidr_block = "0.0.0.0/0"
             #cidr_block = var.route-cidr
             gateway_id =  aws_internet_gateway.eks-gw.id
  }

    tags = {
      Name = "${var.project-name}-vpc-routetable"
    }

}

#read availability data from aws
data "aws_availability_zones" "available_zones" {}

#create a private subnet
resource "aws_subnet" "eks-subnet-private-az-1a" {

    vpc_id =  aws_vpc.eks-vpc.id
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    cidr_block = var.priv1a-cidr
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.project-name}-private-subnet"
    }

}

#create a public subnet
resource "aws_subnet" "eks-subnet-public-az-1b" {

    vpc_id = aws_vpc.eks-vpc.id
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    cidr_block = var.pub1b-cidr
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project-name}-public-subnet"
       "kubernetes.io/cluster/${var.eks-cluster}" = "shared"
    }
   
}

#create a private subnet
resource "aws_subnet" "eks-subnet-private-az-2a" {

    vpc_id =  aws_vpc.eks-vpc.id
    availability_zone = data.aws_availability_zones.available_zones.names[1] 
    cidr_block = var.priv2a-cidr
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.project-name}-private-subnet"
    }

}

#create a public subnet
resource "aws_subnet" "eks-subnet-public-az-2b" {

    vpc_id =  aws_vpc.eks-vpc.id
    availability_zone =  data.aws_availability_zones.available_zones.names[1] 
    cidr_block = var.pub2b-cidr
    map_public_ip_on_launch = true
    #any subnet which is to house a k8s node must have the kubernetes.io tags
    tags = {
      Name = "${var.project-name}-public-subnet"
      "kubernetes.io/cluster/${var.eks-cluster}" = "shared"
    }
}

#attach a route table to the first public subnet
resource "aws_route_table_association" "eks-assos" {

    subnet_id =  aws_subnet.eks-subnet-public-az-1b.id
    route_table_id = aws_route_table.eks-routetable.id

  
}

#attach a route table to the second public subnet
resource "aws_route_table_association" "eks-assos-2" {

    subnet_id =   aws_subnet.eks-subnet-public-az-2b.id
    route_table_id = aws_route_table.eks-routetable.id
  
}