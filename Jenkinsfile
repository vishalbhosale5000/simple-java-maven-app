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
                sh 'mvn -B -DskipTests clean package'  // jar file will be generated from the java code from git hub repo
            }                                          // and saved inside docker container for Jenkins at :    
			                                     // /var/jenkins_home/workspace/simple-java-maven-app/target/my-app-1.0-SNAPSHOT.jar   
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'   // Tests will be saved inside docker container for Jenkins at :       
					                                     //  /var/jenkins_home/workspace/simple-java-maven-app/target/surefire-reports
                }
            }
        }
        stage('Upload') {
            steps{
			     script { 
                 def server = Artifactory.server 'art-1'
                 def uploadSpec = """{
                    "files": [{
                       "pattern": "/var/jenkins_home/workspace/simple-java-maven-app/target/*.jar",
                       "target": "libs-snapshot-local/"
                    }]
                 }"""

                 server.upload(uploadSpec) 
               }
			 }
        }
    }
}
