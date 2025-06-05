pipeline {
    agent any

    environment {
        IMAGE_NAME = "rustamrustamov/xyz_tech"
		KUBECONFIG = "/home/ubuntu/.kube/kubeconfig" 
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
		stage('Debug') {
			steps {
				script {
					sh 'echo "Checking kubeconfig path"'
					sh 'ls -l /home/ubuntu/.kube/kubeconfig'   // Check if the kubeconfig file is present
					sh 'cat /home/ubuntu/.kube/kubeconfig'     // Display the content of kubeconfig (only for debugging)
				}	
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
                        credentialsId: 'git'
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
						credentialsId: 'git'
                    )
                }
            }
        }
    }
}
