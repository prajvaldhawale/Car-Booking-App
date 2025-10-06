	pipeline{
	    agent any
	    environment{
	        SONAR_HOME = tool "Sonar-scan"
	    }
	    stages{
	        stage("Clone the Code from github"){
	            steps {
	                git url : "https://github.com/prajvaldhawale/Car-Booking-App.git", branch: "main" 
	            }
	        }
	        stage("SonarQube Quality Analysis"){
	            steps {
	                withSonarQubeEnv("Sonar-scan"){
	                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=Car-Booking-App -Dsonar.projectKey=Car-Booking-App"
	                }
	            }
	        }
	       // stage("OWASP DependancyCheck"){
	       //     steps {
	       //         dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP DC'
	       //         dependencyCheckPublisher pattern: '**/dependencyCheck-report.html'
	       //     }
	       // }
	        stage ("Sonar Quality Gate Scan"){
	            steps{
	                timeout(time: 2, unit: "MINUTES"){
	                    waitForQualityGate abortPipeline: false
	                }
	            }
	        }
	        stage("Trivey File System Scan"){
	            steps {
	                sh "trivy fs --format table -o trivy-fs-report.html ."
	            }
	        }
	        stage("Deploy using docker"){
	        	steps{
					sh "docker-compose down"
                    sh "docker-compose up -d "
		} 
		}
	    }
	}
