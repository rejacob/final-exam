def ProjectName = "FinalExam"
def buildStartTime = new Date().format('dd/MM/yyyy HH:mm:ss')
def helmPath = "helm/"
def repoURL = "rejacob/test-project"
def releaseNumber = "1.0"


pipeline {
    agent {
        node {
            label "master"
        }
    }

    environment {
        REGISTRY_CREDENTIALS = credentials('Dockerhub')
    }

    stages {

        stage('Build Image'){
           steps {
               script {
                    BUILD_VERSION = "${releaseNumber}.${BUILD_NUMBER}"
                    sh "pwd"
                    sh "docker build --no-cache -t finalexam ."
               }  
           }
        }

        stage('Push to Dockerhub'){
            steps {
                sh 'echo $REGISTRY_CREDENTIALS_PSW | docker login -u $REGISTRY_CREDENTIALS_USR --password-stdin'
                
                sh "docker tag  finalexam ${repoURL}:latest"
                sh "docker tag  finalexam ${repoURL}:${BUILD_VERSION}"
                sh "docker push ${repoURL}:${BUILD_VERSION}"
                sh "docker push ${repoURL}:latest"
            }
        }

        stage('Deploy') {
            steps {
                echo "${buildStartTime}"
                
                script {
                            sh """ helm upgrade --install finalexam-test ${helmPath} \
                            -n finalexam-test \
                            --values=${helmPath}values.yaml \
                            --set-string timestamp='${buildStartTime}' \
                            --set-string image.tag='${BUILD_VERSION}' \
                            """
                }

                echo "Waiting 10 seconds for deployment to ensure the container is complelete running."
                sleep 10
            }
        }
    }

}