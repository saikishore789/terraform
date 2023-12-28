module "networking" {
  source = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  ap_availability_zone = var.ap_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "security_group" {
  source = "./security_groups"
  vpc_id = module.networking.dev_proj_1_vpc_id
  ec2_sg_name = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "jenkins" {
  source = "./jenkins"
  ami_id = var.ec2_ami_id
  public_key = var.public_key
  instance_type = "t2.medium"
  tag_name = "Jenkins:Ubuntu Linux EC2"
  subnet_id = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins = [module.security_group.sg_ec2_jenkins_port_8080, module.security_group.sg_ec2_sg_ssh_http_id]
  enable_public_ip_address = true
  user_data_install_jenkins = templatefile("./jenkins-userdata/jenkins-installer.sh", {})
}

