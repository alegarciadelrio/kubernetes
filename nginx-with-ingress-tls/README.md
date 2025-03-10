# 🔒 Nginx with Ingress TLS

## 📄 Documentation
This directory contains Kubernetes configurations for deploying Nginx with TLS-enabled Ingress. It creates 1 pod with 1 service attached as ClusterIP, then creates an ingress to forward the traffic with TLS encryption.

### 1-webapp-hello-v1.yaml
Deploys the hello-app application.

### 3-webapp-hello-service-v1.yaml
Creates a ClusterIP service for the deployment.

### 5-ingress.yaml
Creates an Ingress resource with TLS configuration that routes traffic to the service.

### 6-secret.yaml
Contains the TLS certificate and key as a Kubernetes Secret.

## 📋 Usage
Apply the configurations in the following order:

```bash
kubectl apply -f 1-webapp-hello-v1.yaml
kubectl apply -f 3-webapp-hello-service-v1.yaml
kubectl apply -f 6-secret.yaml
kubectl apply -f 5-ingress.yaml
```

After applying, the application will be accessible at `https://test.rutamania.com/`.

Note: For testing with self-signed certificates, refer to the guide at https://segunale.blogspot.com/2024/09/self-signed-certificate-for-kubernetes.html

## 🏗️ Architecture diagram
```mermaid
flowchart TD
    %% External traffic at the top
    extTraffic["External Traffic (HTTPS)"] --> ing
    
    %% Ingress
    subgraph "Ingress: tls-ingress"
        ing["tls-ingress"] --> rule["Host: test.rutamania.com"]
        ing --> tls["TLS: secret-tls"]
    end
    
    %% Secret
    tls --> secret["Secret: secret-tls<br>Type: kubernetes.io/tls"]
    
    %% Service
    rule --> svc["Service: webapp-hello-service-v1<br>Type: ClusterIP<br>Port: 80:8080"]
    
    %% Deployment
    subgraph "Deployment: webapp-hello-v1"
        svc --> dep["webapp-hello-v1<br>Replicas: 1"]
        dep --> pod["Pod: webapp-hello-v1<br>Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:1.0<br>Port: 8080"]
    end
    
    classDef ingress fill:#f9f,stroke:#333,stroke-width:1px,color:#000000
    classDef service fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    classDef deployment fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef pod fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef secret fill:#ffcccc,stroke:#333,stroke-width:1px,color:#000000
    classDef traffic fill:#f5f5f5,stroke:#333,stroke-width:1px,color:#000000
    
    class ing,rule,tls ingress
    class svc service
    class dep deployment
    class pod pod
    class secret secret
    class extTraffic traffic
