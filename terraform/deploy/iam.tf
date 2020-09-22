# deprectaed since object is pre-esxisting in AWS
# using import method to reference object
#
resource "aws_iam_role" "eksClusterRole" {
  name                 = "${var.eksClusterName}-eksClusterRole"
  permissions_boundary = "arn:aws:iam::${var.aws-account}:policy/NokiaBoundary"

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

# resource "aws_iam_role" "eksClusterRole" {
#   # fix hard-coded value later
#   permissions_boundary = "arn:aws:iam::${var.aws-account}:policy/NokiaBoundary"
# #  instance config imported from existing object in AWS
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

resource "aws_iam_role_policy_attachment" "eksClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksClusterRole.name
}

resource "aws_iam_role_policy_attachment" "eksServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eksClusterRole.name
}

# deprecated since object is pre-existing in AWS
# using import method to reference object
#
resource "aws_iam_role" "eksWorkerRole" {
  name                 = "${var.eksClusterName}-eksWorkerRole"
  permissions_boundary = "arn:aws:iam::${var.aws-account}:policy/NokiaBoundary"

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

# resource "aws_iam_role" "eksWorkerRole" {
#     # fix hard-coded value later
#   permissions_boundary = "arn:aws:iam::${var.aws-account}:policy/NokiaBoundary"
# #   instance config imported from existing object in AWS
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

resource "aws_iam_role_policy_attachment" "eksWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksWorkerRole.name
}

resource "aws_iam_role_policy_attachment" "eksWorkerCNIPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksWorkerRole.name
}

resource "aws_iam_role_policy_attachment" "eksWorkerContainerRegistryPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksWorkerRole.name
}

resource "aws_iam_instance_profile" "eksWorkerProfile" {
  name = "${var.eksClusterName}-eksOpsProfile"
  role = aws_iam_role.eksWorkerRole.name
}

# resource "aws_iam_instance_profile" "eksWorkerProfile" {
# #   instance config imported from existing object in AWS
# }

resource "aws_iam_role_policy" "installerS3AccessPolicy" {
  name = "${var.projectName}-installerS3AccessPolicy"
  role = aws_iam_role.installerS3AccessRole.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketPolicyStatus",
                "s3:GetBucketPublicAccessBlock",
                "s3:ListBucketByTags",
                "s3:GetLifecycleConfiguration",
                "s3:ListBucketMultipartUploads",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:GetBucketWebsite",
                "s3:ListBucketVersions",
                "s3:GetBucketLogging",
                "s3:ListBucket",
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetBucketNotification",
                "s3:GetBucketPolicy",
                "s3:GetReplicationConfiguration",
                "s3:GetEncryptionConfiguration",
                "s3:DescribeJob",
                "s3:GetBucketRequestPayment",
                "s3:GetBucketCORS",
                "s3:GetAnalyticsConfiguration",
                "s3:GetMetricsConfiguration",
                "s3:GetBucketLocation",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::*",
                "arn:aws:s3:*:*:job/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersion",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": "arn:aws:s3:::*/*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListJobs",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        }
    ]
}
POLICY

}

resource "aws_iam_role" "installerS3AccessRole" {
  name                 = "${var.projectName}-installerS3AccessRole"
  permissions_boundary = "arn:aws:iam::${var.aws-account}:policy/NokiaBoundary"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

}

resource "aws_iam_instance_profile" "installerS3AccessInstanceProfile" {
  name = "${var.projectName}-installerS3AccessInstanceProfile"
  role = aws_iam_role.installerS3AccessRole.name
}

