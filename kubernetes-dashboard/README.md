# Kubernetes Dashboard

This directory contains scripts to deploy and configure the Kubernetes Dashboard, a web-based UI for managing Kubernetes clusters.

## Overview

The Kubernetes Dashboard provides a user-friendly web interface to manage and troubleshoot applications running in your Kubernetes cluster. It allows you to:

- Deploy containerized applications
- View resource utilization
- Troubleshoot applications
- Manage cluster resources
- Get an overview of your cluster's health

## Prerequisites

- A running Kubernetes cluster
- `kubectl` configured to communicate with your cluster
- Sudo privileges (for creating the NodePort service)

## Installation

The `kubernetes-dashboard.sh` script automates the installation and configuration process:

1. Installs Helm (if not already installed)
2. Adds the Kubernetes Dashboard repository to Helm
3. Deploys the Kubernetes Dashboard using Helm
4. Creates a NodePort service to expose the dashboard on port 30443
5. Creates a service account with admin privileges
6. Generates an authentication token

To install the Kubernetes Dashboard, run:

```bash
./kubernetes-dashboard.sh
```

## Accessing the Dashboard

After installation, you can access the dashboard in two ways:

### 1. Using NodePort

The dashboard is exposed on port 30443 of your cluster nodes. Access it using:

```
https://<node-ip>:30443
```

### 2. Using Port Forwarding (Optional)

Uncomment the last line in the script to use port forwarding:

```bash
kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8443:443
```

Then access the dashboard at:

```
https://localhost:8443
```

## Authentication

The script creates a service account named `dashboard-admin` with cluster-admin privileges and generates a token. This token is displayed at the end of the script execution.

To authenticate:

1. Select "Token" on the login page
2. Paste the token displayed after running the script
3. Click "Sign In"

If you need to retrieve the token later, run:

```bash
kubectl -n kubernetes-dashboard create token dashboard-admin
```

## Security Considerations

- The dashboard is exposed using HTTPS, but with a self-signed certificate
- The script creates a service account with full admin privileges, which is convenient but not recommended for production environments
- Consider implementing more restrictive RBAC policies for production use
- For production environments, consider setting up proper TLS certificates

## Uninstallation

To uninstall the Kubernetes Dashboard:

```bash
helm uninstall kubernetes-dashboard -n kubernetes-dashboard
kubectl delete namespace kubernetes-dashboard
```

## Additional Resources

- [Kubernetes Dashboard GitHub Repository](https://github.com/kubernetes/dashboard)
- [Official Documentation](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
