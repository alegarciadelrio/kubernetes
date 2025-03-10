# 🚦 Nginx with Ingress

## 📄 Documentation
This directory contains Kubernetes configurations for deploying Nginx with Ingress. It creates 2 pods with 2 services attached as ClusterIP, then creates an ingress to forward the traffic based on the host v1 or v2.

### 🌐 1-webapp-hello-v1.yaml
Deploys the first version of the hello-app application.

### 🌐 2-webapp-hello-v2.yaml
Deploys the second version of the hello-app application.

### 🔌 3-webapp-hello-service-v1.yaml
Creates a ClusterIP service for the v1 deployment.

### 🔌 4-webapp-hello-service-v2.yaml
Creates a ClusterIP service for the v2 deployment.

### 🚦 5-ingress.yaml
Creates an Ingress resource that routes traffic based on the host header:
- v1.test.com routes to the v1 service
- v2.test.com routes to the v2 service

## 📋 Usage
Apply the configurations in the following order:

```bash
kubectl apply -f 1-webapp-hello-v1.yaml
kubectl apply -f 2-webapp-hello-v2.yaml
kubectl apply -f 3-webapp-hello-service-v1.yaml
kubectl apply -f 4-webapp-hello-service-v2.yaml
kubectl apply -f 5-ingress.yaml
```

After applying, the applications will be accessible at:
- http://v1.test.com/ (routes to v1 service)
- http://v2.test.com/ (routes to v2 service)

Note: You'll need to add entries to your `/etc/hosts` file to map these hostnames to your cluster's IP address.

## 🏗️ Architecture diagram
```mermaid
flowchart TD
    %% External traffic at the top
    extTraffic["External Traffic"] --> ing
    
    %% Ingress
    subgraph "Ingress: simple-ingress"
        ing["simple-ingress"] --> rule1["Host: v1.test.com"]
        ing --> rule2["Host: v2.test.com"]
    end
    
    %% Services
    rule1 --> svc1["Service: webapp-hello-service-v1<br>Type: ClusterIP<br>Port: 80:8080"]
    rule2 --> svc2["Service: webapp-hello-service-v2<br>Type: ClusterIP<br>Port: 80:8080"]
    
    %% Deployments
    subgraph "Deployment: webapp-hello-v1"
        svc1 --> dep1["webapp-hello-v1<br>Replicas: 1"]
        dep1 --> pod1["Pod: webapp-hello-v1<br>Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:1.0<br>Port: 8080"]
    end
    
    subgraph "Deployment: webapp-hello-v2"
        svc2 --> dep2["webapp-hello-v2<br>Replicas: 1"]
        dep2 --> pod2["Pod: webapp-hello-v2<br>Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:2.0<br>Port: 8080"]
    end
    
    classDef ingress fill:#f9f,stroke:#333,stroke-width:1px,color:#000000
    classDef service fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    classDef deployment fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef pod fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef traffic fill:#f5f5f5,stroke:#333,stroke-width:1px,color:#000000
    
    class ing,rule1,rule2 ingress
    class svc1,svc2 service
    class dep1,dep2 deployment
    class pod1,pod2 pod
    class extTraffic traffic
