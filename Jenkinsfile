pipeline {
    agent any

    stages {
		 stage('Checkout SCM') {
            steps {
              sh "checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/rahoodroshan/NunitDemo.git']]])"
            }
        } 
        stage('Build') {
            steps {
              sh "\"${tool 'MsBuild 14.0'}\" NunitDemo.sln /p:Configuration=Release /p:Platform=\"Any CPU\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"
            }
        }        
    }
}