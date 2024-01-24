pipeline{
    agent any
    tools{
        maven 'M3'
    }
    stages{
        stage('Code Checkout'){
            steps{
               git 'https://github.com/abnavemangesh22/MyPetClinic.git'
            }
        }
        stage('Code Test and Compile'){
            steps{
                sh 'mvn clean compile test'
            }
        }
        stage('Code Analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonartocken') {
                    sh 'mvn sonar:sonar'
                   }        
                }
            }
        }
        stage('Code Packing'){
            steps{
                sh 'mvn package -Dmaven.test.skip'
            }
        }
        stage('Nexus Code Upload'){
            steps{
              script{
                  nexusArtifactUploader artifacts: [[artifactId: 'spring-petclinic', classifier: '', file: 'target/spring-petclinic-1.5.2.jar', type: 'jar']], credentialsId: 'nexuscredential', groupId: 'org.springframework.samples', nexusUrl: '192.168.253.129:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'myrepo-Demo', version: '1.5.2'
              }
            }
        }
      stage('Build Docker Image'){
          steps{
            sh 'docker build -t mangeshabnave/mypetimage-77:latest .'  
          }
       }
       stage('Push the Iamge to Dockerhub'){
           steps{
               withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "docker login -u ${env.username} -p ${env.password}" 
                sh "docker push mangeshabnave/mypetimage-77:latest"
               }
           }
       }
       stage('Running the APP'){
           steps{
               sh "ssh -oStrictHostKeyChecking=no root@192.168.253.130 'docker pull mangeshabnave/mypetimage-77'"
               sh "ssh -oStrictHostKeyChecking=no root@192.168.253.130 'docker run -dit -P mangeshabnave/mypetimage-77'"
           }
       }
    }
    post{
        always{
            junit ' target/surefire-reports/*.xml'
        }
    }
}
