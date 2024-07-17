pipeline {
    agent any
    environment {
        IMAGE_NAME = 'dpcode'
        IMAGE_TAG = "${BUILD_NUMBER}"
        AWS_ACCOUNT_ID = '730335663417'
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'dpcode'
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
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                        docker.withRegistry("https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com", '') {
                            docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        }
                    }
                }
            }
        }
        stage('Run container') {
            steps {
                script {
                    sh 'docker stop dpcode || true'
                    sh 'docker rm dpcode || true'
                    sh "docker run -d --name dpcode -p 8000:8080 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}"
                }
            }
        }
    }
}
