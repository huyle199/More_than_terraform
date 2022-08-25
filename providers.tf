terraform {
  required_providers{
    aws = {
        source = "hashicorp/aws"
    }
  }
}

#configure the AWS provider
provider "aws" {
    region = var.aws_region
  
}
