pipeline {
    agent any

    environment {
        INVENTORY = "ansible/inventory.ini"
        PLAYBOOK = "ansible/playbook.yml"
        IMAGE_NAME = "mypipeline"
        DOCKER_CREDENTIALS_ID = "b1a74edf-e139-41e3-89a4-776031757ce4"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Ksami9812/ksami9812.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Make commit hash available globally
                    env.COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    
                    sh "docker build -t ${IMAGE_NAME}:${env.COMMIT_HASH} ."
                    sh "docker tag ${IMAGE_NAME}:${env.COMMIT_HASH} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker push ${IMAGE_NAME}:${env.COMMIT_HASH}
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                sh "ansible-playbook -i ${INVENTORY} ${PLAYBOOK}"
            }
        }
    }

    post {
        success {
            echo 'Node.js app deployed successfully!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
