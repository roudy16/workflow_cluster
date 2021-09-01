module "ec2_linux_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.1"

  name             = "linux_bastion"
  ami              = "ami-05dc324761386f3a9"
  instance_type    = "t3a.micro"

  key_name         = aws_key_pair.key.key_name
  subnet_id        = module.dev-vpc.public_subnets[0]
  vpc_security_group_ids = [
    aws_security_group.bastion_ssh.id,
    aws_security_group.steve_home_access.id,
  ]
}

# TODO: This is not good ssh key handling

data "local_file" "public_key" {
  filename = "/home/roudy/.ssh/id_rsa.pub"
}

data "local_file" "private_key" {
  filename = "/home/roudy/.ssh/id_rsa"
}

resource "aws_key_pair" "key" {
  public_key = data.local_file.public_key.content
}
