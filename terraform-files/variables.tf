variable "var_region_name_tf" {
  default = "eu-west-1"
}

variable "var_zone_name" {
  default = "group2.cyber"
}

variable "var_ami_linux_ubuntu_tf" {
  default = "ami-08ca3fed11864d6bb"
}

variable "var_ami_proxy_tf" {
  description = "ami-07465d8da0c71756a"
}


variable "var_proxy_subnet_ip_tf" {
  default = "10.15.4.0/24"
}

variable "var_key_file_path_tf" {
  default = "/home/vagrant/.ssh/cyber-10x-group2.pem"
}
