pipeline {
  agent any
  stages {
    stage('Build cmdb-core') {
      steps {
        sh 'mvn -f cmdb-core/pom.xml -Dmaven.test.skip=true package'
      }
    }
    stage('Clean image build') {
      steps {
        sh 'make clean'
      }
    }
    
    stage('Build image') {
      steps {
        sh 'make build; make image;'
      }
    }
  }
}
