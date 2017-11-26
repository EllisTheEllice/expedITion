resource "aws_s3_bucket" "sourcebucket" {
  bucket = "expedition-2017-sourcebucket"
  acl    = "private"

  tags {
    Name        = "Bucket which contains lambda sources"
  }
}


resource "aws_iam_role" "cross_cloud_hackathon_receiptbuckt_role" {
  name = "cross_cloud_hackathon_iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}