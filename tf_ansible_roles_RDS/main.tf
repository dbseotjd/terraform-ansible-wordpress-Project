resource "aws_instance" "my_instance" {
  ami                    = "ami-0f49ee52a88cc2435"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]
  key_name               = aws_key_pair.my_sshkey.key_name


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./my_sshkey")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "deploy_wordpress_db_roles.yaml"
    destination = "/home/ubuntu/deploy_wordpress_db_roles.yaml"
  }
  provisioner "file" {
    source      = "roles"
    destination = "/home/ubuntu/"
  }
  provisioner "file" {
    source      = "group_vars"
    destination = "/home/ubuntu/"
  }

  provisioner "local-exec" {
    command = <<-EOF
	ssh-keyscan -t ssh-rsa ${self.public_ip} >> ~/.ssh/known_hosts
	echo "${self.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./my_sshkey" > inventory.ini
	echo "service_port: ${var.wp_port}" >> group_vars/all.yaml
	echo "db_pw: ${aws_db_instance.my_db_instance.password}" >> group_vars/all.yaml
	echo "db_name: ${aws_db_instance.my_db_instance.name}" >> group_vars/all.yaml
	echo "db_host: ${aws_db_instance.my_db_instance.endpoint}" >> group_vars/all.yaml
	echo "db_user: ${aws_db_instance.my_db_instance.username}" >> group_vars/all.yaml 
	sudo apt-get update
	EOF	
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini  deploy_wordpress_db_roles.yaml -b"
  }
  tags = {
    Name = "MyInstance"
  }
  depends_on = [aws_db_instance.my_db_instance]
}

resource "aws_db_instance" "my_db_instance" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "wordpress"
  username               = "admin"
  password               = "test1234"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.my_rds_sg.id]
  port                   = 3306
}


resource "aws_key_pair" "my_sshkey" {
  key_name   = "my_sshkey"
  public_key = file("./my_sshkey.pub")
}

#resource "aws_eip" "my_eip" {
#  vpc      = true
#  instance = aws_instance.my_instance.id
#}
