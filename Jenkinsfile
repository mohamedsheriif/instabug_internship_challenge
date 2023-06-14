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
       
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'shifo2000', usernameVariable: 'mohamedsherif20')]) {
          sh 'docker login -u mohamedsherif20 -p shifo2000'
        }

        sh 'docker tag instabug_intern:latest mohamedsherif20/instabug_intern:latest'

        sh 'docker push mohamedsherif20/instabug_intern:latest'
      }
    }



  }
}