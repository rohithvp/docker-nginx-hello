pipeline {
    agent any

    environment {
        IMAGE_NAME = "rohithvp/hello-nginx-app"
        DOCKERHUB = credentials('dockerhub-creds')
        DEPLOY_SERVER = "cloud_user@13.233.109.176"
    }

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/rohithvp/docker-nginx-hello.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t rohithvp/hello-nginx-app:latest .'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USR',
                    passwordVariable: 'DOCKERHUB_PSW'
                )]) {
                sh '''
                echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                docker push rohithvp/hello-nginx-app:latest

                '''
                 }
            }
        }
            

        stage('Deploy to Server') {
            steps {
                sshagent(['deploy-ssh-key']) {
                sh '''
                ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                    docker pull rohithvp/hello-nginx-app:latest  &&
                    docker stop myapp || true &&
                    docker rm myapp || true &&
                    docker run -d --name myapp -p 80:80 rohithvp/hello-nginx-app:latest
                "
                '''
                }
            }
        }
    }
}
