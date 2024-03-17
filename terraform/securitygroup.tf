resource "aws_security_group" "allow_tls" {
    name_prefix   = "allow_tls_"
    description   = "Allow TLS inbound traffic"
    vpc_id        = aws_vpc.aws-vpc.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group_rule" "demo-eks-ingress-bastion-workernode" {
    source_security_group_id = aws_security_group.bastion-sg.id
    description       = "Allow bastion to workern node"
    from_port         = 22
    protocol          = "tcp"
    security_group_id = aws_security_group.allow_tls.id
    to_port           = 22
    type              = "ingress"
    depends_on = [
        aws_security_group.bastion-sg
    ]
}

resource "aws_security_group" "eks_cluster" {
  name        = "${var.app_name}-eks-cluster"
  vpc_id      = aws_vpc.aws-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "demo-eks-ingress-bastion-https" {
    source_security_group_id = aws_security_group.bastion-sg.id
    description       = "Allow bastion to communicate with the cluster API Server"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.eks_cluster.id
    to_port           = 443
    type              = "ingress"
    depends_on = [
        aws_security_group.bastion-sg
    ]
}