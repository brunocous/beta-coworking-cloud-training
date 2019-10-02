resource "aws_iam_role" "airflow-instance-role" {
  name = "airflow-instance-role"
  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-role-s3-full-access-role-binding" {
  role       = aws_iam_role.airflow-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-role-EMR-full-access-role-binding" {
  role       = aws_iam_role.airflow-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticMapReduceFullAccess"
}

resource "aws_iam_instance_profile" "airflow-instance-profile" {
  name = "airflow-instance-profile"
  role = aws_iam_role.airflow-instance-role.name
}

resource "aws_iam_role" "emr-role" {
  name = "emr-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["elasticmapreduce.amazonaws.com",
                    "s3.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "emr-role-s3-full-access-role-binding" {
  role       = aws_iam_role.emr-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "emr-role-EMR-full-access-role-binding" {
  role       = aws_iam_role.emr-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticMapReduceFullAccess"
}

resource "aws_iam_role" "emr-ec2-role" {
  name = "emr-ec2-role"
  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_role_policy_attachment" "emr-ec2-role-s3-full-access-role-binding" {
  role       = aws_iam_role.emr-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "emr-ec2-role-EMR-full-access-role-binding" {
  role       = aws_iam_role.emr-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceFullAccess"
}

resource "aws_iam_instance_profile" "emr-ec2-instance-profile" {
  name = "emr-ec2-instance-profile"
  role = aws_iam_role.emr-ec2-role.name
}