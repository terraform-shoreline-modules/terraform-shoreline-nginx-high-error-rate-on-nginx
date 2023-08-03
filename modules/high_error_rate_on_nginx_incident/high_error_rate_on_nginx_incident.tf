resource "shoreline_notebook" "high_error_rate_on_nginx_incident" {
  name       = "high_error_rate_on_nginx_incident"
  data       = file("${path.module}/data/high_error_rate_on_nginx_incident.json")
  depends_on = [shoreline_action.invoke_config_vars,shoreline_action.invoke_ec2_launch_nginx,shoreline_action.invoke_aws_describe_instances,shoreline_action.invoke_register_targets]
}

resource "shoreline_file" "config_vars" {
  name             = "config_vars"
  input_file       = "${path.module}/data/config_vars.sh"
  md5              = filemd5("${path.module}/data/config_vars.sh")
  description      = "Define variables"
  destination_path = "/agent/scripts/config_vars.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ec2_launch_nginx" {
  name             = "ec2_launch_nginx"
  input_file       = "${path.module}/data/ec2_launch_nginx.sh"
  md5              = filemd5("${path.module}/data/ec2_launch_nginx.sh")
  description      = "Add more instances to serve increased load"
  destination_path = "/agent/scripts/ec2_launch_nginx.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "aws_describe_instances" {
  name             = "aws_describe_instances"
  input_file       = "${path.module}/data/aws_describe_instances.sh"
  md5              = filemd5("${path.module}/data/aws_describe_instances.sh")
  description      = "Get the IDs of the new instances"
  destination_path = "/agent/scripts/aws_describe_instances.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "register_targets" {
  name             = "register_targets"
  input_file       = "${path.module}/data/register_targets.sh"
  md5              = filemd5("${path.module}/data/register_targets.sh")
  description      = "Register the new instances with the target group"
  destination_path = "/agent/scripts/register_targets.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_config_vars" {
  name        = "invoke_config_vars"
  description = "Define variables"
  command     = "`chmod +x /agent/scripts/config_vars.sh && /agent/scripts/config_vars.sh`"
  params      = ["LAUNCH_TEMPLATE_ID","INSTANCE_TYPE","TARGET_GROUP_ARN","NUMBER_OF_INSTANCES"]
  file_deps   = ["config_vars"]
  enabled     = true
  depends_on  = [shoreline_file.config_vars]
}

resource "shoreline_action" "invoke_ec2_launch_nginx" {
  name        = "invoke_ec2_launch_nginx"
  description = "Add more instances to serve increased load"
  command     = "`chmod +x /agent/scripts/ec2_launch_nginx.sh && /agent/scripts/ec2_launch_nginx.sh`"
  params      = ["LAUNCH_TEMPLATE_ID","INSTANCE_TYPE"]
  file_deps   = ["ec2_launch_nginx"]
  enabled     = true
  depends_on  = [shoreline_file.ec2_launch_nginx]
}

resource "shoreline_action" "invoke_aws_describe_instances" {
  name        = "invoke_aws_describe_instances"
  description = "Get the IDs of the new instances"
  command     = "`chmod +x /agent/scripts/aws_describe_instances.sh && /agent/scripts/aws_describe_instances.sh`"
  params      = []
  file_deps   = ["aws_describe_instances"]
  enabled     = true
  depends_on  = [shoreline_file.aws_describe_instances]
}

resource "shoreline_action" "invoke_register_targets" {
  name        = "invoke_register_targets"
  description = "Register the new instances with the target group"
  command     = "`chmod +x /agent/scripts/register_targets.sh && /agent/scripts/register_targets.sh`"
  params      = ["TARGET_GROUP_ARN"]
  file_deps   = ["register_targets"]
  enabled     = true
  depends_on  = [shoreline_file.register_targets]
}

