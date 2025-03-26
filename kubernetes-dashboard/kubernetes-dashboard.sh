#/bin/sh

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

 # Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

# Expose kubernetes-dashboard to 30443
sudo bash -c 'cat << 'EOF' > kubernetes-dashboard-nodeport.yaml
apiVersion: v1
kind: Service
metadata:
  name: kubernetes-dashboard-nodeport
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
  - port: 443
    targetPort: 8443
    nodePort: 30443
  selector:
    # You need to use the same selector as the original service
    # Replace these with the actual selectors from your original service
    app.kubernetes.io/component: app
    app.kubernetes.io/instance: kubernetes-dashboard
    app.kubernetes.io/name: kong
EOF'
kubectl apply -f kubernetes-dashboard-nodeport.yaml

# Add dashboard-admin for kubernetes-dashboard namespace and create token
kubectl -n kubernetes-dashboard create serviceaccount dashboard-admin
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin
kubectl -n kubernetes-dashboard create token dashboard-admin --duration=8760h
echo "Please use the token key above to sign in on kubernetes dashboard."

# Optional expose temporary the kubernetes-dashboard-kong-proxy 
# kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8443:443