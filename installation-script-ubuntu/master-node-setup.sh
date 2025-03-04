#!/bin/sh

MASTERNODE=masternodename

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker and containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER newgrp docker
sudo systemctl enable docker
sudo systemctl start docker

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 
kubectl version --client
kubectl version --client --output=yaml

# Install repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install the tools
sudo apt update -y
sudo apt install -y kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm vers

# Disable swap
sudo swapoff -a
sed -i 's/^\/swap/#\/swap/' /etc/fstab


# Enable the modules
sudo bash -c 'cat << 'EOF' > /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF'
sudo modprobe overlay
sudo modprobe br_netfilter

# Configure kubernetes and kublet
sudo bash -c 'cat << 'EOF' > /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF'
sudo sysctl --system
sudo bash -c 'cat << 'EOF' > /etc/default/kubelet
KUBELET_EXTRA_ARGS="--cgroup-driver=cgroupfs"
EOF'
sudo systemctl daemon-reload && sudo systemctl restart kubelet

# Configure docker
sudo bash -c 'cat << 'EOF' > /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF'

# Restart kublet, docker and containerd
sudo systemctl daemon-reload && sudo systemctl restart docker
sudo systemctl daemon-reload && sudo systemctl restart kubelet
sudo sed -i 's/^disabled_plugins/#disabled_plugins/' /etc/containerd/config.toml
sudo systemctl restart containerd.service

# Initialize kubernetes
sudo kubeadm init --control-plane-endpoint=$MASTERNODE --upload-certs
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get all

# Initialize calico
curl -O https://calico-v3-25.netlify.app/archive/v3.25/manifests/calico.yaml
kubectl apply -f calico.yaml
sudo systemctl restart containerd.service