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
      // PATH="/var/lib/jenkins/miniconda3/bin:$PATH"
   // }

    stages {

        stage ("Code pull"){
            steps{
                checkout scm
            }
        }
        stage('Build environment') {
            steps {
                sh '''python3 -m venv venv
                      . venv/bin/activate 
                      pip install -e '.[test]'
                    '''
            }
        }
        stage('Test environment') {
            steps {
                sh '''coverage run -m pytest 
                      coverage report
                       '''
            }
        }
    }
    post {
        always {
            echo "finished"
        }
        failure {
            echo "failure"
        }
    }
}

