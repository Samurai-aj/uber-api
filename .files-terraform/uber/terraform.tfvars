 project-name= "uber"
 vpc-cidr = "10.0.0.0/16"
 priv1a-cidr="10.0.144.0/20"
 pub1b-cidr="10.0.128.0/20"
 priv2a-cidr="10.0.0.0/20"
 pub2b-cidr="10.0.16.0/20"
 project-region="us-west-2"

 #ecr variable values
 repo-name="uber"

 #eks-variables
 eks-role="uberEKSclusterROle"
 eks-clustername="uber-cluster"
 eks-noderole="uber-nodepolicy"
 node-name="uber-nodegroup"
 eks-cluster="uber-cluster"
 instance-type="t3.medium"
 ami-type="AL2_x86_64"
 disk-size=20