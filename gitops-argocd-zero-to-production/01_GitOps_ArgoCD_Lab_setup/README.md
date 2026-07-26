# 🚀 01 - GitOps & ArgoCD Lab Setup | TECH MAHATO

> **Production-Ready Lab Environment for ArgoCD on AWS EC2 with Kind Cluster**
>
> By **Arbind Kr. Mahato** | ♾️ Cloud & DevOps Engineer | 🏆 AWS Certified | ☸️ CKA & CKAD | 🌍 AWS Community Builder
>
> 📺 [TECH MAHATO YouTube](https://www.youtube.com/techmahato) | 📝 [Medium Blog](https://medium.com/@techmahato) | 💼 [LinkedIn](https://www.linkedin.com/in/arbindmahato/)

---

## 📋 Table of Contents

1. [Architecture Overview](#-architecture-overview)
2. [Create IAM User with Admin Access](#1-create-iam-user-with-admin-access)
3. [Install AWS CLI v2 on Your Laptop](#2-install-aws-cli-v2-on-your-laptop)
4. [Create and Setup IAM Profile](#3-create-and-setup-iam-profile)
5. [Create EC2 Instance (T3a.large)](#4-create-ec2-instance-t3alarge)
6. [Login to EC2 Instance through CLI](#5-login-to-ec2-instance-through-cli)
7. [ArgoCD Setup and Installation](#6-argocd-setup-and-installation)
8. [ArgoCD Password Management](#7-argocd-password-management)
9. [Troubleshooting Guide](#8-troubleshooting-guide)
10. [Clean Up Resources](#9-clean-up-resources)

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        YOUR LAPTOP / LOCAL MACHINE                    │
│                                                                       │
│   [AWS CLI v2]  ──→  [IAM Profile: argocd-lab]                       │
│   [SSH Client]  ──→  Connects to EC2 via port 22                     │
│   [Browser]     ──→  Access ArgoCD UI on port 8080                   │
└────────────────────────────────────┬────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    AWS EC2 INSTANCE (t3a.large)                       │
│                    Ubuntu 22.04/24.04 LTS                             │
│                    2 vCPU | 8 GB RAM | 30 GB gp3                     │
│                                                                       │
│   ┌───────────────────────────────────────────────────────────────┐ │
│   │                     DOCKER ENGINE                              │ │
│   │                                                                 │ │
│   │   ┌─────────────────────────────────────────────────────────┐ │ │
│   │   │              KIND CLUSTER (argocd-cluster)               │ │ │
│   │   │                                                           │ │ │
│   │   │   ┌─────────────┐ ┌─────────────┐ ┌─────────────┐     │ │ │
│   │   │   │ Control     │ │   Worker    │ │   Worker    │     │ │ │
│   │   │   │   Plane     │ │   Node 1    │ │   Node 2    │     │ │ │
│   │   │   │             │ │             │ │             │     │ │ │
│   │   │   │ API Server  │ │  ArgoCD     │ │  ArgoCD     │     │ │ │
│   │   │   │ :33893      │ │  Pods       │ │  Pods       │     │ │ │
│   │   │   └─────────────┘ └─────────────┘ └─────────────┘     │ │ │
│   │   │                                                           │ │ │
│   │   │   Namespace: argocd                                       │ │ │
│   │   │   ├── argocd-server (UI + API)                           │ │ │
│   │   │   ├── argocd-repo-server (Git operations)                │ │ │
│   │   │   ├── argocd-application-controller (Sync engine)        │ │ │
│   │   │   ├── argocd-applicationset-controller                   │ │ │
│   │   │   ├── argocd-notifications-controller                    │ │ │
│   │   │   ├── argocd-dex-server (SSO/Auth)                       │ │ │
│   │   │   └── argocd-redis (Caching)                             │ │ │
│   │   └─────────────────────────────────────────────────────────┘ │ │
│   └───────────────────────────────────────────────────────────────┘ │
│                                                                       │
│   Security Group Ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 8080      │
└─────────────────────────────────────────────────────────────────────┘
```

### Why This Setup?

| Component | Purpose | Why We Chose It |
|-----------|---------|-----------------|
| **EC2 t3a.large** | Host machine | 8GB RAM minimum for Kind + ArgoCD (6+ pods) |
| **Kind** | Local K8s cluster | Lightweight, fast, runs inside Docker containers |
| **3-node cluster** | Realistic setup | 1 control-plane + 2 workers mimics production |
| **Ubuntu LTS** | OS | Most documented, stable for K8s tooling |
| **gp3 30GB** | Storage | Docker images + Kind nodes need space |

---

## 1. Create IAM User with Admin Access

### What is IAM?

IAM (Identity and Access Management) controls **who** can access **what** in your AWS account. For this lab, we create a dedicated user with programmatic access (Access Key + Secret Key) so we can manage AWS resources via CLI.

### Step 1: Create IAM User

1. Go to **AWS Console** → **IAM** → **Users** → **Create User**
2. Enter username: `argocd-admin` (or your preferred name)
3. Select **Provide user access to the AWS Management Console** (optional — for UI access)
4. Click **Next**

### Step 2: Attach Admin Policy

1. Select **Attach policies directly**
2. Search and select: `AdministratorAccess`
3. Click **Next** → **Create User**

> ⚠️ **Production Note:** In real environments, NEVER use AdministratorAccess. Create a custom policy with only the permissions needed (EC2, VPC, Security Groups). This is a lab setup for learning purposes.

### Step 3: Create Access Key & Secret Key

1. Go to the newly created user → **Security credentials** tab
2. Click **Create access key**
3. Select **Command Line Interface (CLI)**
4. Acknowledge the recommendation and click **Next**
5. Add description tag (optional): `argocd-lab-key`
6. Click **Create access key**

```
┌───────────────────────────────────────────────────────┐
│  ⚠️  CRITICAL: Save these keys NOW!                   │
│                                                        │
│  Access Key ID:     AKIA_XXXXXXXXXXXX                 │
│  Secret Access Key: xxxxxxxxxxxxxxxxxxxxxxxxxxxx      │
│                                                        │
│  The Secret Key is shown ONLY ONCE. Download the CSV! │
└───────────────────────────────────────────────────────┘
```

### Security Best Practices for Access Keys

| Practice | Description |
|----------|-------------|
| Never commit keys to Git | Use `.gitignore` or env variables |
| Rotate keys every 90 days | AWS Security Hub recommends this |
| Use IAM Roles for EC2 | Better than access keys for production |
| Enable MFA | Add multi-factor auth to your IAM user |
| Delete keys when not needed | Remove after lab cleanup |

---

## 2. Install AWS CLI v2 on Your Laptop

AWS CLI lets you manage AWS services from your terminal. Version 2 has improved features, auto-completion, and better credential management.

### For Linux / Ubuntu / WSL

```bash
# Download
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install unzip if not available
sudo apt install unzip -y

# Unzip and install
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
# Expected: aws-cli/2.x.x Python/3.x.x Linux/x86_64 ...

# Clean up installer files
rm -rf aws awscliv2.zip
```

### For macOS

```bash
# Using official installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version

# OR using Homebrew
brew install awscli
```

### For Windows

1. Download: [AWS CLI v2 MSI Installer](https://awscli.amazonaws.com/AWSCLIV2.msi)
2. Run the installer
3. Open PowerShell and verify:

```powershell
aws --version
```

### Verify Installation

```bash
aws --version
# Output: aws-cli/2.x.x Python/3.x.x ...

# Check if configured
aws configure list
```

---

## 3. Create and Setup IAM Profile

An AWS CLI **profile** stores your credentials and config so you don't have to type them every time. Named profiles let you manage multiple AWS accounts.

### Configure AWS CLI Profile

```bash
aws configure --profile argocd-lab
```

Enter the following when prompted:

```
AWS Access Key ID [None]: <YOUR_ACCESS_KEY_ID>
AWS Secret Access Key [None]: <YOUR_SECRET_ACCESS_KEY>
Default region name [None]: ap-south-1       # Choose your nearest region
Default output format [None]: json           # Options: json, yaml, text, table
```

### Where Are Credentials Stored?

```bash
# Credentials file
cat ~/.aws/credentials
# [argocd-lab]
# aws_access_key_id = AKIA...
# aws_secret_access_key = ...

# Config file
cat ~/.aws/config
# [profile argocd-lab]
# region = ap-south-1
# output = json
```

### Set as Default Profile

```bash
# Option 1: Export for current session
export AWS_PROFILE=argocd-lab

# Option 2: Add permanently to shell config
echo 'export AWS_PROFILE=argocd-lab' >> ~/.bashrc
source ~/.bashrc

# Option 3: Use --profile flag with every command
aws ec2 describe-instances --profile argocd-lab
```

### Verify Profile is Working

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

### Common AWS Regions

| Region Code | Location | Use Case |
|-------------|----------|----------|
| `ap-south-1` | Mumbai, India | Best for Indian users |
| `us-east-1` | N. Virginia, US | Most services available |
| `eu-west-1` | Ireland, EU | European compliance |
| `ap-southeast-1` | Singapore | Southeast Asia |

---

## 4. Create EC2 Instance (T3a.large)

### Why T3a.large?

| Instance | vCPU | RAM | Cost (approx) | Good For |
|----------|------|-----|----------------|----------|
| t2.micro | 1 | 1GB | Free tier | ❌ Too small for K8s |
| t3.medium | 2 | 4GB | ~$0.04/hr | ❌ Tight for ArgoCD |
| **t3a.large** | **2** | **8GB** | **~$0.075/hr** | **✅ Perfect for Kind + ArgoCD** |
| t3a.xlarge | 4 | 16GB | ~$0.15/hr | Overkill for lab |

> **Why t3a over t3?** The "a" means AMD processors — same performance, ~10% cheaper!

### Instance Specifications

| Setting | Value | Why |
|---------|-------|-----|
| **Instance Type** | t3a.large | 8 GB RAM needed for Kind (3 nodes) + ArgoCD |
| **AMI** | Ubuntu 22.04/24.04 LTS | Best Docker & K8s compatibility |
| **VPC** | Default or Custom Public VPC | Needs internet access |
| **Subnet** | Public Subnet | Direct internet routing |
| **Public IP** | ✅ Auto-assign enabled | Required for SSH & ArgoCD UI access |
| **Storage** | 30 GB gp3 | Docker images (~10GB) + Kind nodes |
| **Key Pair** | Create new or use existing | Required for SSH |

### Security Group Rules (Detailed)

| Rule | Type | Protocol | Port | Source | Purpose |
|------|------|----------|------|--------|---------|
| 1 | SSH | TCP | 22 | **Your IP/32** | Secure SSH access (NOT 0.0.0.0/0!) |
| 2 | HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic (optional) |
| 3 | HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web traffic |
| 4 | Custom TCP | TCP | 8080 | 0.0.0.0/0 | ArgoCD UI access |

### 🔍 How to Find Your Laptop's Public IP

```bash
# Method 1: Simple and fast
curl -s ifconfig.me

# Method 2: JSON format with location info
curl -s ipinfo.io

# Method 3: AWS-specific
curl -s checkip.amazonaws.com

# Method 4: Multiple fallbacks
curl -s ifconfig.me || curl -s icanhazip.com || curl -s ipecho.net/plain
```

> 💡 **Pro Tip:** Use `<YOUR_IP>/32` in Security Group for port 22. The `/32` means ONLY your exact IP — maximum security!

### Create via AWS Console (Step-by-Step)

1. **EC2 Dashboard** → **Launch Instance**
2. **Name:** `ArgoCD-Lab-Server`
3. **AMI:** Ubuntu Server 24.04 LTS (or 22.04)
4. **Instance Type:** t3a.large
5. **Key pair:** Create new → `argocd-lab-key` → Download `.pem` file
6. **Network settings:**
   - VPC: Default
   - Subnet: Any public subnet
   - Auto-assign public IP: **Enable**
   - Security group: Create new with rules above
7. **Storage:** 30 GB, gp3
8. **Launch Instance** ✅

### Create via AWS CLI (Automated)

```bash
# Set your profile
export AWS_PROFILE=argocd-lab

# Step 1: Create Key Pair
aws ec2 create-key-pair \
  --key-name argocd-lab-key \
  --query 'KeyMaterial' \
  --output text > argocd-lab-key.pem

chmod 400 argocd-lab-key.pem

# Step 2: Get your public IP for security group
MY_IP=$(curl -s ifconfig.me)
echo "Your IP: $MY_IP"

# Step 3: Create Security Group
SG_ID=$(aws ec2 create-security-group \
  --group-name argocd-lab-sg \
  --description "ArgoCD Lab - SSH, HTTP, HTTPS, ArgoCD UI" \
  --query 'GroupId' \
  --output text)
echo "Security Group: $SG_ID"

# Step 4: Add Inbound Rules
aws ec2 authorize-security-group-ingress --group-id $SG_ID \
  --protocol tcp --port 22 --cidr ${MY_IP}/32
aws ec2 authorize-security-group-ingress --group-id $SG_ID \
  --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID \
  --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID \
  --protocol tcp --port 8080 --cidr 0.0.0.0/0

# Step 5: Get latest Ubuntu 24.04 AMI ID
AMI_ID=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
  --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
  --output text)
echo "AMI: $AMI_ID"

# Step 6: Launch EC2 Instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type t3a.large \
  --key-name argocd-lab-key \
  --security-group-ids $SG_ID \
  --associate-public-ip-address \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":30,"VolumeType":"gp3"}}]' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ArgoCD-Lab-Server},{Key=Project,Value=TechMahato-ArgoCD}]' \
  --query 'Instances[0].InstanceId' \
  --output text)
echo "Instance ID: $INSTANCE_ID"

# Step 7: Wait for running state
echo "Waiting for instance to start..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Step 8: Get Public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)
echo "✅ EC2 Ready! Public IP: $PUBLIC_IP"
echo "SSH Command: ssh -i argocd-lab-key.pem ubuntu@$PUBLIC_IP"
```

---

## 5. Login to EC2 Instance through CLI

### SSH into the EC2 Instance

```bash
# Basic SSH (Linux/Mac/WSL)
ssh -i argocd-lab-key.pem ubuntu@<PUBLIC_IP>

# If you get "Permissions too open" error:
chmod 400 argocd-lab-key.pem
ssh -i argocd-lab-key.pem ubuntu@<PUBLIC_IP>

# With verbose output (for debugging connection issues):
ssh -v -i argocd-lab-key.pem ubuntu@<PUBLIC_IP>
```

### Windows Users (PuTTY)

1. Convert `.pem` to `.ppk` using PuTTYgen
2. Open PuTTY → Host: `ubuntu@<PUBLIC_IP>` → Port: 22
3. Connection → SSH → Auth → Browse → Select `.ppk` file
4. Click Open

### First Time System Setup

```bash
# Update system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install essential tools
sudo apt install -y curl wget git unzip jq tree htop

# Verify system resources
free -h          # Check RAM (should show ~8GB)
df -h            # Check disk space
nproc            # Check CPU cores
lsb_release -a   # Check Ubuntu version
```

### Verify Network Connectivity

```bash
# Private IP (used for Kind cluster apiServerAddress)
hostname -I
# OR more reliable method:
ip route show default | awk '/default/ {print $5}' | xargs -I{} ip -4 addr show {} | grep -oP '(?<=inet\s)\d+(\.\d+){3}'

# Public IP (used for browser access)
curl -s ifconfig.me

# Test internet connectivity
ping -c 3 google.com
```

---

## 6. ArgoCD Setup and Installation

### Prerequisites (Auto-installed by our script!)

Our `setup_argocd.sh` script **automatically installs** Kind and kubectl if they're missing. You only need Docker pre-installed.

| Tool | Purpose | Auto-Install? |
|------|---------|:-------------:|
| **Docker** | Container runtime for Kind nodes | ❌ Manual |
| **Kind** | Creates K8s cluster in Docker containers | ✅ Auto |
| **kubectl** | Kubernetes CLI for cluster management | ✅ Auto |
| **Helm** | Package manager (optional, for Helm method) | ❌ Manual (optional) |

#### Install Docker (Required - Do This First!)

```bash
# Install Docker
sudo apt-get update
sudo apt install docker.io -y

# Add your user to docker group (avoids needing sudo)
sudo usermod -aG docker $USER

# Apply group change (or logout/login)
newgrp docker

# Verify Docker works without sudo
docker --version
docker ps
docker run hello-world
```

#### Install Helm (Optional - Only for Helm install method)

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

### 🔥 Quick Setup — Use Our Script! (RECOMMENDED)

```bash
# Clone the repo (if not already done)
git clone https://github.com/techmahato/DevOps-Zero-to-Production-Learn-by-Building-Production-Ready-Projects.git
cd DevOps-Zero-to-Production-Learn-by-Building-Production-Ready-Projects/gitops-argocd-zero-to-production/01_GitOps_ArgoCD_Lab_setup

# Make script executable and run
chmod +x setup_argocd.sh
./setup_argocd.sh
```

### What the Script Does (Automatically):

```
┌────────────────────────────────────────────────────────────┐
│  setup_argocd.sh — Automated Steps                          │
├────────────────────────────────────────────────────────────┤
│                                                              │
│  ✅ Step 0: Check prerequisites (disk space, tools)         │
│       ├── Auto-installs Kind if missing                     │
│       ├── Auto-installs kubectl if missing                  │
│       └── Detects architecture (amd64/arm64)                │
│                                                              │
│  ✅ Step 1: Create Kind cluster                             │
│       ├── Auto-detects EC2 private IP                       │
│       ├── Generates kind-config.yaml                        │
│       └── Creates 3-node cluster (1 CP + 2 Workers)        │
│                                                              │
│  ✅ Step 2: Install ArgoCD (your choice)                    │
│       ├── Option 1: Helm (production/customizable)          │
│       └── Option 2: Manifests (quick demo/lab)              │
│                                                              │
│  ✅ Step 3: Install ArgoCD CLI                              │
│       └── Auto-detects architecture                         │
│                                                              │
│  ✅ Step 4: Access & Credentials                            │
│       ├── Fetches admin password                            │
│       ├── Detects public IP                                 │
│       └── Starts port-forward                               │
│                                                              │
└────────────────────────────────────────────────────────────┘
```

---

### Manual Setup (Step-by-Step)

If you prefer doing it manually or want to understand each step:

#### Step 1: Create Kind Cluster

```bash
# Get your EC2 Private IP
PRIVATE_IP=$(ip route show default | awk '/default/ {print $5}' | \
  xargs -I{} ip -4 addr show {} | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
echo "Private IP: $PRIVATE_IP"
```

Create `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "<YOUR_EC2_PRIVATE_IP>"   # Replace with output above
  apiServerPort: 33893
nodes:
  - role: control-plane
    image: kindest/node:v1.33.1
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
      - containerPort: 30443
        hostPort: 30443
        protocol: TCP
  - role: worker
    image: kindest/node:v1.33.1
  - role: worker
    image: kindest/node:v1.33.1
```

> 💡 **Why `apiServerAddress`?**
> Kind by default binds the API server to `127.0.0.1` (localhost). When ArgoCD pods try to reach the API server, they need the actual network IP of the host machine. Setting `apiServerAddress` to your EC2 private IP ensures all pods can communicate with the Kubernetes API.

> 💡 **Why `extraPortMappings`?**
> These allow NodePort services to be accessible from outside the Kind cluster, useful for exposing services beyond port-forwarding.

Create the cluster:

```bash
kind create cluster --name argocd-cluster --config kind-config.yaml
```

Verify:

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A   # Check all system pods are running
```

#### Step 2: Install ArgoCD

**Method 1: Official Manifests (Recommended for Lab/Demo)**

```bash
# Create dedicated namespace
kubectl create namespace argocd

# Install using --server-side flag (avoids "annotation too long" CRD error)
kubectl apply --server-side -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for all pods to be ready
kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=300s

# Verify all pods are Running
kubectl get pods -n argocd
```

> ⚠️ **Important:** Always use `--server-side` flag! Without it, you'll get `"metadata.annotations: Too long"` error on the ApplicationSet CRD because it exceeds the 262144 byte annotation limit.

**Method 2: Helm Chart (Recommended for Production)**

```bash
# Add Argo Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Create namespace
kubectl create namespace argocd

# Install with production settings
helm upgrade --install argocd argo/argo-cd \
  -n argocd \
  --set server.service.type=ClusterIP \
  --set server.extraArgs[0]="--insecure" \
  --wait --timeout 300s

# Verify
kubectl get pods -n argocd
kubectl get svc -n argocd
```

| Feature | Helm (Method 1) | Manifests (Method 2) |
|---------|-----------------|---------------------|
| **Customization** | High (values.yaml overrides) | Low (edit raw YAML) |
| **Upgrades** | `helm upgrade` (clean) | `kubectl apply` (may drift) |
| **Rollback** | `helm rollback` (built-in) | Manual |
| **Best For** | Production & Enterprise | Quick labs & demos |
| **Learning** | More abstracted | See every resource |

#### Step 3: Access ArgoCD UI

```bash
# Start port-forward (runs in background)
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &

# Get your public IP
echo "ArgoCD URL: https://$(curl -s ifconfig.me):8080"
```

Open in browser: `https://<EC2_PUBLIC_IP>:8080`

> ⚠️ You'll see a certificate warning (self-signed cert). Click "Advanced" → "Proceed" to continue.

#### Step 4: Get Admin Credentials

```bash
# Get the auto-generated admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

- **Username:** `admin`
- **Password:** (output from above command)

#### Step 5: Install ArgoCD CLI

```bash
# Detect architecture and download
ARCH=$(uname -m)
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64" || ARCH="amd64"

curl -sSL -o /tmp/argocd \
  "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-${ARCH}"
sudo install -m 555 /tmp/argocd /usr/local/bin/argocd
rm -f /tmp/argocd

# Verify
argocd version --client
```

#### Step 6: Login via CLI

```bash
# Login (use your public IP and the password from Step 4)
argocd login <EC2_PUBLIC_IP>:8080 --username admin --password <PASSWORD> --insecure

# Verify login
argocd account get-user-info

# List clusters registered with ArgoCD
argocd cluster list
```

---

## 7. ArgoCD Password Management

### 🔑 Understanding ArgoCD Passwords

When ArgoCD is first installed, it generates a random password and stores it in a Kubernetes Secret:

```bash
# The password is stored here:
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
```

### ❓ FAQ: Does the Password Change on Pod Restart?

**NO!** The ArgoCD admin password does NOT change when:
- ❌ Pods restart or crash-loop
- ❌ ArgoCD server scales up/down
- ❌ Nodes reboot
- ❌ Kind cluster restarts (if data persists)

**The password ONLY changes when:**
- ✅ You manually change it using `argocd account update-password`
- ✅ You delete the `argocd-initial-admin-secret` and reinstall
- ✅ You delete the entire `argocd` namespace and reinstall

> 💡 **Why?** The password is stored in a Kubernetes Secret (etcd), not in the pod. Pods are stateless — they READ the password from the Secret. The Secret persists independently of pod lifecycle.

### Change Default Admin Password (Recommended!)

**Method 1: Using ArgoCD CLI (Easiest)**

```bash
# Login first
argocd login <EC2_PUBLIC_IP>:8080 --username admin --password <CURRENT_PASSWORD> --insecure

# Change password
argocd account update-password \
  --current-password <CURRENT_PASSWORD> \
  --new-password <YOUR_NEW_STRONG_PASSWORD>
```

**Method 2: Using kubectl (Direct Secret Update)**

```bash
# Generate bcrypt hash of your new password
# Install htpasswd if needed: sudo apt install apache2-utils -y
NEW_PASSWORD="YourStrongPassword123!"
BCRYPT_HASH=$(htpasswd -nbBC 10 "" "$NEW_PASSWORD" | tr -d ':\n' | sed 's/$2y/$2a/')

# Patch the ArgoCD secret
kubectl -n argocd patch secret argocd-secret \
  -p "{\"stringData\": {\"admin.password\": \"$BCRYPT_HASH\", \"admin.passwordMtime\": \"$(date +%FT%T%Z)\"}}"

# Restart argocd-server to pick up the change
kubectl rollout restart deployment argocd-server -n argocd
```

**Method 3: Disable Admin Account (Production Best Practice)**

```bash
# After setting up SSO/OIDC, disable the admin account
kubectl patch configmap argocd-cm -n argocd \
  --type merge \
  -p '{"data": {"admin.enabled": "false"}}'

# Restart to apply
kubectl rollout restart deployment argocd-server -n argocd
```

### Delete Initial Admin Secret (Security Hardening)

After changing the password, remove the initial secret:

```bash
# Delete the initial password secret (no longer needed)
kubectl delete secret argocd-initial-admin-secret -n argocd
```

> ⚠️ **Warning:** Only delete this AFTER you've changed the password and confirmed login works with the new password!

### Password Recovery (If You Forget)

```bash
# Option 1: Reset by patching the secret (set password to "admin123")
BCRYPT_HASH=$(htpasswd -nbBC 10 "" "admin123" | tr -d ':\n' | sed 's/$2y/$2a/')
kubectl -n argocd patch secret argocd-secret \
  -p "{\"stringData\": {\"admin.password\": \"$BCRYPT_HASH\", \"admin.passwordMtime\": \"$(date +%FT%T%Z)\"}}"
kubectl rollout restart deployment argocd-server -n argocd

# Option 2: Delete argocd-secret entirely (ArgoCD will regenerate on restart)
kubectl delete secret argocd-secret -n argocd
kubectl rollout restart deployment argocd-server -n argocd
# Then get the new auto-generated password:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

---

## 8. Troubleshooting Guide

### Common Issues & Fixes

#### ❌ "metadata.annotations: Too long" Error During Install

**Cause:** The ApplicationSet CRD exceeds Kubernetes' 262144 byte annotation limit when using client-side apply.

**Fix:**
```bash
# Use server-side apply (our script already does this!)
kubectl apply --server-side -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

#### ❌ Kind Cluster Creation Fails — "bind: address already in use"

**Cause:** Another Kind cluster or process is using port 33893.

**Fix:**
```bash
# Check existing clusters
kind get clusters

# Delete old cluster
kind delete cluster --name argocd-cluster

# Check what's using the port
sudo lsof -i :33893

# Then re-run the script
./setup_argocd.sh
```

#### ❌ ArgoCD Pods Stuck in "Pending" or "CrashLoopBackOff"

**Cause:** Usually insufficient resources (RAM/CPU/Disk).

**Fix:**
```bash
# Check pod events
kubectl describe pod <pod-name> -n argocd

# Check node resources
kubectl top nodes
kubectl describe nodes

# Check disk space
df -h

# Free up Docker space
docker system prune -af
docker volume prune -f
```

#### ❌ "Cannot connect to ArgoCD UI" in Browser

**Cause:** Port-forward not running, or Security Group blocking port 8080.

**Fix:**
```bash
# Check if port-forward is running
ps aux | grep port-forward

# If not running, restart it
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &

# Verify from EC2 itself
curl -k https://localhost:8080

# Check Security Group allows port 8080 from your IP
aws ec2 describe-security-groups --group-ids <SG_ID>
```

#### ❌ "dial tcp: lookup argocd-server on 10.96.0.10:53: no such host"

**Cause:** DNS resolution issue inside the cluster.

**Fix:**
```bash
# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Restart CoreDNS if needed
kubectl rollout restart deployment coredns -n kube-system
```

#### ❌ Kind Network Issue — "failed to pull image" or "connection timed out"

**Cause:** Docker network issues or DNS problems inside Kind.

**Fix:**
```bash
# Check Docker daemon is running
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker

# Delete and recreate cluster
kind delete cluster --name argocd-cluster
./setup_argocd.sh
```

#### ❌ "password not yet available" After Install

**Cause:** ArgoCD server hasn't finished initializing.

**Fix:**
```bash
# Wait for all pods to be Ready
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Check pod status
kubectl get pods -n argocd

# Then get password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

#### ❌ Port-Forward Drops After SSH Disconnect

**Cause:** Background process dies when SSH session ends.

**Fix:**
```bash
# Use nohup to keep it running after SSH disconnect
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &>/dev/null &

# OR use screen/tmux
screen -S argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0
# Press Ctrl+A, then D to detach
# screen -r argocd  (to reattach)
```

### Useful Debug Commands

```bash
# ArgoCD status overview
kubectl get all -n argocd

# Check ArgoCD server logs
kubectl logs deployment/argocd-server -n argocd --tail=50

# Check application controller logs
kubectl logs deployment/argocd-application-controller -n argocd --tail=50

# Check resource usage
kubectl top pods -n argocd

# ArgoCD version info
argocd version

# List all ArgoCD apps
argocd app list

# Check cluster connection
argocd cluster list
```

---

## 9. Clean Up Resources

### Delete Kind Cluster

```bash
# Delete the Kind cluster
kind delete cluster --name argocd-cluster

# Verify it's gone
kind get clusters

# Clean up generated files
rm -f kind-config.yaml
```

### Delete EC2 Instance

```bash
# Terminate EC2 instance
aws ec2 terminate-instances --instance-ids <INSTANCE_ID> --profile argocd-lab

# Delete Security Group (after instance is terminated)
aws ec2 delete-security-group --group-id <SG_ID> --profile argocd-lab

# Delete Key Pair
aws ec2 delete-key-pair --key-name argocd-lab-key --profile argocd-lab
rm -f argocd-lab-key.pem
```

### Delete IAM User (After Lab)

```bash
# Delete access key
aws iam delete-access-key --user-name argocd-admin --access-key-id <KEY_ID>

# Detach policy
aws iam detach-user-policy --user-name argocd-admin \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Delete user
aws iam delete-user --user-name argocd-admin

# Remove local profile
# Edit ~/.aws/credentials and ~/.aws/config to remove [argocd-lab] section
```

---

## 📌 Quick Reference Card

| Task | Command |
|------|---------|
| Check EC2 Private IP | `ip route show default \| awk '/default/ {print $5}' \| xargs -I{} ip -4 addr show {} \| grep -oP '(?<=inet\s)\d+(\.\d+){3}'` |
| Check EC2 Public IP | `curl -s ifconfig.me` |
| Check Your Laptop IP | `curl -s ifconfig.me` |
| Cluster Info | `kubectl cluster-info` |
| All ArgoCD Pods | `kubectl get pods -n argocd` |
| ArgoCD Services | `kubectl get svc -n argocd` |
| Get Admin Password | `kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" \| base64 -d` |
| Change Password | `argocd account update-password` |
| Port Forward | `kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &` |
| CLI Login | `argocd login <IP>:8080 --username admin --password <PASS> --insecure` |
| List Apps | `argocd app list` |
| Server Logs | `kubectl logs deployment/argocd-server -n argocd --tail=50` |
| Delete Cluster | `kind delete cluster --name argocd-cluster` |

---

## 📚 Additional Learning Resources

| Resource | Link |
|----------|------|
| ArgoCD Official Docs | https://argo-cd.readthedocs.io/ |
| ArgoCD GitHub | https://github.com/argoproj/argo-cd |
| Kind Official Docs | https://kind.sigs.k8s.io/ |
| Kubernetes Docs | https://kubernetes.io/docs/ |
| Helm Docs | https://helm.sh/docs/ |
| AWS CLI Reference | https://docs.aws.amazon.com/cli/ |

---

## 🎓 Credits & Connect

| Platform | Link |
|----------|------|
| 🎥 YouTube | [TECH MAHATO](https://www.youtube.com/techmahato) |
| 📝 Medium Blog | [Tech Mahato on Medium](https://medium.com/@techmahato) |
| 💼 LinkedIn | [Arbind Kr. Mahato](https://www.linkedin.com/in/arbindmahato/) |
| 🌐 Website | [techmahato.com](https://techmahato.com) |
| 🐙 GitHub | [techmahato](https://github.com/techmahato) |

---

> 🙏 **If this helped you, please Star ⭐ the repo and Subscribe 🔔 to [TECH MAHATO on YouTube](https://www.youtube.com/techmahato)!**
>
> 💡 **Next:** Move to `02_argocd_basics` to learn ArgoCD architecture, core concepts, and how GitOps works under the hood.
