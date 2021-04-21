data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}
resource "aws_instance" "uber" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
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
    host        = aws_instance.uber.public_ip
    user        = "ec2-user"
    port        = 22
    agent       = true
    private_key = file("~/uber.pem")
### provide your key in the way u like and if changing os change user in connection below ###
  }
  provisioner "file" {
    source      = "/home/ubersholder/terraform/DB+EC2+ASG/setup.sh"
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
  source_instance_id = aws_instance.uber.id
}
