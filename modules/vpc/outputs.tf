output "id"         { value = aws_vpc.aws_vpc.id }
output "arn"        { value = aws_vpc.aws_vpc.arn }
output "cidr_block" { value = aws_vpc.aws_vpc.cidr_block }
output "igw_id"  { value = aws_internet_gateway.internet_gateway.id }