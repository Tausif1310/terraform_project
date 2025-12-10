terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.21.0"
    }
  }
}

backend "s3"{

  bucket = "tausif-junoon-state-bucket"
  key = "terraform.tfstate"
  region ="us-east-2"
  dynamodb_table = "tausif-junoon-state-table"

}