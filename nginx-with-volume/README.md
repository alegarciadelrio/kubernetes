# 💾 Nginx with Volume

## 📄 Documentation
This directory contains Kubernetes configurations for deploying Nginx with various volume configurations. It demonstrates different ways to mount volumes into containers, including ConfigMaps and downward API.

### 01-pod.yaml
Basic pod configuration for Nginx.

### 02-pod.yaml
Pod with volume configuration.

### 03-service-node-port.yaml
NodePort service for accessing the Nginx pods.

### 04-pod-downwardapi.yaml
Pod with downward API volume, which allows the pod to access its own metadata.

### 05-pod-configmap.yaml
Pod with ConfigMap volume, which mounts the ConfigMap data as files in the container.

### 06-index-configmap.yaml
ConfigMap containing HTML content to be mounted in the Nginx pod.

## 📋 Usage
Apply the configurations in the following order:

```bash
# Create the ConfigMap first
kubectl apply -f 06-index-configmap.yaml

# Then create the pod that uses the ConfigMap
kubectl apply -f 05-pod-configmap.yaml

# Create other resources as needed
kubectl apply -f 03-service-node-port.yaml
```

After applying, you can access the Nginx pod with the ConfigMap content through the NodePort service.

## 🏗️ Architecture diagram
```mermaid
flowchart TD
    %% External traffic
    extTraffic["External Traffic"] --> svc
    
    %% Service
    svc["Service: NodePort<br>Port: 80:80<br>NodePort: 30080"] --> pod
    
    %% Pod with ConfigMap
    subgraph "Pod: nginx-02"
        pod["Pod: nginx-02"] --> cont["Container: nginx<br>Image: nginx"]
        cont --> mount["VolumeMount:<br>/usr/share/nginx/html"]
        mount --> vol["Volume: index"]
        vol --> cm["ConfigMap: index-html<br>Data: index.html"]
    end
    
    %% Other Pods
    subgraph "Other Pod Configurations"
        pod1["Pod: Basic Nginx<br>(01-pod.yaml)"]
        pod2["Pod: With Volume<br>(02-pod.yaml)"]
        pod3["Pod: With Downward API<br>(04-pod-downwardapi.yaml)"]
    end
    
    classDef service fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    classDef pod fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef volume fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef configmap fill:#ffcccc,stroke:#333,stroke-width:1px,color:#000000
    classDef traffic fill:#f5f5f5,stroke:#333,stroke-width:1px,color:#000000
    
    class svc service
    class pod,pod1,pod2,pod3,cont pod
    class mount,vol volume
    class cm configmap
    class extTraffic traffic
