provider "aws" {
  region  = "eu-west-3"
  # profile = "pet-adoption"
}

terraform {
  backend "s3" {
    bucket       = "auto-discovery-euteam1"
    // use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    # profile      = "pet-adoption"
  }
}

provider "vault" {
  address = "https://vault.steven12.space"
  token   = "hvs.FgsWrVWty4HsB021E2OblCFa" 
}
