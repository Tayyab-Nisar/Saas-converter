pipeline {
    agent { label "uat" }
    stages {
        stage('Download code from GitHub') {
            steps {
                script {
                    // Print the current directory and clone the repo
                    sh 'pwd'
                    sh 'rm -rf Saas-converter'
                    sh 'git clone https://github.com/Tayyab-Nisar/Saas-converter.git'
                }
            }
        }
        stage('Build Docker image') {
            steps {
                script {
                    // Corrected typo 'dokcer' to 'docker'
                    sh '''
                echo "Listing files in build context..."
                ls -la /home/ubuntu/workspace/saas-converter-uat-v-1/Saas-converter

                docker build \
                  -t wolvarine69984/saas-converter:latest \
                  -f /home/ubuntu/workspace/saas-converter-uat-v-1/Saas-converter/Dockerfile \
                  /home/ubuntu/workspace/saas-converter-uat-v-1/Saas-converter
            '''
                }
            }
        }
        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',  // ID from Jenkins Credentials
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    // Corrected typo in 'sh' commands
                    sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                }
            }
        }
        stage('Push Docker image') {
            steps {
                script {
                    // Corrected the missing closing quote and command formatting
                    sh 'docker push wolvarine69984/saas-converter:latest'
                }
            }
        }
        stage('Deploy Docker image') {
            steps {
                script {
                    // Fixed duplicate command and spacing issue
                    sh 'docker run -d --name saas-converter -p 3001:3001 wolvarine69984/saas-converter:latest'
                }
            }
        }
    }
}
