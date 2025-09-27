pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sami95/my-app:latest"
        REGISTRY = "sami95/my-app"
        DOCKER_CREDENTIALS_ID = "cf7fba2b-b26b-472e-9f9b-0f9e825cb638"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout repo directly into workspace root
                git branch: 'main', url: 'https://github.com/Ksami9812/ksami9812.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Make sure we are in the workspace root
                    sh "ls -la" // optional, to verify Dockerfile is here
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh "ansible-playbook -i inventory.ini playbook.yml --extra-vars 'docker_image=${DOCKER_IMAGE}'"
            }
        }
    }

    post {
        always {
            cleanWs() // cleanup workspace after pipeline
        }
    }
}
