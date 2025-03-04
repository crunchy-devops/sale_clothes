pipeline {
    agent any
    environment {
        TAG_NAME = "v1"
    }
    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'sales', description: 'sales image')
        string(name: 'NEXUS', defaultValue: 'nexus:30999', description: 'NEXUS DNS entry')
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scmGit( branches: [[name: "${env.TAG_NAME}"]],
                    userRemoteConfigs: [[url: 'https://github.com/crunchy-devops/sale_clothes.git']])

            }
        }
        stage('Retrieve Git Commit Hash') {
            steps {
                script {
                    // Retrieve the Git commit hash using 'git rev-parse'
                    env.GIT_COMMIT_HASH = sh(script: "git rev-parse ${env.TAG_NAME} | cut -c 1-12", returnStdout: true).trim()
                }
            }
        }
        stage('Display Git Commit Hash') {
            steps {
                // Display the retrieved Git commit hash using echo
                echo "The current Git commit hash is: ${env.GIT_COMMIT_HASH}"
            }
        }
        stage('Docker build') {
            steps {
                script {
                    docker.withRegistry(credentialsId: 'nexuslogin')
                        {
                        def myImage = docker.build("${NEXUS}/${IMAGE_NAME}:${env.GIT_COMMIT_HASH}")
                        #def myPush =  docker.image("${NEXUS}/${IMAGE_NAME}:${env.GIT_COMMIT_HASH}").push()
                    }
                   }
                   }
                }
             }




}