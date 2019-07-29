resource "aws_ecs_cluster" "ecs" {
  name = "${var.default_project_name}-${var.default_environment_name}-ECS"
}


module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${var.default_project_name}-${var.default_environment_name}-Autoscaling"

  lc_name = "${var.default_project_name}-${var.default_environment_name}-LC"

  image_id             = "${data.aws_ami.amazon_linux_ecs.id}"
  instance_type        = "t2.micro"
  security_groups      = ["${module.env_vpc.default_security_group_id}", "${aws_security_group.security_group.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.IAM_profile.id}"
  user_data            = "${data.template_file.user_data.rendered}"

  asg_name                    = "${var.default_project_name}-${var.default_environment_name}-AutoscalingGroup"
  vpc_zone_identifier         = "${module.env_vpc.public_subnets}"
  health_check_type           = "ELB" #?????
  min_size                    = 1
  max_size                    = 10
  desired_capacity            = 1
  wait_for_capacity_timeout   = 0
  associate_public_ip_address = false #?????
  key_name                    = "TestKeyPair"
}

data "template_file" "user_data" {
  template = file("templates/user-data.sh")

  vars = {
    cluster_name = "${var.default_project_name}-${var.default_environment_name}-ECS"
  }
}
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}


resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.default_project_name}-${var.default_environment_name}-task_definition"
  container_definitions = "${file("task-definitions/task_definition.json")}"

  volume {
    name      = "task_definition-storage"
    host_path = "/ecs/task_definition-storage"
  }
}


resource "aws_ecs_service" "service" {
  name                = "${var.default_project_name}-${var.default_environment_name}-service"
  cluster             = "${aws_ecs_cluster.ecs.id}"
  task_definition     = "${aws_ecs_task_definition.task_definition.arn}"
  launch_type         = "EC2"

  desired_count = 1
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0
}
