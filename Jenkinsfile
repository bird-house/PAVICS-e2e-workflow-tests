String cron_only_on_master = env.BRANCH_NAME == "master" ? "@midnight" : ""

pipeline {
    // Guide book on Jenkins declarative pipelines
    // https://jenkins.io/doc/book/pipeline/syntax/
    agent {
        docker {
            image "pavics/workflow-tests:190312.1"
            label 'linux && docker'
        }
    }

    parameters {
        string(name: 'PAVICS_HOST', defaultValue: 'pavics.ouranos.ca',
               description: 'PAVICS host to run notebooks against.', trim: true)
        string(name: 'PAVICS_SDI_BRANCH', defaultValue: 'master',
               description: 'https://github.com/Ouranosinc/pavics-sdi branch to test against.', trim: true)
        booleanParam(name: 'VERIFY_SSL', defaultValue: true,
                     description: 'Check the box to verify SSL certificate for https connections to PAVICS host.')
    }

    triggers {
        cron(cron_only_on_master)
    }

    stages {
        stage('Run tests') {
            steps {
                script {
                    withCredentials(
                        [usernamePassword(credentialsId: 'esgf_auth',
                                          passwordVariable: 'ESGF_AUTH_PASSWORD',
                                          usernameVariable: 'ESGF_AUTH_USERNAME'),
                         string(credentialsId: 'esgf_auth_token',
                                variable: 'ESGF_AUTH_TOKEN')
                         ]) {
                        sh("VERIFY_SSL=${params.VERIFY_SSL} ./testall")
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts(artifacts: 'environment-export-birdy.yml, conda-list-explicit-birdy.txt, notebooks/*.ipynb, pavics-sdi-*/docs/source/notebooks/*.ipynb',
                             fingerprint: true)
        }
    }

    options {
        ansiColor('xterm')
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
        // trying to keep 2 months worth of history with buffer for manual
        // build trigger
        buildDiscarder(logRotator(numToKeepStr: '100'))
    }
}
