# provider "aws" {
#   region  = var.region
#   profile = "bukky_int"
# }

# # create aws provider
# provider "aws" {
#   region  = "eu-west-3"
#   profile = "Lington"
# }


# create aws provider
provider "aws" {
  region  = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket       = "steven-auto-discovery"
    # use_lockfile = true
    key          = "vault-jenkins/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    profile      = "default"
  }
}