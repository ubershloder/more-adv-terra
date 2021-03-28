resource "aws_instance" "test" {
  ami                         = "ami-0de9f803fcac87f46"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pub_with_asg.id
  vpc_security_group_ids      = [aws_security_group.pub_SG.id]
  key_name                    = "uber"
  associate_public_ip_address = true

  depends_on = [
    aws_efs_mount_target.mount
  ]
  connection {
    type        = "ssh"
    host        = aws_instance.test.public_ip
    user        = "ec2-user"
    port        = 22
    agent       = true
    private_key = file("~/uber.pem")
  }
  provisioner "file" {
source = "/home/ubersholder/terraform/DB+EC2+ASG/setup.sh"
destination = "/tmp/setup.sh"
}
  provisioner "remote-exec" {
    inline = [
  "sleep 30",
  "sudo chmod +x /tmp/setup.sh",
  "cd /tmp",
  "./setup.sh"
    ]
  }
  tags = {
    Name = "public instance"
  }
}
resource "aws_ami_from_instance" "uberami" {
  name               = "AMIforme"
  source_instance_id = aws_instance.test.id
}

