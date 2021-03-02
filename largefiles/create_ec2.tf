provider "aws" {
  version = "~> 3.0"
  access_key = "AKIA4YSPNRPDSRSQLKX5"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_security_group" "sec_cred" {
  name= "allow ssh connection"
  description= "allow ssh inbound traffic"

  ingress {
    description= "ssh into vpc"
    from_port= 22
    to_port= 22
    protocol= "tcp"
    cidr_blocks= ["0.0.0.0/0"]
}

  ingress {
    description= "http into vpc"
    from_port= 80
    to_port= 80
    protocol= "tcp"
    cidr_blocks= ["0.0.0.0/0"]
}

  egress {
    description= "outbound allowed"
    from_port= 0
    to_port= 65535
    protocol= "tcp"
    cidr_blocks= ["0.0.0.0/0"]
}
}
resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  key_name= "feb-mum"
  vpc_security_group_ids= [aws_security_group.sec_cred.id]
provisioner "remote-exec" {
     inline= [
       "sudo amazon-linux-extras install -y nginx1.12",
       "sudo systemctl start nginx"
]
}
connection {
    type= "ssh"
    user= "ec2-user"
    private_key= file("./feb-mum.pem")
    host= self.public_ip
}

}

