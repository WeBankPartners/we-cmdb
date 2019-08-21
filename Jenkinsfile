pipeline {
  agent {
    docker {
      image 'maven:3-alpine'
      args '-v /root/.m2:/root/.m2'
    }

  }
  stages {
    stage('Build cmdb-core') {
      steps {
        sh 'mvn -f cmdb-core/pom.xml -Dmaven.skip.test=true package'
      }
    }
    stage('Clean image build') {
      steps {
        sh 'make clean'
      }
    }
    
    stage('Build image') {
      steps {
        sh 'make build;make image'
      }
    }
  }
}
