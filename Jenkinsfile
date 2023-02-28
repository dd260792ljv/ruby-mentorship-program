pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                sh 'rake clean_directories'
            }
        }
        stage('Test') {
            steps {
                sh 'REMOTE=true rake run_parallel'
                sh 'REMOTE=true rake rerun_parallel'
            }
        }

        stage('Report') {
            steps {
                sh 'rake modify_allure_report'
                script {
                    allure([
                            includeProperties: false,
                            jdk: '',
                            properties: [],
                            reportBuildPolicy: 'ALWAYS',
                            results: [[path: 'tmp/allure-results']]
                    ])
                }
                sh 'rake merge_junit_report'
                sh 'rake clean_additional_reports'
                junit 'tmp/junit_reports/*.xml'
            }
        }
    }
}