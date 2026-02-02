#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/jdavydova/jenkins-shared-library.git',
    credentialsID: 'github-credentials'
    ]
)

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = "juliadavydova/my-app:3.0"
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "juliadavydova/my-app:${version}-${BUILD_NUMBER}"
                    echo "IMAGE_NAME=${env.IMAGE_NAME}"
                }
            }
        }
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin('docker-credentials')
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def shellCmd = "bash ./server-cmds.sh ${env.IMAGE_NAME}"
                    def ec2Instance = "ec2-user@16.170.220.53"
                    sshagent(['ec2-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user/server-cmds.sh"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user/docker-compose.yaml"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} \"${shellCmd}\""
                    }
                }
            }
        }
        stage('commit version update'){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '1dca2a6e-c95f-48b6-b3c4-bae003e2fa94', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh """
                            git remote set-url origin https://oauth2:${PASS}@gitlab.com/juliada888/java-maven-app.git
                            git add pom.xml
                            git commit -m "ci: version bump" || echo "Nothing to commit"
                            git push origin HEAD:jenkins-jobs
                        """
                    }
                }
            }
        }
    }
}
