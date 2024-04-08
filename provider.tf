provider "aws" {
  region = var.AWS_REGION
}

terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.44.0"
   }
 }
}


terraform {
 backend "s3" {
   bucket         = "terraformbucketforstatefilestore"
   key            = "state/terraform.tfstate"
   region         = "us-east-1"
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key"
   dynamodb_table = "terraform-state-lock-table"
 }
}
