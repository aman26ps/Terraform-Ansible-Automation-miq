resource "aws_instance" "public-instance" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "test"
    vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

## Unable to run the following block
   
    provisioner "remote-exec" {
      inline = ["hostname"]

      connection {
        type        = "ssh"
        host        = self.public_ip
        user        = "ec2-user"
        private_key = "var.ssh_private_key"
      }
    }

    provisioner "local-exec" {
      command = "ansible-playbook --private-key ${var.ssh_private_key} ansible/main.yaml -i remote-host"
      environment = {
        PUBLIC_IP = self.public_ip
      }
    }

    tags = {
        Name = "public-instance"
    }

}

resource "aws_instance" "private-instance" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "test"
    vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
    subnet_id = "${aws_subnet.us-east-1a-private.id}"
    associate_public_ip_address = false
    source_dest_check = false


    tags = {
        Name = "private-instance"
    }
}

