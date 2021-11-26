group "default" {
    targets = ["app"]
}

target "app" {
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
}

