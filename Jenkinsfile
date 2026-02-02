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
    // EC2 target
    EC2_INSTANCE = "ec2-user@16.170.220.53"
  }

  stages {

    stage('set image tag') {
      steps {
        script {
          echo "Calculating image tag from package.json (fallback: BUILD_NUMBER)"
          def version = ""
          if (fileExists('package.json')) {
            // readJSON requires Pipeline Utility Steps plugin.
            // If you don't have it, use the fallback version below.
            try {
              def pkg = readJSON file: 'package.json'
              version = pkg.version ?: ""
            } catch (e) {
              echo "readJSON not available or failed, using BUILD_NUMBER only"
            }
          }
          if (!version?.trim()) {
            version = "0.0.0"
          }
          env.IMAGE_NAME = "${DOCKER_REPO}:${version}-${BUILD_NUMBER}"
          echo "IMAGE_NAME=${env.IMAGE_NAME}"
        }
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

    stage('deploy to EC2') {
      steps {
        script {
          echo "deploying ${env.IMAGE_NAME} to EC2..."

          // server-cmds.sh expects image as $1 and does: export IMAGE=$1; docker compose up -d
          def shellCmd = "bash /home/ec2-user/server-cmds.sh ${env.IMAGE_NAME}"

          sshagent(['ec2-server-key']) {
            sh """
              set -e
              scp -o StrictHostKeyChecking=no server-cmds.sh ${EC2_INSTANCE}:/home/ec2-user/server-cmds.sh
              scp -o StrictHostKeyChecking=no docker-compose.yaml ${EC2_INSTANCE}:/home/ec2-user/docker-compose.yaml
              ssh -o StrictHostKeyChecking=no ${EC2_INSTANCE} "chmod +x /home/ec2-user/server-cmds.sh && ${shellCmd}"
            """
          }
        }
      }
    }
  }
}