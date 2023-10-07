# Variables
# variable "aws_access_key" {
#   type = string
# }

# variable "aws_secret_key" {
#   type = string
# }

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# Sources (Builders)
source "amazon-ebs" "demo" {
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  region                  = "ap-southeast-1"
  source_ami              = "ami-0df7a207adb9748c7"
  instance_type           = "t2.large"
  temporary_key_pair_type = "ed25519"
  ssh_username            = "ubuntu"
  ami_name                 = "packer-sonarqube-ami-${local.timestamp}"
}

# Builds
build {
  sources = [
    "source.amazon-ebs.demo",
  ]

  # Provisioners
  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install -y ca-certificates curl gnupg",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo chmod 777 /var/run/docker.sock",
      "sudo systemctl start docker",
      "docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube",
      
    ]
  }

  # Post-processors
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}

