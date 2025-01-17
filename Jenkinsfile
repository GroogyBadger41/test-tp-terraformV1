pipeline {
    agent any
     options {
        // options
        ansiColor('xterm')
    }
     }

     parameters {
        // Parameters
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy')
     }

    environment {
        // environment variables
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('iac:terraform plan') {
            when {
                expression { params.DESTROY == false }
            }
            steps {
                script {
                    sh '''
                        terraform init
                        terraform plan
                    '''
                }
            }
        }

        stage('confirm:deploy') {
            when {
                expression { params.DESTROY == false }
            }
            steps {
                input(id: 'confirm', message: """
                    You choose to deploy:""")
            }
        }

        stage('confirm:destroy') {
            when {
                expression { params.DESTROY == true }
            }
            steps {
                input(id: 'confirm', message: """
                    You choose to deploy:""")
            }
        }

        stage('init:apply') {
            when {
                expression { params.DESTROY == false }
            }
            steps {
                input(id: 'confirm', message: """
                    You choose to deploy:""")
            }
        }

        stage('destroy') {
            when {
                expression { params.DESTROY == true }
            }
            steps {
                input(id: 'confirm', message: """
                    You choose to deploy:""")
            }
        }
        
        
                    
                    
branch: ${env.GIT_BRANCH}
                  Do you confirm the deployment""")}}

        stage('iac:terraform apply') {
            steps {
                script {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }

    post { 
        always { 
            cleanWs()
        }
    }

}