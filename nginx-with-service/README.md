# Basic Kubernetes Deployment

## Documentation
Creates 6 pods with 1 service attached as NodePort. Ideally for local testing purposes. 

### 1-webapp-hello-v1.yaml
It does the nginx pod deployment.

### 2-webapp-hello-service-v1.yaml
It does the service nodport deployment.

## Architecture diagram
Creates 6 pods with 1 service attached as NodePort.

```mermaid
flowchart TD
    %% External traffic at the top
    extTraffic["External Traffic<br>NodePort: 30080"] --> svc
    
    %% Service at the top
    subgraph "Service: webapp-hello-service-v1"
        svc["webapp-hello-service-v1<br>Type: NodePort"] --> sel["Selector: app=webapp-hello-v1"]
        svc --> portMap["Ports: 80:8080<br>NodePort: 30080"]
    end
    
    %% Connection between Service and Pods
    sel -.-> pod1
    sel -.-> podN
    
    subgraph "Deployment: webapp-hello-v1"
        direction TB
        dep["webapp-hello-v1<br>Replicas: 2"] --> pod1["Pod 1"]
        dep --> podN["Pod N"]
        
        subgraph "Pod Template"
            pod1 --> cont1["Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:1.0<br>Port: 8080"]
            podN --> contN["Container: webapp-hello<br>Image: gcr.io/google-samples/hello-app:1.0<br>Port: 8080"]
        end
        
        classDef resources fill:#ffffff,stroke:#333,stroke-width:1px
        class cont1,contN resources
        
        %% Resources
        cont1 --- res1["Resources<br>Requests: 64Mi, 200m<br>Limits: 128Mi, 500m"]
        contN --- resN["Resources<br>Requests: 64Mi, 200m<br>Limits: 128Mi, 500m"]
    end
    
    classDef deployment fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef service fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    classDef pod fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef traffic fill:#f5f5f5,stroke:#333,stroke-width:1px,color:#000000
    classDef resources fill:#ffffff,stroke:#333,stroke-width:1px,color:#000000
    
    class dep deployment
    class svc,sel,portMap service
    class pod1,podN pod
    class extTraffic traffic
    class res1,resN resources
```
