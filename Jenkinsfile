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
                git branch: 'main', url: 'https://github.com/Rakkigithub/Jenkins2.git'
                sh "ls -lart"
            }
        }

        stage('Check Terraform Version') {
            steps {
                sh 'docker run --rm hashicorp/terraform:1.6.0 version'  // ✅ Run Terraform in Docker
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    docker run --rm \
                    -v $PWD:/workspace \
                    -w /workspace \
                    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                    hashicorp/terraform:1.6.0 init -input=false
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when { expression { params.PLAN_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    docker run --rm \
                    -v $PWD:/workspace \
                    -w /workspace \
                    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                    hashicorp/terraform:1.6.0 plan -input=false -out=tfplan main.tf
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when { expression { params.APPLY_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    docker run --rm \
                    -v $PWD:/workspace \
                    -w /workspace \
                    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                    hashicorp/terraform:1.6.0 apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.DESTROY_TERRAFORM } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rakki']]) {
                    sh '''
                    docker run --rm \
                    -v $PWD:/workspace \
                    -w /workspace \
                    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                    hashicorp/terraform:1.6.0 destroy -auto-approve main.tf
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
