pipeline {
    agent any

    environment {
        IMAGE_NAME = "rustamrustamov/xyz_tech"
    }

    stages {

        stage('Code Checkout') {
            steps {
                git url: 'https://github.com/rustamrustamv/XYZ.git',
                    credentialsId: 'git',
                    branch: 'master'
            }
        }

        stage('Code Compile') {
            steps { sh 'mvn -B compile' }
        }

        stage('Test') {
            steps { sh 'mvn -B test' }
        }

        stage('Build') {
            steps {
                sh 'mvn -B package'
                sh '''
                  WAR=target/XYZtechnologies-1.0.war
                  [ -f "$WAR" ] || exit 1
                  mv "$WAR" target/xyz.war
                '''
            }
        }

        stage('Debug') {
            when { expression { params.DEBUG_KUBE ?: false } }
            steps { sh 'ls -l /home/ubuntu/.kube/kubeconfig' }
        }

        stage('Ansible Build & Push Docker') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )
                ]) {
                    ansiblePlaybook(
                        playbook  : 'deploy-docker.yaml',
                        inventory : 'localhost,',
                        extras    : "-c local "
                                  + "-e dockerhub_user=${DOCKERHUB_USERNAME} "
                                  + "-e dockerhub_pass=${DOCKERHUB_PASSWORD}"
                    )
                }
            }
        }

        stage('Ansible Deploy Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KCFG')]) {
                    ansiblePlaybook(
                        playbook  : 'deploy-k8s.yaml',
                        inventory : 'localhost,',
                        extras    : "-c local -e kubeconfig=${KCFG}"
                    )
                }
            }
        }
    }

    post {
        always { archiveArtifacts artifacts: 'target/xyz.war', fingerprint: true }
    }
}
