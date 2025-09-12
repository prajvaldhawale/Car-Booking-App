# Car-Booking-App
The application of Node.js Car Booking App
Steps - Setup AWS server of EC2 instance
	- Install docker and docker compose
	- Install jenkins  (Linux)
	- Install sonarqube (    docker run -itd --name sonarqube-server -p 9000:9000 sonarqube:lts-community ) use this cmd
	- Install trivy (Trivy Installation and Usage. Trivy is a powerful open-source… | by Aung Myo Hein | Medium)
	- Install plugins go manger jenkins -->plugins -->  Sonarqube scanner
	- Sonar quality gates
	- OWASP Dependancy-check
	- Docker 
	• Integrate sonar with jenkins means connect with each other
	• Sonar qube --> adminstartion-->config--> webhooks-->(in you need to connect with each other) -->create --name=jenkins URL add jenkins url 73737:8080/sonarqube-webhook/
	• Go to secutiry in sonarqube -->user-->create token(squ_951e429b155beebe43c26587d4d0ffad7b334a9a) for authntication
	• Jenkins ->global credential->add cred-> kind(secret text)--secret add your token of sonarqube-->
	• Go to jenkins ->manage jenks->system->scrolldown ->sonarqube->click add sonar-->
	• Goto manage jenkins->tools ->scroll down-> click add sonar qube scanner-give name and save -
	• On same page goto dependacy check install-->give name ->install automatically->select git and version and save
	• Create pipeline
	- Go to jenkins new -team chose pipeline option --(stage pipeline and declarative pipeline - declarative pipelines means which create pipeline with the stages form)
	- Create pipeline -->github--add git url of the proj code-> 
	- In the script add following syntax need to check proper indentation 
	pipeline{
		Agent any --for run the jobs
		Environment{                ---you can create variable
			SONAR_HOME = tool "Sonar" 
	    stages{
	        stage("Code"){}
	        stage("Build"){}
	        stage("Test"){}
	        stage("Deploy"){}
	    }
	}
	 second version
	pipeline{
	    agent any
	    environment{
	        SONAR_HOME = tool "Sonar"  --ADD OWASP DC name  sonar tool use
	    }
	    stages{
	        stage("Code"){
	            steps {
	                echo "hello world"
	            }
	        }
	        stage("Build"){
	            steps {}
	        }
	        stage("Test"){
	            steps {}
	        }
	        stage("Deploy"){
	            steps {}
	        }
	    }
	}
	• Whole jenkins code
"
	pipeline{
	    agent any
	    environment{
	        SONAR_HOME = tool "Sonar"
	    }
	    stages{
	        stage("Clone the Code from github"){
	            steps {
	                git url : "https://github.com/LondheShubham153/wanderlust.git", branch: "devops" 
	            }
	        }
	        stage("SonarQube Quality Analysis"){
	            steps {
	                withSonarQubeEnv("Sonar"){
	                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=wanderlust -Dsonar.projectKey=wanderlust"
	                }
	            }
	        }
	        stage("OWASP DependancyCheck"){
	            steps {
	                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP DC'
	                dependencyCheckPublisher pattern: '**/dependencyCheck-report.html'
	            }
	        }
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
		Steps{
		
		   sh "docker-compose up -d "
		}  ---the docker container will faild because gives permission error user commnd (sudo usermod -aG docker jenkins)
		}
	    }
	}
![Uploading image.png…]()

