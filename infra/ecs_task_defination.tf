locals {
  backend_port        = "8080"
  database_connection = "mongodb://root:${data.aws_ssm_parameter.documentdb_password.value}@${data.aws_ssm_parameter.documentdb_endpoint.value}:27017/?tls=false&retryWrites=false"
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "${var.stack_name}-frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "022499035884.dkr.ecr.us-east-1.amazonaws.com/frontend:${var.frontend_image_version}"
      essential = true

      portMappings = [
        {
          containerPort = 22137
          hostPort      = 22137
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${aws_cloudwatch_log_group.frontend.id}"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "webservice_host"
          value = "backend.test-service-connect"
        },
        {
          name  = "webservice_port"
          value = "8080"
        }
      ]
    }
  ])
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "${var.stack_name}-backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "022499035884.dkr.ecr.us-east-1.amazonaws.com/backend:${var.backend_image_version}"
      essential = true

      portMappings = [
        {
          name = "tomcat"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${aws_cloudwatch_log_group.backend.id}"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        {
          name : "databaseUrl",
          value : "${local.database_connection}"
        },
        {
          name : "databaseName",
          value : "ead_ca2"
        },
        {
          name : "databaseCollection",
          value : "ead_2024"
        }
      ]
    }
  ])
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_cloudwatch_log_group" "backend" {
  name = "/ecs/backend"
}

resource "aws_cloudwatch_log_group" "frontend" {
  name = "/ecs/frontend"
}