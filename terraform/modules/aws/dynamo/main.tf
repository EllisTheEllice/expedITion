variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "region" {}

resource "aws_dynamodb_table" "contacts-table" {
  name           = "contacts"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "lastname"

  attribute {
    name = "lastname"
    type = "S"
  }


  provisioner "local-exec" {
    command = "aws configure set aws_access_key_id ${var.aws_access_key_id}"
  }

  provisioner "local-exec" {
    command = "aws configure set region ${var.region}"
  }

  provisioner "local-exec" {
    command = "aws configure set aws_secret_access_key ${var.aws_secret_access_key}"
  }

  provisioner "local-exec" {
    command = "aws dynamodb batch-write-item --request-items file://${path.module}/contacts.json"
  }
}

resource "aws_dynamodb_table" "transactions-table" {
  name           = "transactions"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  depends_on     = ["aws_dynamodb_table.contacts-table"]  

  attribute {
    name = "id"
    type = "N"
  }

    provisioner "local-exec" {
    command = "aws dynamodb batch-write-item --request-items file://${path.module}/transactions.json"
  }

}