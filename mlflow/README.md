# MLflow on Kubernetes

This directory contains Kubernetes manifests and scripts to deploy MLflow on a Kubernetes cluster. MLflow is an open-source platform for managing the end-to-end machine learning lifecycle, including tracking experiments, packaging code into reproducible runs, and sharing and deploying models.

## Contents

- `1-namespace.yaml`: Creates a dedicated Kubernetes namespace for MLflow
- `2-deployment.yaml`: Deploys the MLflow tracking server with PostgreSQL backend
- `3-service.yaml`: Creates a Kubernetes service to expose the MLflow tracking server within the cluster
- `4-ingress.yaml`: Sets up an Ingress resource to expose MLflow externally with TLS
- `mlflow-helm-setup.sh`: Script to install MLflow using Helm and configure Tailscale exposure

## Prerequisites

- A running Kubernetes cluster
- Helm installed
- Nginx Ingress Controller installed
- PostgreSQL database (referenced in the deployment configuration)
- TLS certificate for the MLflow tracking server (referenced in the ingress configuration)

## Deployment Options

### Option 1: Using Kubernetes Manifests

Apply the Kubernetes manifests in order:

```bash
kubectl apply -f 1-namespace.yaml
kubectl apply -f 2-deployment.yaml
kubectl apply -f 3-service.yaml
kubectl apply -f 4-ingress.yaml
```

**Note:** Before applying `2-deployment.yaml`, you need to:
1. Create a PostgreSQL database
2. Update the connection string in the deployment file
3. Create a Kubernetes secret named `regcred` for pulling the MLflow image

### Option 2: Using Helm

Run the Helm setup script:

```bash
./mlflow-helm-setup.sh
```

This script:
1. Updates Helm repositories
2. Installs MLflow using the community Helm chart
3. Annotates the MLflow service for Tailscale exposure

## Accessing MLflow

After deployment, MLflow will be accessible at:

- Within the cluster: `mlflow-tracking-service.mlflow.svc.cluster.local:5000`
- Externally: `https://mlflow-tracking.local` (requires DNS configuration or hosts file entry)

## Configuration

### Deployment Configuration

The MLflow deployment is configured to use a PostgreSQL database as the backend store. Update the connection string in `2-deployment.yaml` with your database details:

```yaml
command: ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000", "--backend-store-uri", "postgresql://username:password@host:port/database"]
```

### Ingress Configuration

The Ingress is configured to:
- Use the Nginx Ingress Controller
- Enforce HTTPS with SSL redirect
- Use a TLS certificate stored in the `mlflow-tracking-tls` secret

Update the host in `4-ingress.yaml` if you want to use a different domain name.

## Security Considerations

- The deployment configuration contains a PostgreSQL connection string with credentials. In a production environment, consider using Kubernetes secrets to store sensitive information.
- Ensure your TLS certificates are properly configured and renewed as needed.
- Review and adjust resource limits based on your expected usage.

## Troubleshooting

If you encounter issues:

1. Check pod status: `kubectl get pods -n mlflow`
2. View pod logs: `kubectl logs -n mlflow <pod-name>`
3. Verify service: `kubectl get svc -n mlflow`
4. Check ingress: `kubectl get ingress -n mlflow`
