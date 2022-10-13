output "project-name" {
  value = var.project-name
}

output "vpc_id" {
    value = aws_vpc.eks-vpc.id
}

output "private_subnet_1a" {

    value =  aws_subnet.eks-subnet-private-az-1a.id
  
}

output "public_subnet_1a" {

    value = aws_subnet.eks-subnet-public-az-1b.id
  
}

output "private_subnet_2a" {

    value = aws_subnet.eks-subnet-private-az-2a.id
  
}

output "public_subnet_2a" {

    value = aws_subnet.eks-subnet-public-az-2b.id
  
}

output "internet_gateway" {
    value = aws_internet_gateway.eks-gw
}