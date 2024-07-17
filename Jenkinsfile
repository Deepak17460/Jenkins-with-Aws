pipeline {
    agent any
    environment {
        SONAR = 'SonarQube'
        ARTIFACTORY_SERVER_ID = 'Artifactory'
        IMAGE_NAME = 'dpcode72/java'
        IMAGE_TAG = '2.0'
        CONTAINER_NAME = 'webapp'
        DEFAULT_PORT = '8080'
    }
    tools {
        git 'Default'
        maven 'mvn'
    }
    stages {
        stage('Checkout-Scm') {
            steps {
                git branch: 'developer-2', credentialsId: 'Access-Nagarro-Gitlab', url: 'https://git.nagarro.com/GITG00641/DotNet/deepak-kumar.git'
            }
        }
        stage('Build-Docker') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Artifactory-Auth', usernameVariable: 'ARTIFACTORY_USERNAME', passwordVariable: 'ARTIFACTORY_PASSWORD')]) {
                    sh "docker build --build-arg ARTIFACTORY_USERNAME=${ARTIFACTORY_USERNAME} --build-arg ARTIFACTORY_PASSWORD=${ARTIFACTORY_PASSWORD} -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }
        stage('Container-Check') {
            steps {
                script {
                    def isRunning = sh(script: "docker ps --filter 'name=${env.CONTAINER_NAME}' --format '{{.Names}}'", returnStdout: true).trim()
                    if (isRunning == env.CONTAINER_NAME) {
                        def portInUse = sh(script: "docker port ${env.CONTAINER_NAME} | grep ${env.DEFAULT_PORT} || true", returnStdout: true).trim()
                        if (portInUse) {
                            def actualPort = portInUse.split(":").last().trim()
                            if (actualPort == env.DEFAULT_PORT) {
                                sh "docker stop ${env.CONTAINER_NAME}"
                                sh "docker rm ${env.CONTAINER_NAME}"
                            } else {
                                echo "Port ${env.DEFAULT_PORT} is not in use by container '${env.CONTAINER_NAME}'"
                            }
                        }
                    } else {
                        echo "Container '${env.CONTAINER_NAME}' is not running"
                    }
                }
            }
        }
        stage('Run-container') {
            steps {
                script {
                    sh "docker run -d --name ${env.CONTAINER_NAME} -p 8004:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}
