pipeline {
    agent any

    environment {
        IMAGE_NAME = "mypipeline"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Get short commit hash
                    def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    
                    // Build and tag Docker image
                    sh """
                        docker build -t ${IMAGE_NAME}:${shortCommit} .
                        docker tag ${IMAGE_NAME}:${shortCommit} ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'b1a74edf-e139-41e3-89a4-776031757ce4', 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    script {
                        sh """
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            docker push ${IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                echo "Deploying via Ansible..."
                // Example Ansible command:
                // sh "ansible-playbook -i inventory/hosts deploy.yml"
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully."
        }
        failure {
            echo "Deployment failed."
        }
    }
}

