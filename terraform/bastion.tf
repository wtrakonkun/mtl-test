resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "eks-keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.generated_key.key_name}.pem"
  content = tls_private_key.keypair.private_key_pem
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "bastion-sg"
  vpc_id      = aws_vpc.aws-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    //vpc block
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group_rule" "bastion-eks-ingress-vpc" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "bastion-eks-ingress-vpc"
  from_port         = 22
  protocol          = "-1"
  security_group_id = aws_security_group.bastion-sg.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_iam_role" "ec2-default-role" {
  name               = "EC2DefaultRole"
  assume_role_policy = "${data.aws_iam_policy_document.ec2-default-role-policy.json}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
    name = "EC2DefaultRole"
    role = aws_iam_role.ec2-default-role.name
}

data "aws_iam_policy_document" "ec2-default-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2-default-role-ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2-default-role.name
}

resource "aws_iam_role_policy" "ec2-access-eks" {
  name = "ec2-access-eks"
  role = aws_iam_role.ec2-default-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "${aws_eks_cluster.demo-eks.arn}"
      ],
      "Action": [
            "eks:DescribeCluster"
        ]
    }
  ]
}
POLICY
}

resource "aws_instance" "instance_ec2" {
    ami           = "ami-015f72d56355ebc27"
    instance_type = "t2.micro"
    key_name      = aws_key_pair.generated_key.key_name
    subnet_id       = aws_subnet.public[0].id
    # associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.bastion-sg.id]
    disable_api_termination = true
    iam_instance_profile = aws_iam_role.ec2-default-role.name
    user_data = filebase64("bastion_user_data.sh")

    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }

    tags = {
        Name = "bastion-eks"
    }
}