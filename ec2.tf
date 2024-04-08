resource "aws_instance" "web1" {
  ami           = var.AMI
  instance_type = "t2.micro"
  # VPC
  subnet_id = aws_subnet.terraform-subnet-public-1.id
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  # the Public SSH key
  key_name = "mykey"
  # nginx installation

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y",
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo nginx -v"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("mykey.pem")
      host        = self.public_ip
    }
  }
}