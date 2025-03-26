pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.6.0'  // ✅ Run Terraform commands in Docker
        }
    }

    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform resources')
    }

    stages {
        stage('Clone Repository') {
            steps {
                deleteDir()
                git branch: 'main', url: 'https://github.com/Rakkigithub/Jenkins2.git'
                sh "ls -lart"
            }
        }

        stage('Check Terraform Version') {
            steps {
                sh 'terraform version'  // ✅ Terraform will be available from Docker image
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            when { expression { params.PLAN_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'terraform plan -input=false -out=tfplan main.tf'
                }
            }
        }

        stage('Terraform Apply') {
            when { expression { params.APPLY_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.DESTROY_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'terraform destroy -auto-approve main.tf'
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh 'echo "Cleaning up workspace..."'
                deleteDir()
            }
        }
    }
}
