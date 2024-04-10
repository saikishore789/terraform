resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "myapp"
  container_definitions = templatefile("templates/app.json.tpl", {
   REPOSITORY_URL = replace(aws_ecr_repository.test.repository_url, "https://", "")
  })
}

resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.myapp-elb-securitygroup.id]
  subnets = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 3000
 protocol    = "HTTP"
 vpc_id      = aws_vpc.main.id

 health_check {
   path = "/"
 }
}

resource "aws_ecs_service" "myapp_service" {
  name = "myapp_service"
  cluster = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count = 1
  iam_role = aws_iam_role.ecs-service-role.arn
  depends_on = [aws_iam_policy_attachment.ecs-service-attach]

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.test.name
    weight = 100
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_port = 3000
    container_name = "myapp"
  }
  lifecycle {
    ignore_changes = [ task_definition ]
  }
}