pipeline{
    agent any
    tools{
        maven "M3"
    }
    environment{
        scannerHome = tool 'sonar'
    }
    stages{
        stage('Code Checkout'){
            steps{
                //cleanWs()
                //sh "git clone https://github.com/abnavemangesh22/MyNewPetClinic-2.git"
                git 'https://github.com/abnavemangesh22/MyNewPetClinic-2.git'
            }
        }
        stage('Code compile'){
            steps{
                sh "mvn clean test"
            }
        }
        
        stage('Code Analysis'){
            steps{
               script{
                   withSonarQubeEnv(credentialsId: 'sonar') {
                          sh "echo $SONAR_HOST_URL"
                          sh "echo $SONAR_AUTH_TOKEN"
                          sh "${scannerHome}/bin/sonar-scanner -D sonar.projectKey=MyPipeProject -D sonar.java.binaries=target/classes"
                    }
               }
            }
        }
        
        stage('Code Composition Analsys'){
            steps{
                
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'composition'
            }
        }
        stage('Code Packaging'){
            steps{
                sh "mvn package"
            }
        }
        stage('ArtifactUploader'){
            steps{
                nexusArtifactUploader artifacts: [[artifactId: 'spring-petclinic', classifier: '', file: 'target/spring-petclinic-1.5.2.jar', type: 'jar']], credentialsId: 'NexusServer', groupId: 'org.springframework.samples', nexusUrl: '43.204.173.38:32768', nexusVersion: 'nexus3', protocol: 'http', repository: 'pipelineRepo', version: '1.5.2'
            }
        }
        
        stage('Image Building'){
            steps{
                sh "docker build -t mangeshabnave/mypipeellusion-$BUILD_NUMBER ."
            }
        }
        
        stage('ImageUpload'){
            steps{
               withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "docker login -u ${env.username} -p ${env.password}"
                sh "docker push mangeshabnave/mypipeellusion-$BUILD_NUMBER"
                }
            }
        }
        stage('DemoRun'){
            steps{
                sh "docker -H tcp://172.31.8.89:2375 pull mangeshabnave/mypipeellusion-$BUILD_NUMBER"
                sh "docker -H tcp://172.31.8.89:2375 run -dit -P mangeshabnave/mypipeellusion-$BUILD_NUMBER"
            }
        }
    }
    post{
        always{
            slackSend channel: 'jenkins', message: 'This job is successful', teamDomain: 'demojenkinsworkspace', tokenCredentialId: 'slacktoken'
        }
    }
}

