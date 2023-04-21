pipeline {
    agent any
    parameters {
        editableChoice(
            name: "GodotVersion", 
            description: "The version of Godot to build",
            choices: ["4.0-stable", "4.0.1-stable", "4.0.2-stable"]
        )
    }
    environment {
        registry = "https://ghcr.io"
        registryCredential = "github-seppli11-package-token"
    }

    stages {
        stage('Build Image') {
            steps {
                echo "Building Godot ${params.GodotVersion}"
                script {
                    godotImage = docker.build("seppli11/godot:${params.GodotVersion}", "--build-arg GODOT_VERSION=${params.GodotVersion} .")
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