pipeline {
    agent any

    environment {
        IMAGE_NAME = "rustamrustamov/xyz_tech"
    }

    stages {
        stage('Code Checkout') {
            steps {
                git url: 'https://github.com/rustamrustamv/XYZ.git', 
                    credentialsId: 'git-ssh-key',
                    branch: 'master'
            }
        }

        stage('Code Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn package'
                // Rename the WAR file to xyz.war
                sh 'mv target/XYZtechnologies-1.0.war target/xyz.war'
            }
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
                        playbook: 'deploy-docker.yaml',
                        inventory: 'localhost,',
                        extras: "-c local -e dockerhub_user=${DOCKERHUB_USERNAME} -e dockerhub_pass=${DOCKERHUB_PASSWORD}",
                        credentialsId: 'ansible-ssh-key'
                    )
                }
            }
        }

        stage('Ansible Deploy Kubernetes') {
            steps {
				withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
					ansiblePlaybook(
						playbook: 'deploy-k8s.yaml',
						inventory: 'localhost,',
						extras: '-c local',
						credentialsId: 'ansible-ssh-key'
                )
            }
        }
    }
}
