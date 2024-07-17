pipeline {
    agent any

    environment {
        IMAGE_NAME = 'dpcode72/api'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker_login') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Run container') {
            steps {
                script {
                    sh 'docker stop dpcode || true'
                    sh 'docker rm dpcode || true'
                    sh "docker run -d --name dpcode -p 8000:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}
