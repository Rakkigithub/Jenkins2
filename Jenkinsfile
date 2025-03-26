pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.6.0'  // ✅ Run Terraform inside Docker
        }
    }

    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform resources')
    }

    environment {
        AWS_REGION = 'us-east-1'  // ✅ Add your AWS region
    }

    stages {
        stage('Clone Repository') {
            steps {
                deleteDir()
                git branch: 'main', url: 'https://github.com/Rakkigithub/Jenkins2.git'
                sh "ls -lart"
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when { expression { params.PLAN_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform plan -input=false -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when { expression { params.APPLY_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.DESTROY_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform destroy -auto-approve
                    '''
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
