pipeline {
    agent any
    environment {
        TAG_NAME = "v1"
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
                  def maven = docker.image('maven:latest')
                  maven.pull() // make sure we have the latest available from Docker Hub
                  maven.inside {
                    sh 'ls -alrt'
                  }
                }
             }
        }

    }
}