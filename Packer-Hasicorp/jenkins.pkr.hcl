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
  ami_name                = "packer-jenkins-ami-${local.timestamp}"
}

# Builds
build {
  sources = [
    "source.amazon-ebs.demo",
  ]

  # Provisioners
  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt update -y",      
      "sudo apt upgrade -y",   
      "sudo apt install openjdk-17-jre -y",
      "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install jenkins -y",
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
      
    ]
  }

  # Post-processors
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}


