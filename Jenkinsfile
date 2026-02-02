#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'https://github.com/jdavydova/jenkins-shared-library.git',
   credentialsID: 'github-credentials'
  ]
)

pipeline {
  agent any

  environment {
    DOCKER_REPO = "juliadavydova/my-app"
    EC2_INSTANCE = "ec2-user@16.170.220.53"
  }

  stages {

    stage('Test') {
      steps {
        sh """
          cd app
          npm ci || npm install
          npm test
        """
      }
    }

    stage('Set image tag') {
      when {
        anyOf { branch 'master'; branch 'main' }
      }
      steps {
        script {
          def version = "0.0.0"
          if (fileExists('app/package.json')) {
            try {
              def pkg = readJSON file: 'app/package.json'
              version = pkg.version ?: "0.0.0"
            } catch (e) {
              echo "readJSON not available, using 0.0.0"
            }
          }
          env.IMAGE_NAME = "${DOCKER_REPO}:${version}-${BUILD_NUMBER}"
          echo "IMAGE_NAME=${env.IMAGE_NAME}"
        }
      }
    }

    stage('Build & Push Image') {
      when {
        anyOf { branch 'master'; branch 'main' }
      }
      steps {
        script {
          sh "docker build -t ${env.IMAGE_NAME} ./app"
          dockerLogin('docker-credentials')
          dockerPush(env.IMAGE_NAME)
        }
      }
    }

    stage('Deploy to EC2') {
      when {
        anyOf { branch 'master'; branch 'main' }
      }
      steps {
        script {
          sshagent(['ec2-server-key']) {
            sh """
              set -e
              scp -o StrictHostKeyChecking=no server-cmds.sh ${EC2_INSTANCE}:/home/ec2-user/server-cmds.sh
              scp -o StrictHostKeyChecking=no docker-compose.yaml ${EC2_INSTANCE}:/home/ec2-user/docker-compose.yaml
              ssh -o StrictHostKeyChecking=no ${EC2_INSTANCE} "chmod +x /home/ec2-user/server-cmds.sh && /home/ec2-user/server-cmds.sh ${env.IMAGE_NAME}"
            """
          }
        }
      }
    }
  }
}