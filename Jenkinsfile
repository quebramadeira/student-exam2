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
                coverage run -m pytest 
                      coverage report
                       '''
                sh 'echo "Tests passed"'
            }
        }
stage('build image') {
	steps {
   step([$class: 'DockerBuilderPublisher', cleanImages: true, cleanupWithJenkinsJobDelete: false, cloud: 'Docker', dockerFileDirectory: './', fromRegistry: [credentialsId: 'docker', url: 'https://hub.docker.com/repository/docker/quebramadeira/examapp'], pushCredentialsId: 'docker', pushOnSuccess: true, tagsString: 'quebramadeira/examapp:$BUILD_NUMBER'])
}
}	
    }
    post {
        always {
            echo "finished testing and pushing app image"
        }
        failure {
            echo "failure"
        }
    }
}


