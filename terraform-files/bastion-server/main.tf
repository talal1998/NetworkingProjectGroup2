# Bastion Subnet
resource "aws_subnet" "java10x_netproject_group2_subnet_bastion_tf" {
    vpc_id = var.var_vpc_id_tf
    cidr_block = "10.15.3.0/24"

    tags = {
      Name = "java10x_netproject_group2_subnet_bastion"
    }
}

# Bastion Route Association
resource "aws_route_table_association" "java10x_netproject_group2_rt_assoc_bastion_tf" {
    subnet_id = aws_subnet.java10x_netproject_group2_subnet_bastion_tf.id
    route_table_id = var.var_rt_id_tf
}

# Bastion NACL
resource "aws_network_acl" "java10x_netproject_group2_nacl_bastion_tf" {
    vpc_id = var.var_vpc_id_tf

    # Inbound Rules
    ingress {
      rule_no = 100
      action = "allow"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_block = var.var_local_ip_tf
    }

    ingress {
      rule_no = 1000
      action = "allow"
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      cidr_block = "10.15.2.0/24"
    }

# Outbound Rules
    egress {
      rule_no = 100
      action = "allow"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_block = "10.15.2.0/24"
    }

    egress {
      rule_no = 1100
      action = "allow"
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      cidr_block = "0.0.0.0/0"
    }

    tags = {
      Name = "java10x_netproject_group2_nacl_bastion"
    }
}

# Bastion SG

resource "aws_security_group" "java10x_netproject_group2_sg_bastion_tf" {
    name = "java10x_netproject_group2_sg_bastion"
    vpc_id = var.var_vpc_id_tf

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.var_local_ip_tf]
    }

    egress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.15.2.0/24"]
    }

    egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "java10x_netproject_group2_sg_bastion"
    }
}

resource "aws_instance" "java10x_netproject_group2_server_bastion_tf" {
    ami = var.var_ami_linux_ubuntu_tf
    instance_type = "t2.micro"
    key_name = "cyber-10x-group2"

    subnet_id = aws_subnet.java10x_netproject_group2_subnet_bastion_tf.id
    vpc_security_group_ids = [aws_security_group.java10x_netproject_group2_sg_bastion_tf.id]
    associate_public_ip_address = true

    tags = {
      Name = "java10x_netproject_group2_server_bastion"
    }
}

resource "aws_route53_record" "java10x_netproject_group2_r53_record_bastion_tf" {
  zone_id = var.var_zone_id_tf
  name = "bastion"
  type = "A"
  ttl = "30"

  records = [aws_instance.java10x_netproject_group2_server_bastion_tf.private_ip]
}
