pipeline {
    agent any
    environment {
        IMAGE_NAME = 'my-website'
        CONTAINER_NAME = 'my-website-container'
        PORT = '80'
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }
        stage('Stop Old Container') {
            steps {
                script {
                    sh 'docker rm -f $CONTAINER_NAME || true'
                }
            }
        }
        stage('Run New Container') {
            steps {
                script {
                    sh 'docker run -d --name $CONTAINER_NAME -p $PORT:80 $IMAGE_NAME'
                }
            }
        }
    }
}
