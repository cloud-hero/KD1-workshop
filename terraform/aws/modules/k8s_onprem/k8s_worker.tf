resource "aws_instance" "ec2_instance_worker" {
  count                   = var.no_workers
  ami                     = var.ami
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.ssm_profile.id
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.this.id]

  tags = {
    Name = "${var.project_name}-${var.instance_name}-worker-${count.index}"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Set hostname based on Name tag
              apt update
              apt install jq awscli -y
              TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
              INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
              HOSTNAME=$(aws ec2 describe-tags --region eu-central-1 --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" | jq .Tags[0].Value | tr -d "\"")
              hostnamectl set-hostname "$HOSTNAME"

              # Customize shell prompt
              echo 'export PS1="[\\u@\\h \\W]\\$ "' >> /etc/bash.bashrc

              # Install SSM Agent
              # Download the latest SSM Agent's debian package
              wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

              # Install the downloaded package
              dpkg -i amazon-ssm-agent.deb

              # Enable and start the SSM Agent
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent

              # Add Docker's official GPG key:
              apt-get update
              apt-get install ca-certificates curl
              install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              chmod a+r /etc/apt/keyrings/docker.asc

              # Add the repository to Apt sources:
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update

              apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

              # Enable and start Docker service
              systemctl enable docker
              systemctl start docker

              # Configure Docker to use containerd
              mkdir -p /etc/docker
              cat <<EOD > /etc/docker/daemon.json
              {
                "exec-opts": ["native.cgroupdriver=systemd"],
                "log-driver": "json-file",
                "storage-driver": "overlay2"
              }
              EOD

              sed -i '/disabled_plugins = \["cri"\]/ s/^/#/' /etc/containerd/config.toml

              cat <<EOD >> /etc/containerd/config.toml
              [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
                [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
                  SystemdCgroup = true

              [plugins."io.containerd.grpc.v1.cri"]
                sandbox_image = "k8s.gcr.io/pause:3.2"
              EOD

              cat <<EOD > /etc/crictl.yaml
              runtime-endpoint: unix:///run/containerd/containerd.sock
              image-endpoint: unix:///run/containerd/containerd.sock
              timeout: 10
              debug: false
              EOD

              # Restart Docker to apply changes
              systemctl restart docker containerd

              swapoff -a
              EOF
}