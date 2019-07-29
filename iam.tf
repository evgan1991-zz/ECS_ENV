resource "aws_iam_instance_profile" "IAM_profile" {
  name = "${var.default_project_name}-${var.default_environment_name}_instance_profile"
  role = "${aws_iam_role.IAM.name}"
}
resource "aws_iam_role" "IAM" {
    name = "${var.default_project_name}-${var.default_environment_name}-IAM"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
    name = "${var.default_project_name}-${var.default_environment_name}-AmazonEC2ContainerServiceforEC2Role"
    roles = ["${aws_iam_role.IAM.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_policy_attachment" "AmazonEC2ContainerServiceRole" {
    name = "${var.default_project_name}-${var.default_environment_name}-AmazonEC2ContainerServiceRole"
    roles = ["${aws_iam_role.IAM.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
resource "aws_iam_policy_attachment" "ecs-service-allow-ec2" {
    name = "${var.default_project_name}-${var.default_environment_name}-ecs-service-allow-ec2"
    roles = ["${aws_iam_role.IAM.id}"]
    policy_arn = "${aws_iam_policy.ecs-service-allow-ec2.arn}"
}
resource "aws_iam_policy_attachment" "ecs-service-allow-elb" {
    name = "${var.default_project_name}-${var.default_environment_name}-ecs-service-allow-elb"
    roles = ["${aws_iam_role.IAM.id}"]
    policy_arn = "${aws_iam_policy.ecs-service-allow-elb.arn}"
}
data "aws_iam_policy_document" "ecs-service-allow-ec2" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:Describe*",
      "ec2:DetachNetworkInterface",
    ]

    resources = [
      "*",
    ]
  }
}
data "aws_iam_policy_document" "ecs-service-allow-elb" {
  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]

    resources = [
      "*",
    ]
  }
}
resource "aws_iam_policy" "ecs-service-allow-ec2" {
  name        = "ecs-service-allow-ec2-IAM"
  description = "ECS Service policy to access EC2"
  policy      = "${data.aws_iam_policy_document.ecs-service-allow-ec2.json}"
}
resource "aws_iam_policy" "ecs-service-allow-elb" {
  name        = "ecs-service-allow-elb-IAM"
  description = "ECS Service policy to access ELB"
  policy      = "${data.aws_iam_policy_document.ecs-service-allow-elb.json}"
}
