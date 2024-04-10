resource "aws_ecs_cluster" "ecs" {
  name = "demo"
}

resource "aws_key_pair" "mykeypair" {
  key_name = "terraform"
  public_key = var.key_pair
}
resource "aws_launch_configuration" "ecs-launchconfig" {
  name_prefix = "ecs-launchconfig"
  image_id = lookup(var.ECS_AMIS, var.AWS_REGION)
  instance_type = var.ECS_INSTANCE_TYPE
  key_name = aws_key_pair.mykeypair.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
  security_groups = [aws_security_group.ecs-securitygroup.id]
  user_data = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "name" {
  name = "ecs-autoscaling"
  vpc_zone_identifier = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration = aws_launch_configuration.ecs-launchconfig.name
  min_size = 1
  max_size = 2
  desired_capacity = 1
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "test" {
  name = "capacity-provider-asg"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.name.arn

    managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
   
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  capacity_providers = [aws_ecs_capacity_provider.test.name]
  cluster_name = aws_ecs_cluster.ecs.name

  default_capacity_provider_strategy {
    base = 1
    capacity_provider = aws_ecs_capacity_provider.test.name
    weight = 100
  }
}