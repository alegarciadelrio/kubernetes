# 🧰 Kubernetes Toolbox Documentation

This documentation provides a comprehensive guide to the Kubernetes Toolbox repository, which contains various Kubernetes configuration examples and installation scripts.

<p>
  <img alt="bash" src="https://img.shields.io/badge/-Bash-grey?style=flat-square&logo=gnubash&logoColor=white" />
  <img alt="Kubernetes" src="https://img.shields.io/badge/Kubernetes-%23326CE5?style=flat-square&logo=kubernetes&logoColor=white" />
  <img alt="Amazon EKS" src="https://img.shields.io/badge/Amazon%20EKS-%23FF9900?style=flat-square&logo=amazoneks&logoColor=white" />
</p>

## 📑 Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
   - [Master Node Setup](#master-node-setup)
   - [Worker Node Setup](#worker-node-setup)
3. [Configuration Examples](#configuration-examples)
   - [Nginx with Service](#nginx-with-service)
   - [Nginx with Ingress](#nginx-with-ingress)
   - [Nginx with Ingress TLS](#nginx-with-ingress-tls)
   - [Nginx with Ingress Class Controller](#nginx-with-ingress-class-controller)
   - [Nginx with Volume](#nginx-with-volume)
   - [Tailscale Operator](#tailscale-operator)
4. [Kubernetes Dashboard](#kubernetes-dashboard)
5. [Docker Cleanup](#docker-cleanup)
6. [Service Account for EKS and Azure DevOps](#service-account-for-eks-and-azure-devops)
7. [Key Kubernetes Concepts](#key-kubernetes-concepts)

## 🔭 Overview

The Kubernetes Toolbox repository provides a collection of Kubernetes configuration examples and installation scripts. It serves as a reference for setting up and configuring Kubernetes clusters with various components such as Nginx, Ingress controllers, TLS, volumes, and more. Learn how to get started with Kubernetes Toolbox and then dive deeper into other advanced topics.

The repository is organized into several directories, each focusing on a specific aspect of Kubernetes configuration:

- `cluster-ubuntu`: Scripts for installing Kubernetes on Ubuntu
- `docker-cleanup`: Utility script for cleaning up Docker containers and images
- `docker-ubuntu`: Scripts for installing Docker on Ubuntu
- `kubernetes-dashboard`: Scripts for deploying and configuring the Kubernetes Dashboard
- `nginx-with-service`: Basic Nginx deployment with NodePort service
- `nginx-with-ingress`: Nginx deployment with Ingress configuration
- `nginx-with-ingress-tls`: Nginx deployment with TLS-enabled Ingress
- `nginx-with-ingress-class-controller`: Advanced Nginx Ingress setup with dedicated controller
- `nginx-with-volume`: Nginx deployment with volume configurations
- `service-account-for-eks-azure-devops`: Service account configuration for EKS with Azure DevOps
- `tailscale-operator`: Tailscale operator deployment for secure networking

## 🛠️ Installation

### Master Node Setup

The `cluster-ubuntu/master-node-setup.sh` script automates the installation of Kubernetes on an Ubuntu server that will serve as the master node (control plane) of the cluster.

Key steps in the installation process:

1. Install Docker and containerd
2. Install kubectl, kubeadm, and kubelet
3. Disable swap (required for Kubernetes)
4. Configure kernel modules and system settings
5. Initialize the Kubernetes cluster with kubeadm
6. Set up kubectl configuration
7. Deploy Calico network plugin

To use the script:

1. Edit the script to set the `MASTERNODE` variable to your master node's hostname
2. Make the script executable: `chmod +x master-node-setup.sh`
3. Run the script: `./master-node-setup.sh`

### Worker Node Setup

The `cluster-ubuntu/node-setup.sh` script automates the installation of Kubernetes on Ubuntu servers that will serve as worker nodes in the cluster.

Key steps in the installation process:

1. Install Docker and containerd
2. Install kubectl, kubeadm, and kubelet
3. Disable swap
4. Configure kernel modules and system settings
5. Join the Kubernetes cluster using the token provided by the master node

To use the script:

1. Edit the script to set the `MASTERNODE` variable to your master node's hostname
2. Update the `/etc/hosts` entry with the correct IP address of your master node
3. Replace the `kubeadm join` command with the one provided by the master node during its initialization
4. Make the script executable: `chmod +x node-setup.sh`
5. Run the script: `./node-setup.sh`

## 📋 Configuration Examples

### Nginx with Service

The `nginx-with-service` directory contains configuration files for deploying Nginx with a NodePort service, making it accessible from outside the cluster.

Key files:
- `1-webapp-hello-v1.yaml`: Deploys 6 replicas of a hello-app container
- `2-webapp-hello-service-v1.yaml`: Creates a NodePort service exposing the deployment on port 30080

To apply these configurations:

```bash
kubectl apply -f nginx-with-service/1-webapp-hello-v1.yaml
kubectl apply -f nginx-with-service/2-webapp-hello-service-v1.yaml
```

After applying, the application will be accessible at `http://<node-ip>:30080`.

### Nginx with Ingress

The `nginx-with-ingress` directory contains configuration files for deploying Nginx with Ingress, allowing host-based routing.

Key files:
- `1-webapp-hello-v1.yaml` and `2-webapp-hello-v2.yaml`: Deploy two different versions of the hello-app
- `3-webapp-hello-service-v1.yaml` and `4-webapp-hello-service-v2.yaml`: Create ClusterIP services for each deployment
- `5-ingress.yaml`: Creates an Ingress resource that routes traffic based on the host header

To apply these configurations:

```bash
kubectl apply -f nginx-with-ingress/1-webapp-hello-v1.yaml
kubectl apply -f nginx-with-ingress/2-webapp-hello-v2.yaml
kubectl apply -f nginx-with-ingress/3-webapp-hello-service-v1.yaml
kubectl apply -f nginx-with-ingress/4-webapp-hello-service-v2.yaml
kubectl apply -f nginx-with-ingress/5-ingress.yaml
```

After applying, the applications will be accessible at:
- `http://v1.test.com/` (routes to v1 service)
- `http://v2.test.com/` (routes to v2 service)

Note: You'll need to add entries to your `/etc/hosts` file to map these hostnames to your cluster's IP address.

### Nginx with Ingress TLS

The `nginx-with-ingress-tls` directory contains configuration files for deploying Nginx with TLS-enabled Ingress. More info to test certificate: 
https://segunale.blogspot.com/2024/09/self-signed-certificate-for-kubernetes.html

Key files:
- `1-webapp-hello-v1.yaml`: Deploys the hello-app
- `3-webapp-hello-service-v1.yaml`: Creates a ClusterIP service
- `5-ingress.yaml`: Creates an Ingress resource with TLS configuration
- `6-secret.yaml`: Contains the TLS certificate and key

To apply these configurations:

```bash
kubectl apply -f nginx-with-ingress-tls/1-webapp-hello-v1.yaml
kubectl apply -f nginx-with-ingress-tls/3-webapp-hello-service-v1.yaml
kubectl apply -f nginx-with-ingress-tls/6-secret.yaml
kubectl apply -f nginx-with-ingress-tls/5-ingress.yaml
```

After applying, the application will be accessible at `https://test.rutamania.com/`.

Note: For testing with self-signed certificates, refer to the guide at https://segunale.blogspot.com/2024/09/self-signed-certificate-for-kubernetes.html

### Nginx with Ingress Class Controller

The `nginx-with-ingress-class-controller` directory contains configuration files for deploying Nginx with a dedicated Ingress controller in a separate namespace.

Key files:
- `1-nginx-namespace.yaml` through `8-nginx-controller-service.yaml`: Set up the Nginx Ingress controller in its own namespace
- `10-webapp-hello-v1.yaml` and `11-webapp-hello-v2.yaml`: Deploy two different versions of the hello-app
- `12-webapp-hello-service-v1.yaml` and `13-webapp-hello-service-v2.yaml`: Create ClusterIP services
- `14-ingress-class.yaml`: Defines the IngressClass resource
- `15-ingress.yaml`: Creates an Ingress resource that uses the defined IngressClass

To apply these configurations:

```bash
# First, set up the Nginx Ingress controller
kubectl apply -f nginx-with-ingress-class-controller/1-nginx-namespace.yaml
kubectl apply -f nginx-with-ingress-class-controller/2-nginx-configmap.yaml
kubectl apply -f nginx-with-ingress-class-controller/3-nginx-service-account.yaml
kubectl apply -f nginx-with-ingress-class-controller/4-nginx-clusterrole-binding.yaml
kubectl apply -f nginx-with-ingress-class-controller/5-nginx-secret.yaml
kubectl apply -f nginx-with-ingress-class-controller/6-nginx-controller-deployment.yaml
kubectl apply -f nginx-with-ingress-class-controller/7-nginx-controller-service-admission.yaml
kubectl apply -f nginx-with-ingress-class-controller/8-nginx-controller-service.yaml

# Then, deploy the applications and Ingress
kubectl apply -f nginx-with-ingress-class-controller/10-webapp-hello-v1.yaml
kubectl apply -f nginx-with-ingress-class-controller/11-webapp-hello-v2.yaml
kubectl apply -f nginx-with-ingress-class-controller/12-webapp-hello-service-v1.yaml
kubectl apply -f nginx-with-ingress-class-controller/13-webapp-hello-service-v2.yaml
kubectl apply -f nginx-with-ingress-class-controller/14-ingress-class.yaml
kubectl apply -f nginx-with-ingress-class-controller/15-ingress.yaml
```

### Nginx with Volume

The `nginx-with-volume` directory contains configuration files for deploying Nginx with various volume configurations.

Key files:
- `01-pod.yaml`: Basic pod configuration
- `02-pod.yaml`: Pod with volume configuration
- `03-service-node-port.yaml`: NodePort service
- `04-pod-downwardapi.yaml`: Pod with downward API volume
- `05-pod-configmap.yaml`: Pod with ConfigMap volume
- `06-index-configmap.yaml`: ConfigMap containing HTML content

To apply these configurations:

```bash
# Create the ConfigMap first
kubectl apply -f nginx-with-volume/06-index-configmap.yaml

# Then create the pod that uses the ConfigMap
kubectl apply -f nginx-with-volume/05-pod-configmap.yaml

# Create other resources as needed
kubectl apply -f nginx-with-volume/03-service-node-port.yaml
```

### Tailscale Operator

The `tailscale-operator` directory contains configuration files for deploying and configuring the Tailscale Operator in a Kubernetes cluster. The Tailscale Operator allows you to expose Kubernetes services to your Tailscale network, enabling secure access without exposing them to the public internet.

Key files:
- `steps.sh`: Contains the Helm commands to install and configure the Tailscale Operator
- `app-operator.yml`: Defines a sample Nginx deployment and service with the Tailscale annotation `tailscale.com/expose: "true"`
- `tailscale-rbac..yml`: Contains the necessary RBAC configurations for Tailscale
- `tailscale-secret.yml`: Contains a Kubernetes secret with the Tailscale authentication key

To deploy the Tailscale Operator:

1. Set up Tailscale ACL policy rules:
```json
{
  "tagOwners": {
    "tag:k8s-operator": [],
    "tag:k8s": ["tag:k8s-operator"]
  }
}
```

2. Create an OAuth client for the operator in the Tailscale admin console with appropriate permissions

3. Create the Tailscale namespace and RBAC resources:
```bash
kubectl apply -f tailscale-operator/tailscale-rbac..yml
```

4. Create the Tailscale authentication secret:
```bash
kubectl apply -f tailscale-operator/tailscale-secret.yml
```

5. Install the Tailscale Operator using Helm:
```bash
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo update
helm upgrade --install tailscale-operator tailscale/tailscale-operator \
  --namespace=tailscale \
  --create-namespace \
  --set-string oauth.clientId=<oauth_client_id> \
  --set-string oauth.clientSecret=<oauth_client_secret> \
  --wait
```

6. Deploy a sample application with Tailscale exposure:
```bash
kubectl apply -f tailscale-operator/app-operator.yml
```

After deployment, the services with the `tailscale.com/expose: "true"` annotation will be accessible via your Tailscale network, providing secure access without exposing them to the public internet.

## 🖥️ Kubernetes Dashboard

The `kubernetes-dashboard` directory contains scripts for deploying and configuring the Kubernetes Dashboard, a web-based UI for managing Kubernetes clusters.

The Kubernetes Dashboard provides a user-friendly interface to:
- Deploy containerized applications
- View resource utilization
- Troubleshoot applications
- Manage cluster resources
- Get an overview of your cluster's health

Key components:
- `kubernetes-dashboard.sh`: Script that automates the installation and configuration process

To deploy the Kubernetes Dashboard:

```bash
cd kubernetes-dashboard
./kubernetes-dashboard.sh
```

After installation, you can access the dashboard in two ways:

1. Using NodePort:
```
https://<node-ip>:30443
```

2. Using Port Forwarding (Optional):
```bash
kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8443:443
```
Then access at `https://localhost:8443`

The script creates a service account named `dashboard-admin` with cluster-admin privileges and generates a token for authentication. This token is displayed at the end of the script execution.

## 🐳 Docker Cleanup

The `docker-cleanup` directory contains a utility script for cleaning up Docker containers and images.

Key components:
- `dcleanup`: Script that stops and removes all Docker containers and images

To use the Docker cleanup script:

```bash
cd docker-cleanup
chmod +x dcleanup
./dcleanup
```

Alternatively, you can move the script to a directory in your PATH for easy access:

```bash
sudo mv docker-cleanup/dcleanup /usr/local/bin/
```

Then run it from anywhere:

```bash
dcleanup
```

**⚠️ Warning**: This script will remove ALL Docker containers and images from your system. This action cannot be undone. Make sure you have backups or can rebuild any important images before running this script.

## 🔑 Service Account for EKS and Azure DevOps

The `service-account-for-eks-azure-devops` directory contains configuration for setting up a service account that can be used to connect Amazon EKS to Azure DevOps for CI/CD pipelines.

Key components:
- ServiceAccount: `deploy-robot`
- Secret: `deploy-robot-secret` (contains the service account token)
- Role: `deploy-robot-role` (defines permissions for the service account)
- RoleBinding: `global-rolebinding` (binds the role to the service account)
- ClusterRoleBinding: `cluster-role-binding` (grants cluster-admin privileges)

To apply this configuration:

```bash
kubectl apply -f service-account-for-eks-azure-devops/1-service-account.yml
```

After applying, you can retrieve the token for use in Azure DevOps:

```bash
kubectl get secret deploy-robot-secret -o jsonpath="{.data.token}" | base64 --decode
```

## 📚 Key Kubernetes Concepts

This repository demonstrates several key Kubernetes concepts:

### Deployments and Pods

Deployments manage the creation and scaling of pods. They ensure that a specified number of pod replicas are running at any given time.

Example from `nginx-with-service/1-webapp-hello-v1.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-hello-v1
spec:
  replicas: 6  # Maintains 6 replicas of the pod
  selector:
    matchLabels:
      app: webapp-hello-v1
  template:
    metadata:
      labels:
        app: webapp-hello-v1
    spec:
      containers:
      - name: webapp-hello
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
```

### Services

Services provide a stable endpoint to access pods. They abstract away the dynamic nature of pod creation and deletion.

Types of services demonstrated:
- **NodePort**: Exposes the service on each node's IP at a static port (e.g., `nginx-with-service/2-webapp-hello-service-v1.yaml`)
- **ClusterIP**: Exposes the service on a cluster-internal IP (e.g., `nginx-with-ingress/3-webapp-hello-service-v1.yaml`)

### Ingress

Ingress resources manage external access to services in a cluster, typically HTTP. They provide load balancing, SSL termination, and name-based virtual hosting.

Example from `nginx-with-ingress/5-ingress.yaml`:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: v1.test.com  # Routes traffic based on host header
    http:
      paths:
      - path: /
        pathType: Exact
        backend:
          service:
            name: webapp-hello-service-v1
            port:
              number: 80
```

### TLS/SSL with Ingress

Ingress resources can be configured to use TLS certificates for secure HTTPS connections.

Example from `nginx-with-ingress-tls/5-ingress.yaml`:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
spec:
  tls:
  - hosts:
      - test.rutamania.com
    secretName: secret-tls  # References the Secret containing the certificate
  rules:
  - host: test.rutamania.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-hello-service-v1
            port:
              number: 80
```

### ConfigMaps

ConfigMaps store configuration data as key-value pairs, which can be consumed by pods as environment variables, command-line arguments, or configuration files.

Example from `nginx-with-volume/06-index-configmap.yaml`:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: index-html
data:
  index.html: |-
    Hola soy una configmap
```

### Volumes

Volumes provide storage that can be mounted into containers. They can be backed by various storage systems.

Example from `nginx-with-volume/05-pod-configmap.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-02
  labels:
    app: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: index
  volumes:
    - name: index
      configMap:
        name: index-html
        items:
          - key: index.html
            path: index.html
```

### Service Accounts and RBAC

Service accounts provide an identity for processes running in pods. Role-Based Access Control (RBAC) defines what actions service accounts can perform.

Example from `service-account-for-eks-azure-devops/1-service-account.yml`:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: deploy-robot
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: deploy-robot-role
  namespace: default
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create", "delete"]
```

### IngressClass

IngressClass resources define the controller that should implement the Ingress. This allows for multiple Ingress controllers in a cluster.

Example from `nginx-with-ingress-class-controller/14-ingress-class.yaml`:
```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx-class
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: nginx.org/ingress-controller
