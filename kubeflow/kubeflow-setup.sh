#/bin/sh
# Quick script to install kustomize and kubeflow in a kubernetes cluster.

# Install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo cp kustomize /usr/bin

# Install kubeflow
git clone https://github.com/kubeflow/manifests.git
cd manifests
while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done