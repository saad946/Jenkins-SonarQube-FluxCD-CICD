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

                    sh '/usr/bin/sudo mvn clean package sonar:sonar'
                 }
                }
            }
        }
    }
}
