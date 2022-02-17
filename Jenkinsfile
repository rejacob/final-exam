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
                script {
                    withCredentials([usernamePassword(credentialsId: 'Dockerhub', passwordVariable: 'Dockerhub_Password', usernameVariable: 'Dockerhub_Username')]) {
                        sh """

                            docker login --username ${Dockerhub_Username} --password ${Dockerhub_Password}

                        """
                    }
                }
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
                            --set-string secret.registryCredentials='${REGISTRY_CREDENTIALS}' \
                            """
                }

                echo "Waiting 10 seconds for deployment to ensure the container is complelete running."
                sleep 10
            }
        }
    }

}