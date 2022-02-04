# Provider and Region
provider "aws" {
  region = var.var_region_name_tf
}

# VPC
resource "aws_vpc" "java10x_netproject_group2_vpc_tf" {
    cidr_block = "10.15.0.0/16"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
       Name = "java10x_netproject_group2_vpc"
    }
}

resource "aws_route53_zone" "java10x_netproject_group2_r53_zone_tf" {
  name = var.var_zone_name

  vpc {
    vpc_id = aws_vpc.java10x_netproject_group2_vpc_tf.id
  }

  tags = {
    Name = "java10x_netproject_group2_r53_zone"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "java10x_netproject_group2_igw_tf" {
    vpc_id = aws_vpc.java10x_netproject_group2_vpc_tf.id

    tags = {
      Name = "java10x_netproject_group2_igw"
    }
}

# Route Table
resource "aws_route_table" "java10x_netproject_group2_rt_tf" {
    vpc_id = aws_vpc.java10x_netproject_group2_vpc_tf.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.java10x_netproject_group2_igw_tf.id
    }

    tags = {
      Name = "java10x_netproject_group2_rt"
    }
}

module "app_module" {
  source = "./app-server"
  var_db_instance_tf = module.db_module.output_db
  var_vpc_id_tf = aws_vpc.java10x_netproject_group2_vpc_tf.id
  var_ami_linux_ubuntu_tf = var.var_ami_linux_ubuntu_tf
  var_rt_tf = aws_route_table.java10x_netproject_group2_rt_tf.id
  var_zone_id_tf = aws_route53_zone.java10x_netproject_group2_r53_zone_tf.id
  var_local_ip_tf = var.var_local_ip_tf
}

module "db_module" {
  source = "./db-server"
  //var_db_instance_tf = module.db_module.output_db
  var_vpc_id_tf = aws_vpc.java10x_netproject_group2_vpc_tf.id
  var_zone_id_tf = aws_route53_zone.java10x_netproject_group2_r53_zone_tf.id
}

module "bastion_module" {
  source = "./bastion-server"
  var_ami_linux_ubuntu_tf = var.var_ami_linux_ubuntu_tf
  var_vpc_id_tf = aws_vpc.java10x_netproject_group2_vpc_tf.id
  var_zone_id_tf = aws_route53_zone.java10x_netproject_group2_r53_zone_tf.id
  var_rt_id_tf = aws_route_table.java10x_netproject_group2_rt_tf.id
  var_local_ip_tf = var.var_local_ip_tf
}

module "proxy_module" {
  source = "./proxy-server"
  var_local_ip_tf = var.var_local_ip_tf
  var_app_id_tf = module.app_module.output_webserver_id

  var_ami_proxy_tf = var.var_ami_proxy_tf
  var_proxy_subnet_ip_tf = var.var_proxy_subnet_ip_tf
  var_key_file_path_tf = var.var_key_file_path_tf

  var_zone_id_tf = aws_route53_zone.java10x_netproject_group2_r53_zone_tf.id
  var_public_route_table_id_tf = aws_route_table.java10x_netproject_group2_rt_tf.id
  var_vpc_id_tf = aws_vpc.java10x_netproject_group2_vpc_tf.id
}
