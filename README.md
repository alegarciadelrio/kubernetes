# kubernetes
This repository is a set of Kubernetes examples.

nginx-with-ingress : creates 2 pods with 2 services attached as ClusterIp, then creates an ingress to forward the traffic based on the host v1 or v2.

nginx-with-ingress-tls : creates 1 pod with 1 service attached as ClusterIp, then creates an ingress to forward the traffic, the ingress uses a secret. More info to test certificate: 
https://segunale.blogspot.com/2024/09/self-signed-certificate-for-kubernetes.html

nginx-with-ingress-class-controller : creates in another namespace the controller. Then creates 2 pods with 2 services attached as ClusterIp, after that creates an ingress to forward the traffic based on the host v1 or v2, and an ingress class pointing to the controller. 
