/* data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
} */




# Create an SCP that denies the creation of S3 buckets that starts with 'inception-' name
resource "aws_organizations_policy" "deny_public_s3_with_name_inception" {
  content = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Deny",
        "Action": [
          "s3:CreateBucket"
        ],
        "Resource": [
        "arn:aws:s3:::inception-*"
      ]
      }
    ]
  })


  description = "Prevent the creation of public S3 buckets"
  name = "deny_public_s3_with_name_inception-"
  /* name_prefix = "DenyS3withinception-" */
  type        = "SERVICE_CONTROL_POLICY"
}

# Attach the SCP to the root of the organization
resource "aws_organizations_policy_attachment" "deny_public_s3_with_name_inception_attachment" {
  policy_id = aws_organizations_policy.deny_public_s3_with_name_inception.id
  target_id = "ou-ldp3-zmega68y"
}