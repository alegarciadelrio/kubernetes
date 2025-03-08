# Service Account for EKS and Azure DevOps

## Documentation
This directory contains Kubernetes configuration for setting up a service account that can be used to connect Amazon EKS to Azure DevOps for CI/CD pipelines.

### 1-service-account.yml
This file contains multiple Kubernetes resources:

1. **ServiceAccount**: `deploy-robot`
   - Creates a service account for deployment operations
   - `automountServiceAccountToken: false` for security

2. **Secret**: `deploy-robot-secret`
   - Creates a secret containing the service account token
   - Annotated to link it to the service account

3. **Role**: `deploy-robot-role`
   - Defines permissions for the service account
   - Grants specific permissions for deployments and pods

4. **RoleBinding**: `global-rolebinding`
   - Binds the role to the service account within the default namespace

5. **ClusterRoleBinding**: `cluster-role-binding`
   - Grants cluster-admin privileges to the service account

## Usage

Apply the configuration:

```bash
kubectl apply -f 1-service-account.yml
```

After applying, you can retrieve the token for use in Azure DevOps:

```bash
kubectl get secret deploy-robot-secret -o jsonpath="{.data.token}" | base64 --decode
```

Use this token in Azure DevOps to authenticate with your EKS cluster.

## Architecture diagram
```mermaid
flowchart TD
    %% Service Account
    sa["ServiceAccount: deploy-robot"] --> secret["Secret: deploy-robot-secret<br>Type: kubernetes.io/service-account-token"]
    
    %% Role and Permissions
    role["Role: deploy-robot-role"] --> perm1["Permission: apps/deployments<br>create, delete"]
    role --> perm2["Permission: pods<br>create, delete"]
    
    %% Bindings
    rb["RoleBinding: global-rolebinding"] --> sa
    rb --> role
    
    crb["ClusterRoleBinding: cluster-role-binding"] --> sa
    crb --> cr["ClusterRole: cluster-admin"]
    
    %% Azure DevOps Integration
    secret --> token["Token for Authentication"]
    token --> azdo["Azure DevOps<br>Kubernetes Service Connection"]
    
    %% Deployment Flow
    azdo --> deploy["Deploy to EKS"]
    
    classDef account fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef secret fill:#ffcccc,stroke:#333,stroke-width:1px,color:#000000
    classDef role fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef binding fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    classDef external fill:#f5f5f5,stroke:#333,stroke-width:1px,color:#000000
    
    class sa account
    class secret,token secret
    class role,cr,perm1,perm2 role
    class rb,crb binding
    class azdo,deploy external
