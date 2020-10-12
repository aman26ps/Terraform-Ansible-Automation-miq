resource "aws_security_group" "public_sg" {
    name = "public_sg"
    description = "Allow internet traffic"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
    }
    
    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "public-sg"
    }
}


resource "aws_security_group" "private_sg" {
    name = "vpc_web"
    description = "Allow ssh"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
    }
    
    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "private-sg"
    }
}
