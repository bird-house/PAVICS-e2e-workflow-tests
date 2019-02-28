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
}
