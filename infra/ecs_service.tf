resource "aws_ecs_service" "frontend_service" {
  name            = "frontend"
  cluster         = data.aws_ssm_parameter.ecs_cluster_id.value
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = split(",", data.aws_ssm_parameter.private_subnet_id.value)
    security_groups = [aws_security_group.allow_vpc_cidr.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.application_target_group.arn
    container_name   = "frontend"
    container_port   = 22137
  }
  service_connect_configuration {
    enabled   = true
    namespace = "test-service-connect"
    service {
      port_name = "nodejs"
      discovery_name = "frontend"
      client_alias {
        port = 22137
        dns_name = "frontend.test-service-connect"
      }
    }
  }
}

resource "aws_ecs_service" "backend_service" {
  name            = "backend"
  cluster         = data.aws_ssm_parameter.ecs_cluster_id.value
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = split(",", data.aws_ssm_parameter.private_subnet_id.value)
    security_groups = [aws_security_group.allow_vpc_cidr.id]
  }
  service_connect_configuration {
    enabled   = true
    namespace = "test-service-connect"
    service {
      port_name = "tomcat"
      discovery_name = "backend"
      client_alias {
        port = 8080
        dns_name = "backend.test-service-connect"
      }
    }
  }
}

resource "aws_service_discovery_http_namespace" "service_connect" {
  name        = "service-connect"
  description = "Service discovery"
}