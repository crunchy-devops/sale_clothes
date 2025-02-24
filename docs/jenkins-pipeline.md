Yes! Instead of using multiple `sh` commands, you can **avoid shell scripting** by using **Jenkins plugins** like:

1. **Git Plugin** → For committing and pushing changes.
2. **Pipeline Utility Steps Plugin** → For modifying files.
3. **Docker Pipeline Plugin** → For building and pushing images.

---

## **Optimized Jenkinsfile Using Plugins**
Here’s how you can replace `sh` commands with Jenkins plugins:

```groovy
pipeline {
    agent any
    environment {
        COMMIT_HASH = ''
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    COMMIT_HASH = gitCommitShort()
                }
            }
        }
        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.build("myrepo/flask-app:${COMMIT_HASH}").push()
                }
            }
        }
        stage('Update GitOps Repo') {
            steps {
                script {
                    modifyYaml file: 'values.yaml', key: 'image.tag', value: "${COMMIT_HASH}"
                    gitCommitAndPush "Auto-update image tag to ${COMMIT_HASH} [ci skip]"
                }
            }
        }
    }
}

def gitCommitShort() {
    return scm.getBranches()[0].getSHA1().substring(0, 7)
}

def modifyYaml(Map params) {
    def yamlFile = readYaml file: params.file
    yamlFile[params.key] = params.value
    writeYaml file: params.file, data: yamlFile
}

def gitCommitAndPush(String message) {
    git credentialsId: 'git-credentials', branch: 'main', url: 'https://github.com/yourrepo.git'
    script {
        checkout scm
        withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
            gitCommit(commitMessage: message)
            gitPush()
        }
    }
}
```

---

## **How This Works Without `sh`**
✅ **`gitCommitShort()`** → Gets the short commit hash using Jenkins Git plugin.  
✅ **`docker.build().push()`** → Uses **Docker Pipeline Plugin** instead of `sh "docker build ..."`.  
✅ **`modifyYaml()`** → Uses **Pipeline Utility Steps Plugin** instead of `sed -i`.  
✅ **`gitCommitAndPush()`** → Uses **Git Plugin** to commit and push instead of `sh "git commit ..."`.

---

## **Benefits of This Approach**
🚀 **Cleaner Jenkinsfile** without shell scripting.  
🔧 **More maintainable** as it uses Jenkins plugins.  
🔒 **Secure** because it uses Jenkins credentials instead of embedding them in `sh` commands.

