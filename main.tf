variable "build_id" {
  type    = string
  default = "1"

}

# get default vpc
data "aws_vpc" "default_vpc" {
  default = true
}


# get a security group by name

data "aws_security_group" "web" {
  vpc_id = "vpc-00d94060a9f821f54"
  name   = "launch-wizard-2"
}

# get ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.web.id]
  key_name               = "my_idrsa"
  tags = {
    Name = "web"
  }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("c:/Users/segum01/.ssh/my_idrsa.pem")
        host        = aws_instance.web.public_ip
    }
    provisioner "remote-exec" {
        script = "./installbrowny.sh"

    }


}

# resource "null_resource" "test" {
#   triggers = {
#     build_id = var.build_id
#   }
#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("c:/Users/segum01/.ssh/my_idrsa.pem")
#     host        = aws_instance.web.public_ip
#   }
#   provisioner "remote-exec" {
#     script = "./installbrowny.sh"

#   }

# }

output "browny" {
  value = "http://${aws_instance.web.public_ip}/browny"
}

# output "repairs" {
#   value = "http://${aws_instance.web.public_ip}/repairs"
# }