pipeline{
    agent any
    tools {
       terraform 'terraform'
    }
    stages{
        stage('Git checkout'){
            steps{
                git 'https://github.com/stranger900/terraform.git'
            }
        }
        stage('Terraform init'){
            steps{
                withAWS(credentials: 'aws_credentials', region: 'us-east-1') {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform plan'){
            steps{
                withAWS(credentials: 'aws_credentials', region: 'us-east-1') {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform apply'){
            steps{
                withAWS(credentials: 'aws_credentials', region: 'us-east-1') {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
    }

}