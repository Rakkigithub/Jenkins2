pipeline {
  agent {
    docker { image 'jenkins/jenkins:lts' }
  }
  environment {
    DOCKER_IMAGE = 'my-app:latest'
    DOCKER_CONTAINER = 'my-app-container'
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DOCKER_IMAGE .'
      }
    }
    stage('Run Docker Container') {
      steps {
        sh 'docker run -d --name $DOCKER_CONTAINER $DOCKER_IMAGE'
      }
    }
    stage('Cleanup') {
      steps {
        sh 'docker stop $DOCKER_CONTAINER || true'
        sh 'docker rm $DOCKER_CONTAINER || true'
      }
    }
  }
}
