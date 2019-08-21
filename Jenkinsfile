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

    stage('Push image') {
      steps {
        sh 'docker login --username=100011085647 ccr.ccs.tencentyun.com -p Wecube@2019!; make push;'
      }
    }
	
  }
}
