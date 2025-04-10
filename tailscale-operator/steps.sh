# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Add the repository
helm repo add tailscale https://pkgs.tailscale.com/helmcharts

# Update your client’s package list
helm repo update

helm upgrade --install tailscale-operator tailscale/tailscale-operator \
  --namespace=tailscale \
  --create-namespace \
  --set-string oauth.clientId=<oauth_client_id> \
  --set-string oauth.clientSecret=<oauth_client_secret> \
  --wait