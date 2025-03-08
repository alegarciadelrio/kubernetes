# Kubernetes Installation Scripts for Ubuntu

## Documentation
This directory contains scripts for installing Kubernetes on Ubuntu servers. These scripts automate the process of setting up a Kubernetes cluster with a master node and worker nodes.

### master-node-setup.sh
This script sets up a master node (control plane) for a Kubernetes cluster. It performs the following tasks:
- Installs Docker and containerd
- Installs kubectl, kubeadm, and kubelet
- Disables swap (required for Kubernetes)
- Configures kernel modules and system settings
- Initializes the Kubernetes cluster with kubeadm
- Sets up kubectl configuration
- Deploys Calico network plugin

### node-setup.sh
This script sets up a worker node for a Kubernetes cluster. It performs the following tasks:
- Installs Docker and containerd
- Installs kubectl, kubeadm, and kubelet
- Disables swap
- Configures kernel modules and system settings
- Joins the Kubernetes cluster using the token provided by the master node

## Usage

### Setting up the Master Node
1. Edit the script to set the `MASTERNODE` variable to your master node's hostname
2. Make the script executable: `chmod +x master-node-setup.sh`
3. Run the script: `./master-node-setup.sh`

### Setting up Worker Nodes
1. Edit the script to set the `MASTERNODE` variable to your master node's hostname
2. Update the `/etc/hosts` entry with the correct IP address of your master node
3. Replace the `kubeadm join` command with the one provided by the master node during its initialization
4. Make the script executable: `chmod +x node-setup.sh`
5. Run the script: `./node-setup.sh`

## Architecture diagram
```mermaid
flowchart TD
    subgraph "Kubernetes Cluster"
        direction TB
        
        subgraph "Master Node"
            direction TB
            apiserver["API Server"] --> etcd["etcd"]
            apiserver --> controller["Controller Manager"]
            apiserver --> scheduler["Scheduler"]
            kubelet1["Kubelet"] --> apiserver
            docker1["Docker/containerd"] --> kubelet1
        end
        
        subgraph "Worker Node 1"
            direction TB
            kubelet2["Kubelet"] --> apiserver
            docker2["Docker/containerd"] --> kubelet2
            pod1["Pod 1"] --> docker2
            pod2["Pod 2"] --> docker2
        end
        
        subgraph "Worker Node 2"
            direction TB
            kubelet3["Kubelet"] --> apiserver
            docker3["Docker/containerd"] --> kubelet3
            pod3["Pod 3"] --> docker3
            pod4["Pod 4"] --> docker3
        end
        
        calico["Calico Network Plugin"] --> apiserver
    end
    
    classDef master fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef worker fill:#e6ffe6,stroke:#333,stroke-width:1px,color:#000000
    classDef component fill:#ffffff,stroke:#333,stroke-width:1px,color:#000000
    classDef pod fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    
    class apiserver,etcd,controller,scheduler,kubelet1,docker1 master
    class kubelet2,docker2,kubelet3,docker3 worker
    class pod1,pod2,pod3,pod4 pod
    class calico component
