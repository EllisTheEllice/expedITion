variable "contacts_arn" {}
variable "transactions_arn" {}
variable "accountId" {}
variable "region" {}
variable "apiname" {}



resource "aws_api_gateway_rest_api" "expedition_api" {
  name        = "${var.apiname}"
  description = "This is my API for demonstration purposes"
}

/*
  Resource contacts
*/
resource "aws_api_gateway_resource" "apigateway_contacts_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  parent_id = "${aws_api_gateway_rest_api.expedition_api.root_resource_id}"
  path_part = "contacts"
}

resource "aws_api_gateway_method" "contacts-method" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apigateway_contacts_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "GET"
  type = "AWS_PROXY"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.contacts_arn}/invocations"
  depends_on = ["aws_api_gateway_method.contacts-method"]
}

resource "aws_api_gateway_method_response" "ContactsGet200" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "GET"
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  depends_on = ["aws_api_gateway_integration.apigateway_contacts_method_integration"]
  status_code= 200
}

resource "aws_api_gateway_integration_response" "ContactsGetIntegrationResponse" {
  depends_on = ["aws_api_gateway_method_response.ContactsGet200"]
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "${aws_api_gateway_method.contacts-method.http_method}"
  status_code = "200"
  selection_pattern = "200"
  
  response_templates = {
       "application/json" = ""
  } 
}




/*
  CORS for contacts
*/
resource "aws_api_gateway_method" "ContactsResourceOptions" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ContactsResourceOptionsIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "${aws_api_gateway_method.ResourceOptions.http_method}"
  type = "MOCK"
  depends_on = ["aws_api_gateway_method.ContactsResourceOptions"]
  request_templates = { 
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_method_response" "ContactsResourceOptions200" {
  depends_on = ["aws_api_gateway_integration.ContactsResourceOptionsIntegration"]
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "OPTIONS"
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "ContactsResourceOptionsIntegrationResponse" {
  depends_on = ["aws_api_gateway_method_response.ContactsResourceOptions200"]
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "${aws_api_gateway_method.ResourceOptions.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET,PUT,PATCH,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}


resource "aws_lambda_permission" "apigw_contacts_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.contacts_arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.expedition_api.id}/*/${aws_api_gateway_method.contacts-method.http_method}${aws_api_gateway_resource.apigateway_contacts_resource.path}"
}





/*
  Resource transactions
*/
resource "aws_api_gateway_resource" "apigateway_transactions_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  parent_id = "${aws_api_gateway_rest_api.expedition_api.root_resource_id}"
  path_part = "transactions"
}

resource "aws_api_gateway_method" "transactions-method" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apigateway_transactions_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "GET"
  type = "AWS_PROXY"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.transactions_arn}/invocations"
  depends_on = ["aws_api_gateway_method.transactions-method"]
}

resource "aws_api_gateway_method_response" "TransactionsGet200" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "GET"
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  depends_on = ["aws_api_gateway_integration.apigateway_transactions_method_integration"]
  status_code= 200
}

resource "aws_api_gateway_integration_response" "TransactionsGetIntegrationResponse" {
  depends_on = ["aws_api_gateway_method_response.TransactionsGet200"]
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "${aws_api_gateway_method.transactions-method.http_method}"
  status_code = "200"

  selection_pattern = "200"
  
  response_templates = {
       "application/json" = ""
  } 
}



resource "aws_lambda_permission" "apigw_transactions_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.transactions_arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.expedition_api.id}/*/${aws_api_gateway_method.transactions-method.http_method}${aws_api_gateway_resource.apigateway_transactions_resource.path}"
}




/*
  CORS for transactions
*/
resource "aws_api_gateway_method" "ResourceOptions" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ResourceOptionsIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "${aws_api_gateway_method.ResourceOptions.http_method}"
  type = "MOCK"
  request_templates = { 
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_method_response" "ResourceOptions200" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "OPTIONS"
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = ["aws_api_gateway_integration.ResourceOptionsIntegration"]
  status_code= 200
}

resource "aws_api_gateway_integration_response" "ResourceOptionsIntegrationResponse" {
  depends_on = ["aws_api_gateway_method_response.ResourceOptions200"]
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_transactions_resource.id}"
  http_method = "${aws_api_gateway_method.ResourceOptions.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET,PUT,PATCH,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}





/*

resource "aws_api_gateway_resource" "apigateway_transactions_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  parent_id = "${aws_api_gateway_rest_api.expedition_api.root_resource_id}"
  path_part = "transactions"
}




resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  resource_id = "${aws_api_gateway_resource.apigateway_contacts_resource.id}"
  http_method = "GET"
  status_code = "${var.http_response_statuscode}"
  selection_pattern = "${var.http_response_statuscode}"

  depends_on  = ["aws_api_gateway_integration.apigateway_method_integration"]
  # Transforms the backend JSON response to XML
  response_templates = {
       "application/json" = ""
   } 
}

resource "aws_api_gateway_method_response" "response" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  response_models = {
         "application/json" = "${var.integration_model_name}"
  }
  depends_on = ["aws_api_gateway_integration_response.integration_response"]
  status_code = "${var.http_response_statuscode}"
}*/




























resource "aws_api_gateway_deployment" "apigateway_deployment_dev" {
  rest_api_id = "${aws_api_gateway_rest_api.expedition_api.id}"
  stage_name = "dev"
  depends_on  = ["aws_lambda_permission.apigw_contacts_lambda","aws_lambda_permission.apigw_transactions_lambda"]
}

output "dev_url" {
  value = "https://${aws_api_gateway_deployment.apigateway_deployment_dev.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.apigateway_deployment_dev.stage_name}"
}

output "api_id" {
  value = "${aws_api_gateway_rest_api.expedition_api.id}"
}