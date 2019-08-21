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
        sh 'mvn -f cmdb-core/pom.xml -Dmaven.test.skip=true package'
      }
    }
    stage('Clean image build') {
      steps {
        sh 'rm -rf cmdb-core/target;rm -rf cmdb-ui/node;rm -rf cmdb-ui/node_modules'
      }
    }
    
    stage('Build image') {
      steps {
        sh 'mkdir -p repository;docker run -it --rm --name my-maven-project -v /data/repository:/usr/src/mymaven/repository   -v build/maven_settings.xml:/usr/share/maven/ref/settings-docker.xml  -v ./:/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn -U clean install -Dmaven.test.skip=true -s /usr/share/maven/ref/settings-docker.xml dependency:resolve'
      }
    }
  }
}
