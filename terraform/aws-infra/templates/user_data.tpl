#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1
# Get the latest CloudFormation package
echo "Installing aws-cfn"
yum install -y aws-cfn-bootstrap
# Start cfn-init
/opt/aws/bin/cfn-init -v -c install --stack ${fake_stack_id} --resource EC2Instance --region ${aws_region}
# Download and unzip the Movielens dataset
wget http://files.grouplens.org/datasets/movielens/ml-latest.zip && unzip ml-latest.zip
# Upload the movielens dataset files to the S3 bucket
aws s3 cp ml-latest s3://${datalake_bucket} --recursive
# Install git
sudo yum install -y git
# Clone the git repository
git clone https://github.com/aws-samples/aws-concurrent-data-orchestration-pipeline-emr-livy.git
sudo pip install boto3
# Install airflow using pip
echo "Install Apache Airflow"
sudo SLUGIFY_USES_TEXT_UNIDECODE=yes pip install -U apache-airflow
# Encrypt connection passwords in metadata db
sudo AIRFLOW_GPL_UNIDECODE=yes pip install apache-airflow[crypto]
# Postgres operators and hook, support as an Airflow backend
sudo AIRFLOW_GPL_UNIDECODE=yes pip install apache-airflow[postgres]
sudo -H pip install six==1.10.0
sudo pip install --upgrade six
sudo pip install markupsafe
sudo pip install --upgrade MarkupSafe
echo 'export PATH=/usr/local/bin:$PATH' >> /root/.bash_profile
source /root/.bash_profile
# Initialize Airflow
airflow initdb
# Update the RDS connection in the Airflow Config file
sed -i '/sql_alchemy_conn/s/^/#/g' ~/airflow/airflow.cfg
sed -i '/sql_alchemy_conn/ a sql_alchemy_conn = postgresql://airflow:${db_password}@${db_endpoint}/airflowdb' ~/airflow/airflow.cfg
# Update the type of executor in the Airflow Config file
sed -i '/executor = SequentialExecutor/s/^/#/g' ~/airflow/airflow.cfg
sed -i '/executor = SequentialExecutor/ a executor = LocalExecutor' ~/airflow/airflow.cfg
airflow initdb
# Move all the files to the ~/airflow directory. The Airflow config file is setup to hold all the DAG related files in the ~/airflow/ folder.
mv aws-concurrent-data-orchestration-pipeline-emr-livy/* ~/airflow/
# Delete the higher-level git repository directory
rm -rf aws-concurrent-data-orchestration-pipeline-emr-livy
# Replace the name of the S3 bucket in each of the .scala files. CHANGE THE HIGHLIGHTED PORTION BELOW TO THE NAME OF THE S3 BUCKET YOU CREATED IN STEP 1. The below command replaces the instance of the string ‘<s3-bucket>’ in each of the scripts to the name of the actual bucket.
sed -i 's/<s3-bucket>/${datalake_bucket}/g' /root/airflow/dags/transform/*
# Run Airflow webserver
airflow webserver