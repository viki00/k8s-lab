vi /etc/hosts
sudo su -
exit
ip addr
sudo su -
vi test.py
sudo su -
exit
vi test.tmp
rm test.tmp 
sudo su -
nslookup vik1
nslookup vik2
sudo su -
nslookup vik2
sudo su -
nslookup vik1
nslookup vik2
nslookup vik3
nslookup vik4
nslookup vik5
ssh vik@vik1
ssh kubeadmin@vik1
ssh kubeadmin@10.0.0.92
ssh-keygen -t rsa -b 4096
ssh-copy-id kubeadmin@10.0.0.92
ssh kubeadmin@10.0.0.92
ssh kubeadmin@vik1
ssh kubeadmin@10.0.0.194
ssh-copy-id kubeadmin@10.0.0.194
ssh kubeadmin@10.0.0.194
ssh kubeadmin@vik2
ssh-copy-id kubeadmin@10.0.0.204
ssh kubeadmin@10.0.0.204
ssh kubeadmin@vik3
ssh-copy-id kubeadmin@10.0.0.55
ssh kubeadmin@10.0.0.55
ssh kubeadmin@vik4
ssh-copy-id kubeadmin@10.0.0.96
ssh kubeadmin@10.0.0.96
ssh kubeadmin@vik5
clear
mkdir kubespray
cd kubespray/
cd ..
rm -rf kubespray/
git clone https://github.com/kubernetes-sigs/kubespray.git
sudo apt install git
apt-get update
sudo apt-get update
ping google.com
ping 1.1.1.1
apt update
sudo sapt update
sudo apt update
ping 10.0.0.1
ping 1.1.1.1
ping google.com
ip a
exit
ip a
exit
ping google.com
ethtool eno2
ip link
ping google.com
ping 8.8.8.8
systemctl start 
cat /etc/resolv.conf
sudo su -
sudo visudo
sudo apt update
systemctl status dnsmasq.service
ping 1.1.1.1
ping google.com
sudo cat /etc/resolv.conf 
vi /etc/resolv.conf 
suo vi /etc/resolv.conf 
sudo vi /etc/resolv.conf 
sudo echo "nameserver 1.1.1.1" | sudo tee /etc/dnsmasq.upstream
sudo vi /etc/dnsmasq.conf
sudo systemctl restart dnsmasq
sudo echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
ping google.com
sudo systemctl restart dnsmasq
ping google.com
sudo su -
exit
sudo apt update
sudo apt install ansible -y
sudo su -
ssh-copy-id vik@10.0.0.92
ssh-copy-id vik@10.0.0.194
ssh-copy-id vik@10.0.0.204
ssh-copy-id vik@10.0.0.55
ssh-copy-id vik@10.0.0.96
mkdir ~/ansible-lab && cd ~/ansible-lab
vi hosts.ini
vi [vik_nodes]
vik1 ansible_host=10.0.0.92
vik2 ansible_host=10.0.0.194
vik3 ansible_host=10.0.0.204
vik4 ansible_host=10.0.0.55
vik5 ansible_host=10.0.0.96
[vik_nodes:vars]
ansible_user=vik
ansible_python_interpreter=/usr/bin/python3
q!
vi sudo_nopass.yml
ansible-playbook -i hosts.ini sudo_nopass.yml
cd
ansible-playbook -i hosts.ini sudo_nopass.yml
cd ansible-lab/
ls
ansible-playbook -i hosts.ini sudo_nopass.yml
ansible-playbook -i hosts.ini sudo_nopass.yml --ask-become-pass --limit vik5
sudo su -
ls -al
ls -altr
cd ansible-lab/
ls -al
ansible-playbook -i hosts.ini sudo_nopass.yml --ask-become-pass --limit vik5
ansible-playbook -i hosts.ini sudo_nopass.yml --ask-become-pass
ssh vik@vik1
sudo su -
ls -al
vi hosts.ini 
vi sudo_nopass.yml 
cp sudo_nopass.yml sudo_nopass_kubeadmin.yml
vi sudo_nopass_kubeadmin.yml 
ansible-playbook -i hosts.ini sudo_nopass_kubeadmin.yml --ask-become-pass
vi hosts.ini 
cp hosts.ini kubehosts.ini
vi kubehosts.ini 
ansible-playbook -i kubehosts.ini sudo_nopass_kubeadmin.yml --ask-become-pass
exit
sudo su -
ssh vik@vik1
sudo su -
cd ~/.kube/config
sudo su -
k get nodes 
kubectl get nodes
ls -al
sudo su -
sudo su - 
mkdir -p .kube
cd .kube
vi config
cd
kubectl get nodes
kubectl get nodes -o wide
ls -al
vi .bashrc 
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source .bashrc
vi .bashrc
git
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
vi metallb-config.yml
kubectl apply -f metallb-config.yml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/baremetal/deploy.yaml
kubectl -n ingress-nginx get pods
kubectl get svc -n ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx   --namespace ingress-nginx   --create-namespace
sudo snap install helm
snap install helm
sudo snap install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx   --namespace ingress-nginx   --create-namespace
k get po 
k get po -A
kubectl -n kube-system get pods -l k8s-app=cilium
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
vi metallb.yaml
k apply -f metallb
k apply -f metallb.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/baremetal/deploy.yaml
kubectl -n ingress-nginx get pods
kubectl get svc -n ingress-nginx
exit
sudo su -
sudo systemctl disable wg-quick@wg0
sudo vi /etc/wireguard/wg0
sudo vi /etc/wireguard/wg0.conf
sudo wg-quick up wg0
sudo cat /etc/wireguard/private.key | wg pubkey
sudo cat /etc/wireguard/
sudo su -
k get po
k get nodes
ssh vik@10.0.0.194
ping 10.0.0.194
ping 10.0.0.195
ssh vik@10.0.0.195
vi /etc/hosts
k get nodes
ssh vik1
k get nodes
vi /etc/hosts
sudo su -
ssh vik2
k get nodes
npm install -g @google/gemini-cli
sudo apt install npm
sudo apt install npm --fix-missing
sudo apt --fix-broken install
sudo apt remove npm nodejs node-gyp libnode-dev
sudo apt remove npm nodejs node-gyp libnode-dev --fix-broken
sudo apt remove npm nodejs node-gyp libnode-dev 
apt --fix-broken install
sudo apt --fix-broken install
sudo apt update
apt list --upgradeable
sudo apt --fix-broken install
sudo apt remove npm nodejs node-gyp libnode-dev
sudo apt autoremove
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
exit
sudo su 0
sudo su -
gemini
cat .bashrc
sudo npm install -g @google/gemini-cli
npm install -g @google/gemini-cli
source ~/.bashrc
nvm install --lts
npm -v
npm install -g @google/gemini-cli
gemini
sudo su -
gemini
sudo su -
gemini
cd /home/vik
ls -al
cd monitoring/
ls -al
cat node_exporter_full.json
sudo su -
gemini
sudo su -
gemini
exit
gemini
ls -al
cd puppet/
ls -al
cat README.md 
