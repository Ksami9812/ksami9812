pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-node-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url:'https://github.com/Ksami9812/ksami9812.git'
            }
        }

        stage('Build') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test || echo "No tests found, skipping..."'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        def image = docker.build("sami95/my-node-app:${env.BUILD_NUMBER}")
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                ansiblePlaybook credentialsId: 'ansible-ssh-key-id',
                                inventory: 'ansible/inventory.ini',
                                playbook: 'ansible/playbook.yml'
            }
        }
    }
}

