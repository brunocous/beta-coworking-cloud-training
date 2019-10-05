#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo apt update
sudo apt install -y python3-pip awscli unzip
sudo pip3 install boto3

cd ~
git clone https://github.com/aws-samples/aws-concurrent-data-orchestration-pipeline-emr-livy.git

echo "Install Apache Airflow"
sudo SLUGIFY_USES_TEXT_UNIDECODE=yes pip3 install -U apache-airflow
# Encrypt connection passwords in metadata db
sudo AIRFLOW_GPL_UNIDECODE=yes pip3 install apache-airflow[crypto]
# Postgres operators and hook, support as an Airflow backend
sudo AIRFLOW_GPL_UNIDECODE=yes pip3 install apache-airflow[postgres]

# Get some data
wget http://files.grouplens.org/datasets/movielens/ml-latest.zip && unzip ml-latest.zip
# Upload the movielens dataset files to the S3 bucket
aws s3 cp ml-latest s3://${datalake_bucket} --recursive

# Clone the git repository
git clone https://github.com/aws-samples/aws-concurrent-data-orchestration-pipeline-emr-livy.git

sudo -H pip3 install six==1.10.0
sudo pip3 install --upgrade six
sudo pip3 install markupsafe
sudo pip3 install --upgrade MarkupSafe
echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bash_profile
source /.bash_profile
# Initialize Airflow
airflow initdb
# Update the RDS connection in the Airflow Config file
sed -i '/sql_alchemy_conn/s/^/#/g' ~/airflow/airflow.cfg
sed -i '/sql_alchemy_conn/ a sql_alchemy_conn = postgresql://airflow:${db_password}@${db_endpoint}/airflowdb' ~/airflow/airflow.cfg
# Update the type of executor in the Airflow Config file
sed -i '/executor = SequentialExecutor/s/^/#/g' ~/airflow/airflow.cfg
sed -i '/executor = SequentialExecutor/ a executor = LocalExecutor' ~/airflow/airflow.cfg
cat ~/airflow/airflow.cfg
airflow initdb
# Move all the files to the ~/airflow directory. The Airflow config file is setup to hold all the DAG related files in the ~/airflow/ folder.
mv aws-concurrent-data-orchestration-pipeline-emr-livy/* ~/airflow/
# Delete the higher-level git repository directory
rm -rf aws-concurrent-data-orchestration-pipeline-emr-livy
# Replace the name of the S3 bucket in each of the .scala files. CHANGE THE HIGHLIGHTED PORTION BELOW TO THE NAME OF THE S3 BUCKET YOU CREATED IN STEP 1. The below command replaces the instance of the string ‘<s3-bucket>’ in each of the scipts to the name of the actual bucket.
sed -i 's/<s3-bucket>/${datalake_bucket}/g' ~/airflow/dags/transform/*
# Run Airflow webserver
airflow webserver