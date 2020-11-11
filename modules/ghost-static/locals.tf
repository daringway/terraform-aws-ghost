
data aws_caller_identity current {}
data aws_region current {}

locals {

  application      = var.application
  parameter_prefix = "/application/${local.application}"

  tags = merge(
    //    Default Tag Values
    {
      managed-by : "terraform",
    },
    //    User Tag Value
    var.tags,
    //    Fixed tags for module
    {
      Application : local.application,
    }
  )


  ec2_tags = merge({
    Application : var.application
    backup : "default"
    },
    local.tags,
    {
      SSHUSER : "ubuntu"
    }
  )

  base_name = "${local.application}"

  //  ***** Network Settings
  //  vpc_id     = var.infrastructure_info.vpc_id
  //  subnet_ids = var.infrastructure_info.subnet_ids

  //  ***** DNS Settings
  enable_root_domain_count = var.enable_root_domain ? 1 : 0

  cloudfront_aliases = var.enable_root_domain ? [local.www_fqdn, local.dns_zone_name] : [local.www_fqdn]

  dns_zone_name = var.dns_zone_name
  www_hostname  = var.web_hostname
  cms_hostname  = var.cms_hostname
  www_fqdn      = "${var.web_hostname}.${var.dns_zone_name}"
  cms_fqdn      = "${var.cms_hostname}.${var.dns_zone_name}"

  cms_bucket_name = "${local.cms_fqdn}-${data.aws_caller_identity.current.account_id}"
  web_bucket_name = "${local.www_fqdn}-${data.aws_caller_identity.current.account_id}"

  instance_profile_name = "${local.cms_fqdn}"

  //  ***** CLOUDFRONT main-cloudfront.tf
  acm_cert_arn = var.acm_cert_arn

  database_name     = "ghost_${local.base_name}"
  database_username = "ghost_${substr(strrev(local.base_name), 0, 10)}"
  database_password = "abc123"

  smtp_user     = var.smtp_user
  smtp_password = var.smtp_password

  database_host = var.database_host
  database_port = var.database_port

  viewer_request_lambda_arns = var.viewer_request_lambda_arns
}