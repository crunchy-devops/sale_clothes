pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                checkout scmGit(tags: [[name: 'v1']],
                    userRemoteConfigs: [[url: 'https://github.com/crunchy-devops/sale_clothes.git']])
            }
        }
        stage('Retrieve Git Commit Hash') {
            steps {
                script {
                    // Retrieve the Git commit hash using 'git rev-parse'
                    env.GIT_COMMIT_HASH = sh(script: 'git rev-parse HEAD | cut -c 1-12', returnStdout: true).trim()
                }
            }
        }
          stage('Display Git Commit Hash') {
            steps {
                // Display the retrieved Git commit hash using echo
                echo "The current Git commit hash is: ${env.GIT_COMMIT_HASH}"
            }
        }
    }
}