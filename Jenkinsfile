pipeline {
    agent any
    environment {
        IMAGE_NAME = 'soppydart/photog-burst:latest'
    }
    stages {
        stage('Build and Push Image') {
            environment {
                DOCKER_CREDS = credentials('docker-hub-repo')
            }
            steps {
                script {
                    echo 'Logging into Docker Hub'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'DOCKER_CREDS_USR', passwordVariable: 'DOCKER_CREDS_PSW')]) {
                        sh "docker login -u ${env.DOCKER_CREDS_USR} -p ${env.DOCKER_CREDS_PSW}"
                    }
                    echo 'Successfully logged into Docker Hub'

                    withCredentials([file(credentialsId: 'photog-burst-env', variable: 'ENV_FILE')]) {
                        sh 'cp $ENV_FILE .env'
                    }

                    echo 'Building docker image'
                    sh "docker build -t ${env.IMAGE_NAME} ."
                    sh "docker push ${env.IMAGE_NAME}"
                    echo 'Docker image pushed to Docker Hub'
                }
            }
        }
        stage('Provision Server') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_key')
            }
            steps {
                script {
                    echo 'Provisioning EC2 server'
                    dir('terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                        EC2_PUBLIC_IP = sh(script: 'terraform output -raw instance_ip', returnStdout: true).trim()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Waiting for the EC2 server to initialize'
                sleep(time: 90, unit: 'SECONDS')

                echo 'Deploying the docker image to EC2'
                echo "EC2 Public IP: ${EC2_PUBLIC_IP}"

                script {
                    def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"
                    def shellCmd = "bash /home/ec2-user/server-cmds.sh ${env.IMAGE_NAME}"

                    sshagent(['jenkins-ec2-key-pair']) {
                        sh "scp -o StrictHostKeyChecking=no docker-compose.production.yaml ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no .env ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
