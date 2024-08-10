
# Refer to Terraform remote backend
terraform {
  backend "s3" {
    bucket         = "recipe-managment-infra-state-bucket1"
    dynamodb_table = "recipe-managment-infra-lock-db1"
    encrypt        = true
    key            = "reciepe-mgt-app/terraform.tfstate"
    region         = "us-east-1"
    session_name   = "github-local"
  }
}
