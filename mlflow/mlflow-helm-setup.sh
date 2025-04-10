#/bin/sh
# Another approach to install mlflow using helm. This doesn't support postgresql connection.
helm repo update
helm install mlflow community-charts/mlflow
kubectl annotate service/mlflow tailscale.com/expose=true