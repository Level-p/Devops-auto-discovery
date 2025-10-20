provider "aws" {
  region = "eu-west-2"
}
terraform {
  backend "s3" {
    bucket = "steven-auto-discovery"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-2"  # Correct region
  }
}


provider "vault" {
  address = "https://vault.stevenincloud.online"
  token   = "hvs.9JVg5rmvq034TV9tsFc4usjP" 
}