pipeline {
    agent any

    environment {
        INVENTORY = "ansible/inventory.ini"   // your existing inventory file
        PLAYBOOK = "ansible/playbook.yml"     // your existing playbook
        IMAGE_NAME = "mynodepipeline"              // matches your Dockerfile image name
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
                    // Tag Docker image with short Git commit hash
                    def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    
                    // Build Docker image using your existing Dockerfile
                    sh "docker build -t ${IMAGE_NAME}:${commitHash} ."
                    sh "docker tag ${IMAGE_NAME}:${commitHash} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                // Use your existing Jenkins Docker Hub credentials
                withCredentials([usernamePassword(
                    credentialsId: 'a3438d9a-5c1d-4478-803b-d3b7ca1873e5',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${commitHash}"
                    sh "docker push ${IMAGE_NAME}:latest"
                    sh 'docker logout'
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                // Run your existing Ansible playbook with inventory
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

