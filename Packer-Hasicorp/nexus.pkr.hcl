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
  ami_name                 = "packer-nexus-ami-${local.timestamp}"
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
      "sudo apt upgrade -y",
      "sudo dpkg --configure --force-overwrite -a",  
      "sudo apt-get install openjdk-8-jdk -y",
      "sudo useradd -M -d /opt/nexus -s /bin/bash -r nexus",
      "sudo visudo -f echo 'nexus ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nexus",
      "sudo mkdir /opt/nexus",
      "wget https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/3/nexus-3.29.2-02-unix.tar.gz",
      "tar xzf nexus-3.29.2-02-unix.tar.gz -C /opt/nexus --strip-components=1",
      "sudo chown -R nexus:nexus /opt/nexus",   
    ]
  }

  # Post-processors
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}