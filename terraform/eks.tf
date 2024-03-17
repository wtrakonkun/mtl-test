provider "aws" {
    profile = "awsprofiletest"
    region = var.region
}

resource "aws_eks_cluster" "demo-eks" {
    name     = "${var.app_name}-eks"
    role_arn = aws_iam_role.master.arn

    vpc_config {
        # endpoint_private_access = true
        # endpoint_public_access =  false
        security_group_ids = [aws_security_group.eks_cluster.id]
        subnet_ids = [aws_subnet.public[0].id, aws_subnet.public[1].id]
    }

    tags = {
        Name = "${var.app_name}-eks"
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
        aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
        aws_security_group.eks_cluster
    ]
}

resource "aws_eks_node_group" "node-grp" {
    cluster_name    = aws_eks_cluster.demo-eks.name
    node_group_name = "${var.app_name}-node-group"
    node_role_arn   = aws_iam_role.worker.arn
    subnet_ids      = [aws_subnet.public[0].id, aws_subnet.public[1].id]
    capacity_type   = "ON_DEMAND"
    disk_size       = 20
    instance_types  = ["t3.small"]

    remote_access {
        ec2_ssh_key               = aws_key_pair.generated_key.key_name
        source_security_group_ids = [aws_security_group.allow_tls.id]
    }

    scaling_config {
        desired_size = 2
        max_size     = 2
        min_size     = 1
    }

    tags = {
        Name = "${var.app_name}-node-group"
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
        aws_key_pair.generated_key,
    ]
}
