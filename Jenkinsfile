pipeline {
    agent {
        docker {
            image 'maven:3.8.1-adoptopenjdk-11'
            args '-v /root/.m2:/root/.m2'
        }
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') { 
            steps {
                sh './jenkins/scripts/deliver.sh' 
            }
         def server = Artifactory.server "artifactory@ibsrv02"
  def buildInfo = Artifactory.newBuildInfo()
  buildInfo.env.capture = true
  def rtMaven = Artifactory.newMavenBuild()
  rtMaven.tool = MAVEN_TOOL // Tool name from Jenkins configuration
  rtMaven.opts = "-Denv=dev"
  rtMaven.deployer releaseRepo:'libs-release-local', snapshotRepo:'libs-snapshot-local', server: server
  rtMaven.resolver releaseRepo:'libs-release', snapshotRepo:'libs-snapshot', server: server

  rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo

  buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
  // Publish build info.
  server.publishBuildInfo buildInfo   
        }
    }
}
