pipeline {
    agent any
    parameters {
        string(name: "GodotVersion", description: "The version of Godot to build")
    }
    environment {
        registry = "ghcr.io/Seppli11"
        registryCredential = "github-seppli11-package-token"
    }

    stages {
        stage('Build Image') {
            steps {
                echo "Building Godot ${params.GodotVersion}"
                script {
                    def godotImage = docker.build("godot:${params.GodotVersion}", "--build-arg GODOT_VERSION=${params.GodotVersion} .")
                }
            }
        }
        stage('Deploy Image') {
            steps {
                script {
                    docker.withRegistry( registry, registryCredential ) {
                        godotImage.push()
                        godotImage.push("latest")
                    }
                }
            }
        }
    }
}