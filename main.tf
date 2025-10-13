locals {
  name = "steven"
}

data "aws_route53_zone" "zone" {
  name         = var.domain_name
  private_zone = false

}
#calling acm certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validate-record" {
  for_each = {
    for dvo in aws_acm_certificate.steven-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}
resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validate-record : record.fqdn]
}

module "vpc" {
  source = "./module/VPC"
  name   = local.name
  az1    = "eu-west-3b"
  az2    = "eu-west-3c"
}

module "bastion" {
  source     = "./module/bastion"
  name       = local.name
  vpc        = module.vpc.vpc_id
  subnets    = [module.vpc.pub_sub1_id, module.vpc.pub_sub2_id]
  keypair    = module.vpc.public_key
  privatekey = module.vpc.private_key
  nr-acc-id  = var.nr-acc-id
  nr-key     = var.nr-key
}

module "ansible" {
  source      = "./module/Ansible"
  name        = local.name
  keypair     = module.vpc.public_key
  subnet_id   = module.vpc.pri_sub1_id
  vpc         = module.vpc.vpc_id
  bastion_key     = module.bastion.bastion-sg
  private-key = module.vpc.private_key
  nexus-ip    = module.nexus.nexus_ip
  nr-key      = var.nr-key
  nr-acc-id   = var.nr-acc-id
}
module "database" {
  source     = "./module/database"
  name       = local.name
  pri-sub-1  = module.vpc.pri_sub1_id
  pri-sub-2  = module.vpc.pri_sub2_id
  bastion-sg = module.bastion.bastion-sg
  vpc-id     = module.vpc.vpc_id
  stage-sg   = module.stage-env.stage-sg
  prod-sg    = module.prod-env.prod-sg
}

module "sonarqube" {
  source         = "./module/sonarqube"
  name           = local.name
  vpc            = module.vpc.vpc_id
  vpc_cidr_block = "10.0.0.0/16"
  keypair        = module.vpc.public_key
  subnet_id      = module.vpc.pub_sub1_id
  subnets        = module.vpc.pub_sub1_id
  certificate    = data.aws_acm_certificate.cert.arn
  hosted_zone_id = data.aws_route53_zone.zone.id
  domain_name    = var.domain_name
}

module "prod-env" {
  source       = "./module/prod-env"
  name         = local.name
  vpc-id       = module.vpc.vpc_id
  bastion      = module.bastion.bastion-sg
  key-name     = module.vpc.public_key
  pri-subnet1  = module.vpc.pri_sub1_id
  pri-subnet2  = module.vpc.pri_sub2_id
  pub-subnet1  = module.vpc.pub_sub1_id
  pub-subnet2  = module.vpc.pub_sub2_id
  acm-cert-arn = data.aws_acm_certificate.cert.arn
  domain       = var.domain_name
  nexus-ip     = module.nexus.nexus_ip
  nr-key       = var.nr-key
  nr-acct-id   = var.nr-acc-id
  ansible      = module.ansible.ansible_sg
}
module "stage-env" {
  source       = "./module/stage-env"
  name         = local.name
  vpc-id       = module.vpc.vpc_id
  bastion      = module.bastion.bastion-sg
  key-name     = module.vpc.public_key
  pri-subnet1  = module.vpc.pri_sub1_id
  pri-subnet2  = module.vpc.pri_sub2_id
  pub-subnet1  = module.vpc.pub_sub1_id
  pub-subnet2  = module.vpc.pub_sub2_id
  acm-cert-arn = data.aws_acm_certificate.cert.arn
  domain       = var.domain_name
  nexus-ip     = module.nexus.nexus_ip
  nr-key       = var.nr-key
  nr-acct-id   = var.nr-acc-id
  ansible      = module.ansible.ansible_sg
}

module "nexus" {
  source         = "./module/nexus"
  name           = local.name
  vpc            = module.vpc.vpc_id
  keypair        = module.vpc.public_key
  subnet_id      = module.vpc.pub_sub1_id
  subnets        = module.vpc.pub_sub1_id
  certificate    = data.aws_acm_certificate.cert.arn
  hosted_zone_id = data.aws_route53_zone.zone.id
  domain_name    = var.domain_name
}
