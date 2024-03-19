resource "aws_iam_role_policy" "access-s3-sqs" {
  name = "access-s3-sqs"
  role = aws_iam_role.ec2-default-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "accessS3LIST",
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
        ],
        "Resource": [
            "arn:aws:s3:::my-web-assets"
        ]
    },
    {
        "Sid": "accessS3GETPUT",
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:PutObject"
        ],
        "Resource": [
            "arn:aws:s3:::my-web-assets/*"
        ]
    },
    {
        "Sid": "accessSQS",
        "Effect": "Allow",
        "Action": [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage"
        ],
        "Resource": [
            "arn:aws:sqs:ap-southeast-1:123456789123:lms-import-data"
        ]
    }
  ]
}
POLICY
}