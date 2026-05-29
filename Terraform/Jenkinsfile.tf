pipeline {
    agent any

    stages {
        stage('Git Clone') {
            steps {
                git url: 'https://github.com/prajvaldhawale/Car-Booking-App.git', branch: 'master'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('Terraform/Terraform_dir') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('Terraform/Terraform_dir') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('Terraform/Terraform_dir') {
                    sh 'terraform plan -var-file=dev/dev.tf'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('Terraform/Terraform_dir') {
                    sh 'terraform apply -auto-approve -var-file=dev/dev.tf'
                }
            }
        }
    }
}
