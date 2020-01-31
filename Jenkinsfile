pipeline {
  agent { label "agentfarm" }
  stages {
    stage('Delete the workspace') {
      steps {
        sh "sudo rm -rf $WORKSPACE/*"
      }
    }
    stage("Installing Chef Workstation") {
      steps {
        script {
          def exists = fileExists '/usr/bin/chef-client'
          if (exists) {
            echo "Skipping Chef Workstation Install"
          } else {
            echo "Installing Chef Workstation"
            sh 'sudo apt-get install -y wget tree unzip'
            sh 'wget https://packages.chef.io/files/stable/chef-workstation/0.15.6/ubuntu/18.04/chef-workstation_0.15.6-1_amd64.deb'
            sh 'sudo dpkg -i chef-workstation_0.15.6-1_amd64.deb'
            sh 'sudo chef env --chef-license accept'
          }
        }
      }
    }
    stage('Install Test Kitchen Gem') {
      steps {
        script {
          sh 'chef exec gem list kitchen-docker | grep "kitchen-docker"'
          sh 'if [[ $? > 0 ]]; then sudo chef gem install kitchen-docker && sudo chef env --chef-license accept; fi'
        }
      }
    }
    stage('Download Apache Cookbook') {
      steps {
        git credentialsId: 'git-repo-id', url: 'git@github.com:jeffmbelt/haproxy_wrapper.git'
      }
    }
    stage('Lint using Cookstyle') {
      steps {
        sh 'cd $WORKSPACE && /opt/chef-workstation/bin/chef exec cookstyle . --except Layout/EndOfLine'
      }
    }
    stage('Run Kitchen Destroy') {
      steps {
            sh 'sudo kitchen destroy'
      }
    }
    stage('Run Kitchen Create') {
      steps {
            sh 'sudo kitchen create'
      }
    }
    stage('Run Kitchen Converge') {
      steps {
            sh 'sudo kitchen converge'
      }
    }
    stage('Run Kitchen Verify') {
      steps {
            sh 'sudo kitchen verify'
      }
    }
    stage('Kitchen Destroy') {
      steps {
            sh 'sudo kitchen destroy'
      }
    }
    stage('Send Slack Notification') {
      steps {
         slackSend color: 'YELLOW', message: "Mr. Belt: Please approve ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.JOB_URL} | Open>)"
      }
    }
    stage('Request Input') {
      steps {
         input 'Please approve or deny this build'
      }
    }
    stage('Upload and Converge Nodes') {
      steps {
        withCredentials([zip(credentialsId: 'chef-starter-zip', variable: 'CHEFREPO')]) {
          sh "rm $WORKSPACE/Policyfile.lock.json"
          sh "chef install $WORKSPACE/Policyfile.rb -c $CHEFREPO/chef-repo/.chef/knife.rb"
          sh "chef push prod $WORKSPACE/Policyfile.lock.json -c $CHEFREPO/chef-repo/.chef/knife.rb"
          withCredentials([sshUserPrivateKey(credentialsId: 'agent-key', keyFileVariable: 'agentKey', passphraseVariable: '', usernameVariable: '')]) { 
           sh "knife ssh 'policy_name:haproxy_wrapper' -x ubuntu -i $agentKey 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/knife.rb"
          } 
        }
      }
    }
  }
  post {
     success {
       slackSend color: 'GREEN', message: "Build $JOB_NAME $BUILD_NUMBER Successful!"
     }
     failure {
       slackSend color: 'RED', message: "Build $JOB_NAME $BUILD_NUMBER Failed!"
     }
    }
}
