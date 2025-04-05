pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nginx:latest' // Change this to your image
        CONTAINER_NAME = 'my-nginx'
    }

    stages {
        stage('Docker Pull') {
            steps {
                script {
                    echo "Pulling Docker image: ${IMAGE_NAME}"
                    sh "docker pull ${IMAGE_NAME}"
                }
            }
        }

        stage('Docker Run') {
            steps {
                script {
                    echo "Running container: ${CONTAINER_NAME}"
                    sh "docker run -d --name ${CONTAINER_NAME} -p 8080:80 ${IMAGE_NAME}"
                }
            }
        }

        stage('Verify Container') {
            steps {
                script {
                    sh "docker ps | grep ${CONTAINER_NAME}"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up container...'
            sh "docker rm -f ${CONTAINER_NAME} || true"
        }
    }
}
