pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'         // Set your AWS region
        AWS_CREDENTIALS_ID = 'aws-credentials-rakki'  // Your AWS credentials ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Rakkigithub/Jenkins2.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withAWS(credentials: "${AWS_CREDENTIALS_ID}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withAWS(credentials: "${AWS_CREDENTIALS_ID}") {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withAWS(credentials: "${AWS_CREDENTIALS_ID}") {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo "Terraform deployment successful!"
        }
        failure {
            echo "Terraform deployment failed!"
        }
    }
}
