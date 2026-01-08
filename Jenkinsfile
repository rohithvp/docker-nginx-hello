pipeline {
    agent any

    environment {
        IMAGE_NAME = "rohithvp/hello-nginx-app"
        DOCKERHUB = credentials('dockerhub-creds')
        DEPLOY_SERVER = "cloud_user@3.108.227.175"
    }

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'git@github.com:rohithvp/docker-nginx-hello.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t hello-nginx-app:latest .'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh '''
                echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                docker push hello-nginx-app:latest
                '''
            }
        }

        stage('Deploy to Server') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                    docker pull hello-nginx-app:latest  &&
                    docker stop myapp || true &&
                    docker rm myapp || true &&
                    docker run -d --name myapp -p 80:80 hello-nginx-app:latest
                "
                '''
            }
        }
    }
}
