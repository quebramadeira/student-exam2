pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }
    options {
        skipDefaultCheckout(true)
        // Keep the 10 most recent builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }
     environment {
     DOCKERHUB_CREDENTIALS=credentials('docker')
    }

    stages {

        stage ("Code pull"){
            steps{
                checkout scm
            }
        }
        stage('Install') {
            steps {
                sh '''python3 -m venv venv
                      . venv/bin/activate 
                      pip install -e .
                    '''
            }
        }
        stage('Test') {
            steps {
                sh '''python3 -m venv venv
                . venv/bin/activate
                coverage run -m pytest 
                      coverage report
                       '''
                sh 'echo "Tests passed"'
            }
        }
stage('build image') {
	steps {
   step([$class: 'DockerBuilderPublisher', cleanImages: true, cleanupWithJenkinsJobDelete: false, cloud: 'Docker', dockerFileDirectory: './', fromRegistry: [credentialsId: 'docker', url: 'https://hub.docker.com/repository/docker/quebramadeira/examapp'], pushCredentialsId: 'docker', pushOnSuccess: true, tagsString: 'quebramadeira/examapp'])
}
}	
stage('Login') {

	steps {
		sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
	}
}

stage('Push image') {

	steps {
		sh 'docker push quebramadeira/examapp:latest'
	}
}
    }
    post {
        always {
            echo "finished testing"
        }
        failure {
            echo "failure"
        }
    }
}


