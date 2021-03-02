provider "aws" {
  version = "~> 3.0"
  access_key = "AKIA4YSPNRPDSRSQLKX5"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_instance" "base" {
  ami = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  key_name= "feb-mum"
# provisioner "local-exec" {
#    command = "echo ${aws_instance.base.private_ip} >>private_ip.txt"
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
