pipeline{
    
    agent any 

    environment {
        AWS_ACCOUNT_ID="982291412478"
        AWS_DEFAULT_REGION="ap-southeast-1"
        IMAGE_REPO_NAME="jenkins-pipeline"
        VERSION = "${env.BUILD.ID}"
        REPOSITORY_URI = "982291412478.dkr.ecr.ap-southeast-1.amazonaws.com/jenkins-pipeline"
    }
    
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/saad946/Jenkins-SonarQube-FluxCD-CICD.git'
                }
            }
        }
        stage('UNIT testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'sonars-tokens') {
                        
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonars-tokens'
                    }
                }
            }
            stage('Logging into AWS ECR') {
                steps {
                    script {
                        sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
                 
            }
        }
        
  
        // Building Docker images
            stage('Building image') {
                steps{
                    script {
                        dockerImage = docker.build "${IMAGE_REPO_NAME}:${VERSION}"
        }
      }
    }
   
        // Uploading Docker images into AWS ECR
            stage('Pushing to ECR') {
                steps{  
                    script {
                        sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$VERSION"""
                        sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${VERSION}"""
         }
        }
      }
        }
        
}
