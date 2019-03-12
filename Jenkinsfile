pipeline {
    // Guide book on Jenkins declarative pipelines
    // https://jenkins.io/doc/book/pipeline/syntax/
    agent {
        docker {
            image "pavics/workflow-tests:190312.1"
            label 'linux && docker'
        }
    }
    stages {
        stage('Run tests') {
            steps {
                script {
                    sh("./downloadrepos")
                    sh("./runtest 'notebooks/*.ipynb pavics-sdi-master/docs/source/notebooks/*.ipynb'")
                }
            }
        }
   }
    options {
        ansiColor('xterm')
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }
}
