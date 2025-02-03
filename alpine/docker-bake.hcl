variable "DOCKER_IMAGE" {
  default = "python"
}

variable "DOCKER_IMAGE_TAG" {
  default = "latest"
}

variable "AWS_ECR_URI" {
  default = "public.ecr.aws/w2u0w5i6"
}

variable "DOCKER_IMAGE_OS" {
  default = "alpine"
}

variable "DOCKER_IMAGE_GROUP" {
  default = "dev"
}

variable "SYSTEM_CPU_PROC" {}

group "default" {
  targets = ["build"]
}

target "settings" {
  context = "."
  cache-from = [
    "type=gha"
  ]
  cache-to = [
    "type=gha,mode=max"
  ]
}

target "test-amd64" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine-amd64"
  platforms = ["linux/amd64"]

  tags = []
}

target "test-arm64" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine-arm64"
  platforms = ["linux/arm64"]
  tags = []
}

target "build-amd64" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine-amd64"
  platforms = ["linux/amd64"]
  output   = ["type=docker"]
  args = {
    SYSTEM_CPU_PROC = SYSTEM_CPU_PROC
    PYTHON_VERSION = DOCKER_IMAGE_TAG
  }
  tags = [
    "${AWS_ECR_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}-amd64",
  ]
}

target "build-arm64" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine-arm64"
  platforms = ["linux/arm64"]
  output   = ["type=docker"]
  args = {
    SYSTEM_CPU_PROC = SYSTEM_CPU_PROC
    PYTHON_VERSION = DOCKER_IMAGE_TAG
  }
  tags = [
    "${AWS_ECR_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}-arm64",
  ]
}

target "push-amd64" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine-amd64"
  platforms = ["linux/amd64"]
  output   = ["type=registry"]
  tags = [
    "${AWS_ECR_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}-amd64",
  ]
}

target "push-arm64" {
  inherits = ["settings"]
  dockerfile = "Dockerfile.alpine-arm64"
  platforms = ["linux/arm64"]
  output   = ["type=registry"]
  tags = [
    "${AWS_ECR_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}-arm64",
  ]
}
