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
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /efs",
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.mount.ip_address}:/  /efs",
      "sudo amazon-linux-extras install nginx1 -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
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
