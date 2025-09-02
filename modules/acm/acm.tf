resource "aws_acm_certificate" "acm" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.san
  tags                      = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

# 도메인 검증 레코드 생성 (Route53)
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}
