pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }
    options {
        skipDefaultCheckout(true)
        // Keep the 5 most recent builds
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timestamps()
    }
    // environment {
     
  //  }

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
		pip install -e '.[test]'
                coverage run -m pytest 
                      coverage report
                       '''
                sh 'echo "Tests passed"'
            }
        }
stage('Build and push image') {
	steps {
   step([$class: 'DockerBuilderPublisher', cleanImages: true, cleanupWithJenkinsJobDelete: false, cloud: 'Docker', dockerFileDirectory: './', fromRegistry: [credentialsId: 'docker', url: 'https://hub.docker.com/repository/docker/quebramadeira/examapp'], pushCredentialsId: 'docker', pushOnSuccess: true, tagsString: 'quebramadeira/examapp:$BUILD_NUMBER'])
}
}	
    }
    post {
        always {
            echo "Finished testing and pushing app image to Docker Hub"
        }
        failure {
            echo "Failure"
        }
    }
}


