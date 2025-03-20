# Add the repository
$ helm repo add tailscale https://pkgs.tailscale.com/helmcharts

# Update your client’s package list
$ helm repo update

$ helm upgrade --install tailscale-operator tailscale/tailscale-operator \
  --namespace=tailscale \
  --create-namespace \
  --set-string oauth.clientId=<oauth_client_id> \
  --set-string oauth.clientSecret=<oauth_client_secret> \
  --wait
Release "tailscale-operator" does not exist. Installing it now.
NAME: tailscale-operator
LAST DEPLOYED: Fri Dec 22 09:03:21 2023
NAMESPACE: tailscale
STATUS: deployed
REVISION: 1
TEST SUITE: None