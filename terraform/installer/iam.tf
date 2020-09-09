resource "aws_iam_role_policy" "installerS3AccessPolicy" {
  name = "${var.projectName}-installerS3AccessPolicy"
  role = "${aws_iam_role.installerS3AccessRole.id}"

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
                "s3:GetBucketLocation"
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
 name = "${var.projectName}-installerS3AccessRole"
 permissions_boundary = "arn:aws:iam::104742821910:policy/NokiaBoundary"

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
  role = "${aws_iam_role.installerS3AccessRole.name}"
}
