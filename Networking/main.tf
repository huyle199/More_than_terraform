#Networking main


resource "aws_security_group" "huy_sg"{
  name = "public_sg"
  description = "Security group for public access"
  vpc_id = aws_vpc.huy_vpc.id
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_ip]
  }
  egress{
    from_port = 0
    to_port = 0
    #protocol -1 is basically all protocols
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
