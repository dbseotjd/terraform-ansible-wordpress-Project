resource "aws_security_group" "my_sg_web" {
  name = "allow-web"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.wp_port
    to_port     = var.wp_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
