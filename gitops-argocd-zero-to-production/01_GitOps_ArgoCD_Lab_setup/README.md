# 🚀 01 - GitOps & ArgoCD Lab Setup | TECH MAHATO

> **Production-Ready Lab Environment for ArgoCD on AWS**
>
> By **Arbind Kr. Mahato** | [TECH MAHATO](https://www.youtube.com/techmahato)

---

## 📋 Table of Contents

1. [Create IAM User with Admin Access](#1-create-iam-user-with-admin-access)
2. [Install AWS CLI v2 on Your Laptop](#2-install-aws-cli-v2-on-your-laptop)
3. [Create and Setup IAM Profile](#3-create-and-setup-iam-profile)
4. [Create EC2 Instance (T3a.large)](#4-create-ec2-instance-t3alarge)
5. [Login to EC2 Instance through CLI](#5-login-to-ec2-instance-through-cli)
6. [ArgoCD Setup and Installation](#6-argocd-setup-and-installation)

---

## 1. Create IAM User with Admin Access

### Step 1: Create IAM User

1. Go to **AWS Console** → **IAM** → **Users** → **Create User**
2. Enter username: `argocd-admin` (or your preferred name)
3. Select **Provide user access to the AWS Management Console** (optional)
4. Click **Next**

### Step 2: Attach Admin Policy

1. Select **Attach policies directly**
2. Search and select: `AdministratorAccess`
3. Click **Next** → **Create User**

### Step 3: Create Access Key & Secret Key

1. Go to the newly created user → **Security credentials** tab
2. Click **Create access key**
3. Select **Command Line Interface (CLI)**
4. Acknowledge the recommendation and click **Next**
5. Add description tag (optional): `argocd-lab-key`
6. Click **Create access key**
7. **⚠️ IMPORTANT:** Download the `.csv` file or copy both keys immediately — the Secret Key won't be shown again!

```
Access Key ID:     AKIA_XXXXXXXXXXXX
Secret Access Key: xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

> **🔒 Security Note:** Never commit these keys to Git. Use IAM profiles or environment variables.

---

## 2. Install AWS CLI v2 on Your Laptop

### For Linux / Ubuntu / WSL

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### For macOS

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version
```

### For Windows

Download and run the MSI installer:
- [AWS CLI v2 Windows Installer](https://awscli.amazonaws.com/AWSCLIV2.msi)

```powershell
aws --version
```

### Verify Installation

```bash
aws --version
# Output: aws-cli/2.x.x Python/3.x.x ...
```

---

## 3. Create and Setup IAM Profile

### Configure AWS CLI Profile

```bash
aws configure --profile argocd-lab
```

Enter the following when prompted:

```
AWS Access Key ID [None]: <YOUR_ACCESS_KEY_ID>
AWS Secret Access Key [None]: <YOUR_SECRET_ACCESS_KEY>
Default region name [None]: ap-south-1
Default output format [None]: json
```

### Set as Default Profile (Optional)

```bash
export AWS_PROFILE=argocd-lab
```

Or add to `~/.bashrc` / `~/.zshrc`:

```bash
echo 'export AWS_PROFILE=argocd-lab' >> ~/.bashrc
source ~/.bashrc
```

### Verify Profile

```bash
aws sts get-caller-identity --profile argocd-lab
```

Expected output:

```json
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/argocd-admin"
}
```

---

## 4. Create EC2 Instance (T3a.large)

### Instance Specifications

| Setting | Value |
|---------|-------|
| **Instance Type** | t3a.large (2 vCPU, 8 GB RAM) |
| **AMI** | Ubuntu 22.04 LTS / 24.04 LTS |
| **VPC** | Public VPC |
| **Subnet** | Public Subnet |
| **Public IP** | ✅ Enable Auto-assign |
| **Storage** | 30 GB gp3 |
| **Key Pair** | Create or use existing |

### Security Group Rules

| Type | Protocol | Port Range | Source | Description |
|------|----------|-----------|--------|-------------|
| SSH | TCP | 22 | Your Laptop IP/32 | SSH Access |
| HTTP | TCP | 80 | 0.0.0.0/0 | HTTP Traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | HTTPS Traffic |
| Custom TCP | TCP | 8080 | 0.0.0.0/0 | ArgoCD UI |

### 🔍 Command to Check Your Laptop's Public IP

```bash
curl -s ifconfig.me
# OR
curl -s ipinfo.io/ip
# OR
curl -s checkip.amazonaws.com
```

Use this IP in your Security Group for port 22 (SSH) to restrict access only to your machine.

### Create via AWS CLI (Optional)

```bash
# Create Key Pair
aws ec2 create-key-pair \
  --key-name argocd-lab-key \
  --query 'KeyMaterial' \
  --output text > argocd-lab-key.pem

chmod 400 argocd-lab-key.pem

# Get your public IP
MY_IP=$(curl -s ifconfig.me)

# Create Security Group
SG_ID=$(aws ec2 create-security-group \
  --group-name argocd-lab-sg \
  --description "ArgoCD Lab Security Group" \
  --query 'GroupId' \
  --output text)

# Add Inbound Rules
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr ${MY_IP}/32
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 8080 --cidr 0.0.0.0/0

# Launch EC2 Instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id ami-0f5ee92e2d63afc18 \
  --instance-type t3a.large \
  --key-name argocd-lab-key \
  --security-group-ids $SG_ID \
  --associate-public-ip-address \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":30,"VolumeType":"gp3"}}]' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ArgoCD-Lab-Server}]' \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instance ID: $INSTANCE_ID"

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get Public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Public IP: $PUBLIC_IP"
```

---

## 5. Login to EC2 Instance through CLI

### SSH into the EC2 Instance

```bash
ssh -i argocd-lab-key.pem ubuntu@<PUBLIC_IP>
```

### First Time Setup (Update the System)

```bash
sudo apt-get update && sudo apt-get upgrade -y
```

### Verify Connection

```bash
hostname -I        # Shows private IP
curl ifconfig.me   # Shows public IP
```

---

## 6. ArgoCD Setup and Installation

### Prerequisites

Install the following tools on your EC2 instance:

#### 1. Docker

```bash
sudo apt-get update
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
docker --version
docker ps
```

#### 2. Kind (Kubernetes in Docker)

```bash
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind version
```

#### 3. kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

#### 4. Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

### Step 1: Create Kind Cluster

Save your cluster config as `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "<YOUR_EC2_PRIVATE_IP>"   # Run: hostname -I
  apiServerPort: 33893
nodes:
  - role: control-plane
    image: kindest/node:v1.33.1
  - role: worker
    image: kindest/node:v1.33.1
  - role: worker
    image: kindest/node:v1.33.1
```

> 💡 **Why `apiServerAddress`?**
> This ensures the Kind cluster API server is reachable from ArgoCD pods. It avoids conflicts since Kind defaults to random localhost ports.

Create the cluster:

```bash
kind create cluster --name argocd-cluster --config kind-config.yaml
```

Verify:

```bash
kubectl cluster-info
kubectl get nodes
```

---

### Step 2: Install ArgoCD

#### 🔥 Quick Setup (Recommended) — Use Our Script!

```bash
chmod +x setup_argocd.sh
./setup_argocd.sh
```

> The script auto-detects your EC2 private IP, creates the Kind cluster, installs ArgoCD (Helm or Manifests — your choice), installs the ArgoCD CLI, and provides login credentials. All branded with ❤️ by **TECH MAHATO**.

---

#### Manual Method 1: Install ArgoCD using Helm (Production)

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd -n argocd
kubectl get pods -n argocd
```

#### Manual Method 2: Install ArgoCD using Manifests (Demo/Lab)

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd
```

---

### Step 3: Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &
```

Open in browser: `https://<EC2_PUBLIC_IP>:8080`

### Get Admin Password

```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

- **Username:** `admin`
- **Password:** (output from above command)

---

### Step 4: Install ArgoCD CLI

```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
argocd version --client
```

### Login via CLI

```bash
argocd login <EC2_PUBLIC_IP>:8080 --username admin --password <PASSWORD> --insecure
argocd account get-user-info
```

---

## 📌 Quick Reference

| Component | Command |
|-----------|---------|
| Check Private IP | `hostname -I` |
| Check Public IP | `curl ifconfig.me` |
| Cluster Info | `kubectl cluster-info` |
| ArgoCD Pods | `kubectl get pods -n argocd` |
| ArgoCD Password | `kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" \| base64 -d` |
| Port Forward | `kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &` |

---

## 🎓 Credits & Resources

| Platform | Link |
|----------|------|
| 🎥 YouTube | [TECH MAHATO](https://www.youtube.com/techmahato) |
| 📝 Medium Blog | [Tech Mahato on Medium](https://medium.com/@techmahato) |
| 💼 LinkedIn | [Arbind Kr. Mahato](https://www.linkedin.com/in/arbindmahato/) |
| 🌐 Website | [techmahato.com](https://techmahato.com) |
| 🐙 GitHub | [techmahato](https://github.com/techmahato) |

---

> 💡 **Next:** Move to `02_argocd_basics` to learn ArgoCD architecture and core concepts.
