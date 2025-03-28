
resource "aws_instance" "management_instance" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t2.micro"
  key_name      = "Key Tutorial"

  tags = {
    Name = "management_instance"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt install net-tools
    sudo snap install terraform --classic
    
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
    sudo apt install unzip 
    unzip awscliv2.zip 
    sudo ./aws/install
    
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin
    kubectl version --short--client

    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp 
    sudo mv /tmp/eksctl /usr/local/bin 
    eksctl version

    EOF

}
