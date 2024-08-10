resource "aws_iam_role" "ecs_task_execution_role" {
  name = "RecipeMgtEcsTaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "allow_vpc_cidr" {
  name        = "${var.stack_name}-allow-vpc-cidr-range"
  description = "Allow all inbound traffic and outbound traffic"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  tags = {
    Name = "${var.stack_name}-allow-vpc-cidr-range"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ingress_ipv4" {
  security_group_id = aws_security_group.allow_vpc_cidr.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_vpc_cidr.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_lb" "application_loadbalancer" {
  name               = "${var.stack_name}-alb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.allow_vpc_cidr.id]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_id.value)
  idle_timeout       = 60
}

resource "aws_lb_target_group" "application_target_group" {
  name     = "${var.stack_name}-tg"
  port     = 22137
  protocol = "TCP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  target_type = "ip"

  health_check {
    # path = "/"
    # protocol            = "tcp"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "application_listener" {
  load_balancer_arn = aws_lb.application_loadbalancer.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_target_group.arn
  }
}
