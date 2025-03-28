pipeline {
  agent any

  // Parameters allow passing custom values to the pipeline
  parameters {
    string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Tag for the Docker image')
  }
  // Define the tools to be used, Maven in this case
  tools {
    maven 'maven3'
  }
  // Define environment variables, like the SonarQube scanner home
  environment {
    SCANNER_HOME = tool 'sonar-scanner'
  }
  stages {
    // Stage to clean the workspace
    stage('Clean Workspace') {
      steps {
        cleanWs() // Clean up previous files
      }
    }
    // Stage to checkout the code from Git
    stage('Git Checkout') {
      steps {
        git branch: 'main', credentialsId: 'git-cred', \
          url: 'git@github.com:larafaakram/Multi-Tier-BankApp-CI.git'
      }
    }
    // Compile the code
    stage('Compile') {
      steps {
        sh 'mvn compile'
      }
    }
    // Run unit tests
    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }
    // Perform a filesystem security scan with Trivy
    stage('Trivy FS Scan') {
      steps {
        sh 'trivy fs --format table -o fs.html .' // Scan filesystem and save report as HTML
      }
    }
    // Perform static code analysis using SonarQube
    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar') {
          sh ''
          '
          $SCANNER_HOME / bin / sonar - scanner - Dsonar.projectName = BoardGame - Dsonar.projectKey = BoardGame\ -
            Dsonar.java.binaries = .
          ''
          '
        }
      }
    }
    // Wait for the SonarQube Quality Gate result
    stage('Quality Gate') {
      steps {
        script {
          waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
        }
      }
    }
    // Build the Maven project
    stage('Build') {
      steps {
        sh 'mvn package -DskipTests=true' // Build the package without running tests
      }
    }
    // Publish the package to Nexus Repository
    stage('Publish To Nexus') {
      steps {
        withMaven(globalMavenSettingsConfig: 'global-settings', \
          jdk: 'jdk17', maven: 'maven3', traceability: true) {
          sh 'mvn deploy' // Deploy the artifact to Nexus
        }
      }
    }
    // Build and push the Docker image
    stage('Docker') {
      steps {
        // Build Docker image with the provided tag and push to Docker registry
        script {
          withDockerRegistry([credentialsId: 'docker-cred', url: '']) {
            sh "docker build -t larafaakram/bankapp:${params.DOCKER_TAG} ."
            sh "docker push larafaakram/bankapp:${params.DOCKER_TAG}"
          }
        }
      }
    }
    // Update the image tag in the YAML manifest in another repository
    stage('Update YAML Manifest in Other Repo') {
      steps {
        script {
          withCredentials([gitUsernamePassword(credentialsId: 'github-cridential', gitToolName: 'Default')]) {
            sh ''
            '
            # Clone the repo containing the Kubernetes deployment manifest
            git clone https: //www.github.com/larafaakram/Multi-Tier-BankApp-CD.git
              cd Multi - Tier - BankApp - CD
            # Check
            if the bankapp - ds.yml file exists
            ls - l bankapp
            # Update the Docker image tag in the YAML file
            sed - i 's|image: larafaakram/bankapp:.*|image: larafaakram/bankapp:'
            $ {
              DOCKER_TAG
            }
            '|'
            $(pwd) / bankapp / bankapp - ds.yml ''
            '
            // Confirm the change in the updated YAML file
            sh ''
            '
            echo "Updated YAML file contents:"
            cat Multi - Tier - BankApp - CD / bankapp / bankapp - ds.yml ''
            '
            // Configure Git for the commit
            sh ''
            '
            cd Multi - Tier - BankApp - CD
            git config user.email "larafa.akram@gmail.com"
            git config user.name "LARAFA AKRAM"
            ''
            '
            // Commit and push the changes back to the repository
            sh ''
            '
            cd Multi - Tier - BankApp - CD
            git add bankapp / bankapp - ds.yml
            git commit - m "Update image tag to ${DOCKER_TAG}"
            git push origin main
              ''
            '
          }
        }
      }
    }
  }
}