
terraform {
  backend "s3" {
    bucket       = "steven-auto-discovery"
    // use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    # key     = "env:/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    # profile      = "pet-adoption"
  }
}

provider "vault" {
  address = "https://vault.stevenincloud.online"
  token   = "hvs.FgsWrVWty4HsB021E2OblCFa" 
}

provider "aws" {
  region = "eu-west-2"
}