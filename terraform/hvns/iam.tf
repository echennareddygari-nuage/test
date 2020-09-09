# deprectaed since object is pre-esxisting in AWS
# using import method to reference object
#
#resource "aws_iam_role" "eksClusterRole" {
#  name = "eksClusterRole"
#
#  assume_role_policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "eks.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#POLICY
#}

resource "aws_iam_role" "eksClusterRole" {
  # fix hard-coded value later
  permissions_boundary = "arn:aws:iam::104742821910:policy/NokiaBoundary"
#  instance config imported from existing object in AWS
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eksClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eksClusterRole.name}"
}

resource "aws_iam_role_policy_attachment" "eksServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eksClusterRole.name}"
}

# deprecated since object is pre-existing in AWS
# using import method to reference object
#
#resource "aws_iam_role" "eksWorkerRole" {
#  name = "eksWorkerRole"
#
#  assume_role_policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "ec2.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#POLICY
#}

resource "aws_iam_role" "eksWorkerRole" {
    # fix hard-coded value later
  permissions_boundary = "arn:aws:iam::104742821910:policy/NokiaBoundary"
#   instance config imported from existing object in AWS
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eksWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eksWorkerRole.name}"
}

resource "aws_iam_role_policy_attachment" "eksWorkerCNIPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eksWorkerRole.name}"
}

resource "aws_iam_role_policy_attachment" "eksWorkerContainerRegistryPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eksWorkerRole.name}"
}


#resource "aws_iam_instance_profile" "eksWorkerProfile" {
#  name = "eksOpsProfile"
#  role = "${aws_iam_role.eksWorkerRole.name}"
#}

resource "aws_iam_instance_profile" "eksWorkerProfile" {
#   instance config imported from existing object in AWS
}