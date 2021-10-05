resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow rds inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description     = "rds from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.devapi.id]

  }
  ingress {
    description     = "rds from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.devapp.id]

  }
  ingress {
    description     = "rds from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]

  }
  ingress {
    description     = "rds from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins.id]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-rds-sg"
  }
}

#rds
resource "aws_db_subnet_group" "db-subnet" {
  name = "dev-rds"
  # vpc_id      = "aws_vpc.dev"
  subnet_ids = [aws_subnet.data[0].id, aws_subnet.data[1].id, aws_subnet.data[2].id]
  # availability_zone       = ["${us-east-2a}","${us-east-2b}",${us-east-2c}]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "my-test-sql" {
  instance_class          = "db.t3.micro"
  engine                  = "mysql"
  engine_version          = "5.7"
  multi_az                = true
  storage_type            = "gp2"
  allocated_storage       = 20
  name                    = "mytestrds"
  username                = "dev_apiuser"
  password                = "dev_apiuser"
  apply_immediately       = "true"
  backup_retention_period = 10
  backup_window           = "09:46-10:16"
  db_subnet_group_name    = aws_db_subnet_group.db-subnet.id
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]

}