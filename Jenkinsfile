pipeline {
    agent any  // ✅ Use 'any' instead of 'docker'

    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform resources')
    }

    environment {
        TERRAFORM_BIN = '/usr/bin/terraform'  // ✅ Specify Terraform path
    }

    stages {
        stage('Install Terraform (if missing)') {
            steps {
                script {
                    def terraformExists = sh(script: 'command -v terraform', returnStatus: true) == 0
                    if (!terraformExists) {
                        sh '''
                        echo "Terraform not found! Installing..."
                        wget -q -O terraform.zip https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
                        unzip terraform.zip
                        sudo mv terraform /usr/local/bin/
                        terraform version
                        '''
                    } else {
                        sh 'terraform version'
                    }
                }
            }
        }

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
                    sh 'terraform init -input=false main.tf'
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
