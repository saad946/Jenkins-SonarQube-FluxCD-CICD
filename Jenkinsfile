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



                    sh 'pwd'
                    sh 'ls -la'  // List files in the current directory for debugging
                    sh 'echo $MAVEN_HOME'  // Print Maven home for debugging
                    
                    sh 'mvn clean package sonar:sonar -X'

                    
                 
                }
            }
        }
    }
}
