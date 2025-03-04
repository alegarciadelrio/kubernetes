# Kubernetes Toolbox

<h3>🔭 This repository is a set of Kubernetes examples.</h3>
<p>
  <img alt="bash" src="https://img.shields.io/badge/-Bash-grey?style=flat-square&logo=linux&logoColor=white" />
  <img alt="Kubernetes" src="https://img.shields.io/badge/-Kubernetes-blue?style=flat-square&logo=kubernetes&logoColor=white" />
</p>


## nginx-with-ingress
Creates 2 pods with 2 services attached as ClusterIp, then creates an ingress to forward the traffic based on the host v1 or v2.

## nginx-with-ingress-tls
Creates 1 pod with 1 service attached as ClusterIp, then creates an ingress to forward the traffic, the ingress uses a secret. More info to test certificate: 
https://segunale.blogspot.com/2024/09/self-signed-certificate-for-kubernetes.html

## nginx-with-ingress-class-controller
Creates in another namespace the controller. Then creates 2 pods with 2 services attached as ClusterIp, after that creates an ingress to forward the traffic based on the host v1 or v2, and an ingress class pointing to the controller. 

## service-account-for-eks-azure-devops
Service account to connect EKS to Azure DevOps.

## installation-script-ubuntu
Kubernetes installation script on Ubuntu Server.
