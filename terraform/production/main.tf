terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "default"
}

# for ACM. ACM only supports us-east-1
provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "default"
}