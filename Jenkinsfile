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
        stage('Docker build and push') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${env.GIT_COMMIT_HASH} ."
                    sh "docker tag ${IMAGE_NAME}:${env.GIT_COMMIT_HASH} ${NEXUS}/${IMAGE_NAME}:${env.GIT_COMMIT_HASH}"
                    withCredentials([usernamePassword(credentialsId: 'nexuslogin', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                        sh "echo \$NEXUS_PASS | docker login ${NEXUS} -u \$NEXUS_USER --password-stdin"
                        sh "docker push ${NEXUS}/${IMAGE_NAME}:${env.GIT_COMMIT_HASH}"
                        sh "docker logout ${NEXUS}"
                    }
                }
            }
        }
        stage('Install Docker on Remote Hosts') {
            environment {
                AWX_TOKEN = credentials('awx-token')
                AWX_HOST = 'http://awx.example.com'  // Replace with your AWX host
                JOB_TEMPLATE_ID = '10'  // Replace with your actual template ID
            }
            steps {
                script {
                    def payload = """
                    {
                        "extra_vars": {
                            "target_hosts": "production",
                            "docker_version": "latest",
                            "docker_users": ["jenkins"]
                        }
                    }
                    """
                    
                    sh """
                        curl -k -H "Authorization: Bearer \${AWX_TOKEN}" \
                             -H "Content-Type: application/json" \
                             -X POST \
                             -d '${payload}' \
                             "${AWX_HOST}/api/v2/job_templates/${JOB_TEMPLATE_ID}/launch/"
                    """
                    
                    // Wait for job completion
                    sh """
                        JOB_ID=\$(curl -k -s -H "Authorization: Bearer \${AWX_TOKEN}" \
                                "${AWX_HOST}/api/v2/jobs/?job_template=${JOB_TEMPLATE_ID}&order_by=-created" \
                                | jq '.results[0].id')
                        
                        while true; do
                            STATUS=\$(curl -k -s -H "Authorization: Bearer \${AWX_TOKEN}" \
                                    "${AWX_HOST}/api/v2/jobs/\${JOB_ID}/" \
                                    | jq -r '.status')
                            if [ "\$STATUS" == "successful" ]; then
                                echo "AWX job completed successfully"
                                break
                            elif [ "\$STATUS" == "failed" ] || [ "\$STATUS" == "error" ] || [ "\$STATUS" == "canceled" ]; then
                                echo "AWX job failed with status: \$STATUS"
                                exit 1
                            fi
                            echo "Waiting for AWX job to complete... Current status: \$STATUS"
                            sleep 30
                        done
                    """
                }
            }
        }
    }
}