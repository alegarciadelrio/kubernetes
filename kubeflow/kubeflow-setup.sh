#/bin/sh
# Quick script to install kustomize and kubeflow in a kubernetes cluster.

# Install kustomize.
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo cp kustomize /usr/bin

# Install kubeflow, do git checkout with the last version.
git clone https://github.com/kubeflow/manifests.git
cd manifests
git checkout v1.10.0
while ! kustomize build example | kubectl apply --server-side --force-conflicts -f -; do echo "Retrying to apply resources"; sleep 20; done
kubectl annotate svc/istio-ingressgateway -n istio-system tailscale.com/expose=true

