pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'docker build -t instabug_intern:latest /home/mohamed/internship'
      }
    }

    stage('Push to Docker Hub') {
      steps {
       
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials')]) {
          sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
        }

        sh 'docker tag instabug_intern:latest mohamedsherif20/instabug_intern:latest'

        sh 'docker push mohamedsherif20/instabug_intern:latest'
      }
    }



  }
}