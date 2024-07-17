pipeline {
    agent any

    environment {
        IMAGE_NAME = 'dpcode72/api'
        IMAGE_TAG = "${BUILD_NUMBER}"
        AWS_REGION = 'us-east-1'
        ECR_REPO_URI = '730335663417.dkr.ecr.us-east-1.amazonaws.com/dpcode'
        DOCKER_HUB_REPO = 'dpcode72/api'
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

        stage('ECR Login') {
            steps {
                script {
                    withCredentials([awsSimple(credentialsId: 'aws', region: "${AWS_REGION}")]) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URI}"
                    }
                }
            }
        }

        stage('Docker Hub Login') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-login') {
                        // No additional login step needed here, handled by withRegistry
                    }
                }
            }
        }

        stage('Tag Image for ECR') {
            steps {
                script {
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO_URI}:${IMAGE_TAG}"
                }
            }
        }

        stage('Tag Image for Docker Hub') {
            steps {
                script {
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker push ${ECR_REPO_URI}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.image("${DOCKER_HUB_REPO}:${IMAGE_TAG}").push()
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
