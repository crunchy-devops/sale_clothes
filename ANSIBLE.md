## install on kubernetes kind
```shell
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.27.0/kind-linux-amd64
mv kind-linux-amd64 kind
chmod +x kind
sudo mv kind /usr/local/bin/kind
kind version # should be  version 0.27.0
```
## install kubectl
```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
# add in .bashrc
alias ks='kubectl'
source <(kubectl completion bash | sed s/kubectl/ks/g)
# check 
kubectl version
```

## Create a cluster
```shell
cd /home/ubuntu/jenkins-pic/kind
kind create cluster --name awx --config kind-config-cluster.yml
ks version # should be version  v1.32.2+
ks get nodes # see one controle-plane and 3 workers
```