variable "project-name" {}
variable "vpc-cidr" {}
variable "priv1a-cidr" {}
variable "pub1b-cidr" {}
variable "priv2a-cidr" {}
variable "pub2b-cidr" {}
variable "project-region" {}

#ecr variables
variable "repo-name" {}

#eks variables
variable "eks-role" {}
variable "eks-clustername" {}
variable "eks-noderole" {}
variable "node-name" {}
variable "eks-cluster" {}
variable "instance-type" {}
variable "ami-type" {}
variable "disk-size" {}