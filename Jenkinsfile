pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                sh 'mvn -f cmdb-core/pom.xml clean test'
            }
        }
    }
}
