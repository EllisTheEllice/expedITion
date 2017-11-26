variable "region" {}

resource "aws_iam_role" "expeditionrole" {
  name = "myfinancelambdarole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "dynamodb.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/*resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.expeditionrole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:Query",
                "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:eu-west-1:676585958982:table/contacts"
    }, {
      "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:Query",
                "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:eu-west-1:676585958982:table/transactions"
    }
  ]
}
EOF
}*/

resource "aws_iam_role_policy_attachment" "lambda_lambdarole_attachment" {
  role      =  "${aws_iam_role.expeditionrole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_lambdarole_attachment2" {
  role      =  "${aws_iam_role.expeditionrole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}


data "archive_file" "contacts-zip" {
  type = "zip"
  source_file = "${path.module}/contacts/index.js"
  output_path = "${path.module}/contacts/lambda.zip"
}

data "archive_file" "transactions-zip" {
  type = "zip"
  source_file = "${path.module}/transactions/index.js"
  output_path = "${path.module}/transactions/lambda.zip"
}

resource "aws_lambda_function" "contacts_lambda" {
  filename          = "${data.archive_file.contacts-zip.output_path}"
  function_name     = "contactslambda"
  role              = "${aws_iam_role.expeditionrole.arn}"
  handler           = "index.handler"
  runtime           = "nodejs6.10"
  memory_size       = 256
  timeout           = 40
  source_code_hash  = "${base64sha256(file("${data.archive_file.contacts-zip.output_path}"))}"
  publish           = true
}

resource "aws_lambda_function" "transactions_lambda" {
  filename = "${data.archive_file.transactions-zip.output_path}"
  function_name     = "transactionslambda"
  role              = "${aws_iam_role.expeditionrole.arn}"
  handler           = "index.handler"
  runtime           = "nodejs6.10"
  memory_size       = 256
  timeout           = 40
  source_code_hash  = "${base64sha256(file("${data.archive_file.transactions-zip.output_path}"))}"
  publish           = true
}

output "contacts_arn" {
  value = "${aws_lambda_function.contacts_lambda.arn}"
}
output "transactions_arn" {
  value = "${aws_lambda_function.transactions_lambda.arn}"
}