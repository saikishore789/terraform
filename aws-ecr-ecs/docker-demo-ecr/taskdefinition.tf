resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "myapp"
  container_definitions = templatefile("templates/app.json.tpl", {
   REPOSITORY_URL = replace(aws_ecr_repository.test.repository_url, "https://", "")
  })
}

resource "aws_elb" "myapp-elb" {
  name = "myapp-elb"
  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:3000/"
    interval            = 60
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  subnets = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.myapp-elb-securitygroup.id]

  tags = {
    Name = "myapp-elb"
  }
}

resource "aws_ecs_service" "myapp_service" {
  name = "myapp_service"
  cluster = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count = 1
  iam_role = aws_iam_role.ecs-service-role.arn
  depends_on = [ aws_iam_policy_attachment.ecs-service-attach ]

  load_balancer {
    elb_name = aws_elb.myapp-elb.name
    container_port = 3000
    container_name = "myapp"
  }
  lifecycle {
    ignore_changes = [ task_definition ]
  }
}