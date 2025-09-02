output "bucket"         { value = aws_s3_bucket.s3.bucket }
output "bucket_arn"     { value = aws_s3_bucket.s3.arn }
output "lock_table"     { value = aws_dynamodb_table.lock.name }
