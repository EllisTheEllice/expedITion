

/*
           __          __   _____ 
    /\     \ \        / /  / ____|
   /  \     \ \  /\  / /  | (___  
  / /\ \     \ \/  \/ /    \___ \ 
 / ____ \     \  /\  /     ____) |
/_/    \_\     \/  \/     |_____/ 
                                  
*/
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "aws_region" {}
//variable "aws_rds_dbname" {}
//variable "aws_lambda_jar_path" {}
//variable "aws_s3_bucketname" {}
variable "aws_api_apiname" {}

variable "aws_eip_alloc_id" {}


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}




module "aws_dynamo" {
  source = "./modules/aws/dynamo"

  region                  = "${var.aws_region}"
  aws_access_key_id       = "${var.aws_access_key}"
  aws_secret_access_key   = "${var.aws_secret_key}"
}

module "aws_lambda" {
  source  = "./modules/aws/lambda"

  region  = "${var.aws_region}"
}

module "aws_apigateway" {
  source            = "./modules/aws/api"

  accountId         = "${var.aws_account_id}"
  contacts_arn      = "${module.aws_lambda.contacts_arn}"
  transactions_arn  = "${module.aws_lambda.transactions_arn}"
  region            = "${var.aws_region}"
  apiname           = "${var.aws_api_apiname}"
}

module "aws_ec2" {
  source     = "./modules/aws/ec2"
  //apiid      = "${module.aws_apigateway.apiid}"
  apiid      = "${module.aws_apigateway.api_id}"  
  eip_alloc_id="${var.aws_eip_alloc_id}"
}

/*
module "aws_s3" {
  source = "./modules/aws/s3"

  target_lambda_function_arn  = "${module.aws_lambda.function_arn}"  
  bucketname                  = "${var.aws_s3_bucketname}"
}*/

output "web-server-ip" {
  value = "${module.aws_ec2.web-server-ip}"
}

output "jenkins-ip" {
  value = "${module.aws_ec2.jenkins-ip}"
}