data "aws_ssm_parameter" "vpc_id" {
  name = "/network/vpc_id"
}

data "aws_ssm_parameter" "vpc_cidr_block" {
  name = "/network/vpc_cidr"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/network/private_subnet_id"
}

data "aws_ssm_parameter" "private_subnets_cidr_blocks" {
  name = "/network/private_subnets_cidr_blocks"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/network/public_subnet_id"
}

data "aws_ssm_parameter" "public_subnets_cidr_blocks" {
  name = "/network/public_subnets_cidr_blocks"
}

data "aws_ssm_parameter" "documentdb_endpoint" {
  name = "/infra/documentdb_endpoint"
}

data "aws_ssm_parameter" "documentdb_port" {
  name = "/infra/documentdb_port"
}

data "aws_ssm_parameter" "documentdb_username" {
  name = "/infra/documentdb_username"
}

data "aws_ssm_parameter" "documentdb_password" {
  name = "/infra/documentdb_password"
}

data "aws_ssm_parameter" "ecs_cluster_id" {
  name = "/infra/ecs_cluster_id"
}
