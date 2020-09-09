resource "aws_eks_cluster" "eksCluster" {
  name            = "${var.eksClusterName}"
  role_arn        = "${aws_iam_role.eksClusterRole.arn}"
  version         = "${var.eksVersion}"
  vpc_config {
    security_group_ids = ["${aws_security_group.eksClusterSG.id}"]
    subnet_ids         = ["${aws_subnet.vpcHostedOps1a.id}","${aws_subnet.vpcHostedOps1b.id}","${aws_subnet.vpcHostedOps1c.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eksClusterPolicy",
    "aws_iam_role_policy_attachment.eksServicePolicy",
  ]
}

#data "aws_ami" "eksWorker" {
#  filter {
#    name   = "name"
#    values = ["amazon-eks-node-v*"]
#  }
#
#  most_recent = true
#  owners      = ["602401143452"] # Amazon EKS AMI Account ID
#}

locals {
    eksUserData = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eksCluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eksCluster.certificate_authority.0.data}' '${var.eksClusterName}'
USERDATA
}

resource "aws_launch_configuration" "eksCluster" {
    associate_public_ip_address = true
    iam_instance_profile        = "${aws_iam_instance_profile.eksWorkerProfile.name}"
    image_id                    = "${var.eksWorkerAMI}"
    instance_type               = "${var.eksInstanceType}"
    name_prefix                 = "${var.eksClusterName}"
    security_groups             = ["${aws_security_group.eksWorkerSG.id}"]
    user_data_base64            = "${base64encode(local.eksUserData)}"
    key_name                    = "${var.awsKeyName}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "eksCluster" {
    desired_capacity     = 3
    launch_configuration = "${aws_launch_configuration.eksCluster.id}"
    max_size             = 5
    min_size             = 1
    name                 = "${var.eksClusterName}"
    vpc_zone_identifier  = ["${aws_subnet.vpcHostedOps1a.id}","${aws_subnet.vpcHostedOps1b.id}","${aws_subnet.vpcHostedOps1c.id}"]

    tag {
        key                 = "Name"
        value               = "${var.eksClusterName}"
        propagate_at_launch = true
    }

    tag {
        key                 = "Project"
        value               = "${var.projectName}"
        propagate_at_launch = true
    }

    tag {
        key                 = "kubernetes.io/cluster/${var.eksClusterName}"
        value               = "owned"
        propagate_at_launch = true
    }
}


locals {
  CONFIG-MAP-AWS-AUTH = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eksWorkerRole.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config_map_aws_auth" {
  value = "${local.CONFIG-MAP-AWS-AUTH}"
}

