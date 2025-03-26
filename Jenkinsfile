pipeline {
    agent any

    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform resources')
    }

    stages {

        stage('Clone Repository') {
            steps {
                deleteDir()
                git branch: 'main',
                    url: 'https://github.com/Rakkigithub/Jenkins2.git'   // ✅ Your GitHub repo
                sh "ls -lart"
            }
        }

        stage('Check Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'echo "=================Terraform Init=================="'
                    sh 'terraform init'  // ✅ Running from root
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.PLAN_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'echo "=================Terraform Plan=================="'
                    sh 'terraform plan'  // ✅ Running from root
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.APPLY_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'echo "=================Terraform Apply=================="'
                    sh 'terraform apply -auto-approve'  // ✅ Running from root
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DESTROY_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh 'echo "=================Terraform Destroy=================="'
                    sh 'terraform destroy -auto-approve'  // ✅ Running from root
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
