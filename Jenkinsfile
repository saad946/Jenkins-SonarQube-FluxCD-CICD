pipeline{

    agent any 

    stages{

        stage('sonar quality check'){

            agent{

                docker {
                    image 'maven'
                }
            }
            steps{

                script{

                   withSonarQubeEnv(credentialsId: 'sonar-token') {

                    sh 'pwd'
                    sh 'ls -la'  // List files in the current directory for debugging
                    sh 'echo $MAVEN_HOME'  // Print Maven home for debugging
                    sh 'cat ~/.m2/settings.xml'  // Print Maven settings.xml for debugging
                    sh 'mvn clean package sonar:sonar -X'

                    sh 'mvn clean package sonar:sonar -e'
                 }
                }
            }
        }
    }
}
