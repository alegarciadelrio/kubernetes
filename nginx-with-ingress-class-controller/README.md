# Nginx with Ingress Class Controller

## Documentation
This directory contains Kubernetes configurations for deploying Nginx with a dedicated Ingress controller in a separate namespace. It creates the controller in another namespace, then creates 2 pods with 2 services attached as ClusterIP, after that creates an ingress to forward the traffic based on the host v1 or v2, and an ingress class pointing to the controller.

### 1-nginx-namespace.yaml
Creates a dedicated namespace for the Nginx Ingress controller.

### 2-nginx-configmap.yaml
Creates a ConfigMap for the Nginx Ingress controller configuration.

### 3-nginx-service-account.yaml
Creates a ServiceAccount for the Nginx Ingress controller.

### 4-nginx-clusterrole-binding.yaml
Creates ClusterRole and ClusterRoleBinding for the Nginx Ingress controller.

### 5-nginx-secret.yaml
Creates a Secret for the Nginx Ingress controller.

### 6-nginx-controller-deployment.yaml
Deploys the Nginx Ingress controller.

### 7-nginx-controller-service-admission.yaml
Creates a Service for the Nginx Ingress controller's admission webhook.

### 8-nginx-controller-service.yaml
Creates a Service for the Nginx Ingress controller.

### 10-webapp-hello-v1.yaml
Deploys the first version of the hello-app application.

### 11-webapp-hello-v2.yaml
Deploys the second version of the hello-app application.

### 12-webapp-hello-service-v1.yaml
Creates a ClusterIP service for the v1 deployment.

### 13-webapp-hello-service-v2.yaml
Creates a ClusterIP service for the v2 deployment.

### 14-ingress-class.yaml
Defines the IngressClass resource that specifies which controller should implement the Ingress.

### 15-ingress.yaml
Creates an Ingress resource that routes traffic based on the host header and uses the defined IngressClass.

## Usage
Apply the configurations in the following order:

```bash
# First, set up the Nginx Ingress controller
kubectl apply -f 1-nginx-namespace.yaml
kubectl apply -f 2-nginx-configmap.yaml
kubectl apply -f 3-nginx-service-account.yaml
kubectl apply -f 4-nginx-clusterrole-binding.yaml
kubectl apply -f 5-nginx-secret.yaml
kubectl apply -f 6-nginx-controller-deployment.yaml
kubectl apply -f 7-nginx-controller-service-admission.yaml
kubectl apply -f 8-nginx-controller-service.yaml

# Then, deploy the applications and Ingress
kubectl apply -f 10-webapp-hello-v1.yaml
kubectl apply -f 11-webapp-hello-v2.yaml
kubectl apply -f 12-webapp-hello-service-v1.yaml
kubectl apply -f 13-webapp-hello-service-v2.yaml
kubectl apply -f 14-ingress-class.yaml
kubectl apply -f 15-ingress.yaml
```

## Architecture diagram
```mermaid
flowchart TD
    %% External traffic at the top
    extTraffic["External Traffic"] --> ctrlSvc
    
    %% Nginx Ingress Controller
    subgraph "Namespace: nginx-ingress"
        ctrlSvc["Service: nginx-ingress-controller<br>Type: LoadBalancer"] --> ctrlDep
        ctrlDep["Deployment: nginx-ingress-controller"] --> ctrlPod["Pod: nginx-ingress-controller"]
        ctrlPod --> ctrlCont["Container: controller<br>Image: registry.k8s.io/ingress-nginx/controller:v1.11.2"]
        
        %% Controller resources
        ctrlCM["ConfigMap: nginx-ingress-controller"] --> ctrlPod
        ctrlSA["ServiceAccount: nginx-ingress"] --> ctrlPod
        ctrlSecret["Secret: nginx-ingress-admission"] --> ctrlPod
    end
    
    %% IngressClass
    ingClass["IngressClass: nginx-class<br>Controller: nginx.org/ingress-controller"] --> ctrlPod
    
    %% Ingress
    subgraph "Namespace: default"
        ing["Ingress"] --> ingClass
        ing --> rule1["Host: v1.test.com"]
        ing --> rule2["Host: v2.test.com"]
        
        %% Services
        rule1 --> svc1["Service: webapp-hello-service-v1<br>Type: ClusterIP<br>Port: 80:8080"]
        rule2 --> svc2["Service: webapp-hello-service-v2<br>Type: ClusterIP<br>Port: 80:8080"]
        
        %% Deployments
        svc1 --> dep1["Deployment: webapp-hello-v1<br>Replicas: 1"]
        dep1 --> pod1["Pod: webapp-hello-v1<br>Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:1.0"]
        
        svc2 --> dep2["Deployment: webapp-hello-v2<br>Replicas: 1"]
        dep2 --> pod2["Pod: webapp-hello-v2<br>Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:2.0"]
    end
    
    classDef controller fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef ingress fill:#f9f,stroke:#333,stroke-width:1px,color:#000000
    classDef service fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    classDef deployment fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef pod fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef config fill:#ffcccc,stroke:#333,stroke-width:1px,color:#000000
    classDef traffic fill:#f5f5f5,stroke:#333,stroke-width:1px,color:#000000
    
    class ctrlSvc,ctrlDep,ctrlPod,ctrlCont controller
    class ctrlCM,ctrlSA,ctrlSecret config
    class ing,rule1,rule2,ingClass ingress
    class svc1,svc2 service
    class dep1,dep2 deployment
    class pod1,pod2 pod
    class extTraffic traffic
