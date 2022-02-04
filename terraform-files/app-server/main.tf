resource "aws_subnet" "java10x_netproject_group2_subnet_app_tf" {
  vpc_id = var.var_vpc_id_tf
  cidr_block = "10.15.1.0/24"

  tags = {
    Name = "java10x_netproject_group2_subnet_app"
  }
}

resource "aws_route_table_association" "java10x_netproject_group2_rt_association_app_tf" {
  subnet_id = aws_subnet.java10x_netproject_group2_subnet_app_tf.id
  route_table_id = var.var_rt_tf
}

resource "aws_network_acl" "java10x_netproject_group2_nacl_app_tf"{
  vpc_id = var.var_vpc_id_tf

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = var.var_local_ip_tf
    from_port = 22
    to_port = 22
  }
  ingress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "10.15.4.0/24"
    from_port = 8080
    to_port = 8080
  }
  ingress {
    protocol = "tcp"
    rule_no = 1000
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }


  egress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "10.15.2.0/24"
    from_port = 3306
    to_port = 3306
  }
  egress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }
  egress {
    protocol = "tcp"
    rule_no = 300
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }
  egress {
    protocol = "tcp"
    rule_no = 1000
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }


  subnet_ids = [aws_subnet.java10x_netproject_group2_subnet_app_tf.id]

  tags = {
    Name = "java10x_netproject_group2_nacl_app"
  }
}

resource "aws_security_group" "java10x_netproject_group2_sg_app_tf" {
  name = "java10x_netproject_group2_sg_app"
  vpc_id = var.var_vpc_id_tf

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [var.var_local_ip_tf]
  }
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = ["10.15.4.0/24"]
  }
  egress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_blocks = ["10.15.2.0/24"]
  }

  tags = {
    Name = "java10x_netproject_group2_sg_app"
  }
}

resource "aws_instance" "java10x_netproject_group2_instance_app_tf" {
    ami = var.var_ami_linux_ubuntu_tf
    instance_type = "t2.micro"
    key_name = "cyber-10x-group2"

    subnet_id = aws_subnet.java10x_netproject_group2_subnet_app_tf.id
    vpc_security_group_ids = [aws_security_group.java10x_netproject_group2_sg_app_tf.id]
    associate_public_ip_address = true

    count = 3
    depends_on = [var.var_db_instance_tf]

    connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = file("/home/vagrant/.ssh/cyber-10x-group2.pem")
    }

    provisioner "remote-exec" {
        inline = [
          "ls -la"
        ]
    }

    provisioner "local-exec" {
      working_dir = "./ansible"
      command = "ansible-playbook -i ${self.public_ip}, -u ubuntu playbook-app.yml"
      environment = { // Add things to the environment(?)
        ANSIBLE_CONFIG = "${abspath(path.root)}/ansible" // path.root = terraform main directory, abspath is a function that gives us the absolute path
      }
    }


      /*
    provisioner "file" {
      source = "./init-scripts/docker-install.sh"
      destination = "/home/ubuntu/docker-install.sh"
    } */

    provisioner "file" {
      source = "./init-scripts/application.properties"
      destination = "/home/ubuntu/application.properties"
    }

      /*
    provisioner "remote-exec" {
      inline = [
        "chmod 744 /home/ubuntu/docker-install.sh",
        "/home/ubuntu/docker-install.sh",
      ]
    } */

    tags = {
      Name = "java10x_netproject_group2_server_app_${count.index}"
    }
}

resource "aws_route53_record" "java10x_netproject_group2_r53_record_app_tf" {
  zone_id = var.var_zone_id_tf
  name = "app"
  type = "A"
  ttl = "30"

  records = aws_instance.java10x_netproject_group2_instance_app_tf.*.private_ip
}
