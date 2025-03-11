pipeline {
    agent any
    environment {
        IMAGE = "myapp:latest"
    }
    
    stages {
        stage('Clone') {
            steps { git 'https://github.com/Rakkigithub/Jenkins2.git' }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-cred', url: '']) {
                    sh 'docker tag myapp:latest user/myapp:latest'
                    sh 'docker push user/myapp:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 80:80 user/myapp:latest'
            }
        }
    }
}
