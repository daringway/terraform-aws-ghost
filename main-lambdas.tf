
module "default-cloudfront-s3-viewer-request-lambda" {
  count = local.use_default_request_lambda ? 1 : 0

  source = "git::ssh://git@github.com/daringway/terraform-aws-cloudfront-viewer-request-lambda.git?ref=redirect-issue-03"
//  source               = "daringway/cloudfront-viewer-request-lambda/aws"
//  version              = "1.2.2"
  tags                 = local.tags
  lambda_name          = "${local.application}-website-viewer_request"
  apex_domain_redirect = local.enable_root_domain
  index_rewrite        = local.cdn_mode == "static"
  append_slash         = true
  ghost_hostname       = local.cdn_mode == "static" ? local.cms_fqdn : ""
}
