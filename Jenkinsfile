pipeline {
    // Guide book on Jenkins declarative pipelines
    // https://jenkins.io/doc/book/pipeline/syntax/
    agent {
        docker {
            image "birdy"
            label 'linux && docker'
        }
    }
    stages {
        stage('Run tests') {
            steps {
                script {
                    sh("./runtest")
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
