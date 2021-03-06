# DEMO 5 - SQL Server Kubernetes deployment
#   1- Create namespace, secret, pvc, service and SQL Server deployment
#   2- Check namespace, secret, pvc, service and pod
#   3- Check pod (SQL Server) logs
# -----------------------------------------------------------------------------
# References
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Deploy a SQL Server container in Kubernetes with Azure Kubernetes Services (AKS)
#   https://docs.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15

# 0- Env variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_05;
sa_password="_EnDur@nc3_";

# 1- Create namespace, secret, pvc, service and SQL Server deployment
# Create namespace
kubectl create namespace case-sql

# Set Kubernetes context to new namespace
kubectl config set-context --current --namespace=case-sql
kubectl config get-contexts

# Create secret for SA password
kubectl create secret generic case-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"

# Create PVC
kubectl apply -f ./persistent-volumes/pvc-data-case.yaml

# Create service (Load balancer)
kubectl apply -f ./services/srvc-sql-case.yaml

# Create SQL Server deployment (Pod)
kubectl apply -f ./deployments/depl-sql-case.yaml --record

# 2- Check namespace, secret, pvc, service and pod
# Checking all resources on case-sql namespace
kubectl get pvc
kubectl get services
kubectl get pods
pod=`kubectl get pods | grep mssql-case-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 3- Check pod logs
kubectl logs $pod -f

# Check pod from Docker CLI
docker stats --all --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"