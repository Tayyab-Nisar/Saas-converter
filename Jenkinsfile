pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yourdockerhub/md-to-pdf'
        DEPLOY_SERVER = 'your.deploy.server.ip'
        DEPLOY_USER = 'ubuntu'
        SSH_KEY = credentials('your-ssh-key-id') // Jenkins stored private key credential
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE:latest .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                        sh 'docker push $DOCKER_IMAGE:latest'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sshagent (credentials: ['your-ssh-key-id']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_SERVER '
                          docker pull $DOCKER_IMAGE:latest &&
                          docker stop mdtopdf || true &&
                          docker rm mdtopdf || true &&
                          docker run -d --name mdtopdf -p 3001:3001 $DOCKER_IMAGE:latest
                        '
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up local Docker images"
            sh 'docker rmi $DOCKER_IMAGE:latest || true'
        }
    }
}

