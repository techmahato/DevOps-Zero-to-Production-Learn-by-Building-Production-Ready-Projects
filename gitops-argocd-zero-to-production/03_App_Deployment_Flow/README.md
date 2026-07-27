# 🚀 03 - ArgoCD Application Deployment Flow (End-to-End) | TECH MAHATO

> **Complete Hands-On Guide: From Cluster Registration to Application Deployment using UI, CLI & Declarative Methods**
>
> By **Arbind Kr. Mahato** | ♾️ Cloud & DevOps Engineer | 🏆 AWS Certified | ☸️ CKA & CKAD | 🌍 AWS Community Builder
>
> 📺 [TECH MAHATO YouTube](https://www.youtube.com/techmahato) | 📝 [Medium Blog](https://medium.com/@techmahato) | 💼 [LinkedIn](https://www.linkedin.com/in/arbindmahato/)

---

## 📋 Table of Contents

1. [Deployment Flow Overview](#1-deployment-flow-overview)
2. [Pre-requisites — Before Deploying Any App](#2-pre-requisites--before-deploying-any-app)
3. [Step 1: Register a Cluster](#3-step-1-register-a-cluster)
4. [Step 2: Connect a Repository](#4-step-2-connect-a-repository)
5. [Step 3: Create a Project](#5-step-3-create-a-project)
6. [Step 4: Deploy Application — Three Methods](#6-step-4-deploy-application--three-methods)
7. [Method 1: UI Approach (NGINX)](#7-method-1-ui-approach-nginx)
8. [Method 2: CLI Approach (Apache)](#8-method-2-cli-approach-apache)
9. [Method 3: Declarative Approach (Online Shop)](#9-method-3-declarative-approach-online-shop)
10. [Comparison: UI vs CLI vs Declarative](#10-comparison-ui-vs-cli-vs-declarative)
11. [Verify & Monitor Deployment](#11-verify--monitor-deployment)
12. [Sync, Rollback & Troubleshoot](#12-sync-rollback--troubleshoot)
13. [Interview Questions & Answers](#13-interview-questions--answers)

---

## 1. Deployment Flow Overview

Before deploying any application with ArgoCD, you must follow a specific **end-to-end flow**. Here's the complete process:

```
┌────────────────────────────────────────────────────────────────────────────┐
│              ArgoCD APPLICATION DEPLOYMENT FLOW (End-to-End)                 │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  STEP 1: REGISTER CLUSTER                                                   │
│  ─────────────────────────                                                  │
│  "Where will the app be deployed?"                                          │
│  • In-cluster (auto-registered) OR                                          │
│  • External cluster (argocd cluster add)                                    │
│                                                                              │
│          │                                                                   │
│          ▼                                                                   │
│                                                                              │
│  STEP 2: CONNECT REPOSITORY                                                 │
│  ─────────────────────────                                                   │
│  "Where are the manifests stored?"                                          │
│  • Public repo (no auth) OR                                                 │
│  • Private repo (HTTPS/SSH/GitHub App)                                      │
│                                                                              │
│          │                                                                   │
│          ▼                                                                   │
│                                                                              │
│  STEP 3: CREATE PROJECT (Optional but recommended)                          │
│  ─────────────────────────                                                   │
│  "Who can deploy what and where?"                                           │
│  • Define allowed repos, clusters, namespaces                               │
│  • Set RBAC roles for teams                                                 │
│                                                                              │
│          │                                                                   │
│          ▼                                                                   │
│                                                                              │
│  STEP 4: CREATE APPLICATION                                                 │
│  ─────────────────────────                                                   │
│  "Deploy the app using one of three methods:"                               │
│  • Method 1: UI (ArgoCD Dashboard)                                          │
│  • Method 2: CLI (argocd app create)                                        │
│  • Method 3: Declarative (Application YAML in Git) ← TRUE GITOPS           │
│                                                                              │
│          │                                                                   │
│          ▼                                                                   │
│                                                                              │
│  STEP 5: SYNC & VERIFY                                                      │
│  ─────────────────────────                                                   │
│  "Make sure live state matches desired state"                               │
│  • Manual sync OR auto-sync                                                 │
│  • Check health status                                                      │
│  • Access the application                                                   │
│                                                                              │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Pre-requisites — Before Deploying Any App

Ensure you have:

| Requirement | Check Command | Expected Output |
|-------------|---------------|-----------------|
| ArgoCD running | `kubectl get pods -n argocd` | All pods Running ✅ |
| ArgoCD CLI installed | `argocd version --client` | Version info |
| Logged into ArgoCD | `argocd account get-user-info` | Username: admin |
| kubectl configured | `kubectl get nodes` | Cluster nodes listed |
| Git repo with manifests | Check GitHub | Repo accessible |

### Sample Application Repositories

For this hands-on, we'll use these repos:

```bash
# Fork this repo first, then clone:
git clone https://github.com/<your-username>/argocd-demos.git
```

**Repository structure:**
```
argocd-demos/
├── nginx/                    # NGINX manifests (UI approach)
│   ├── deployment.yaml
│   ├── service.yaml
│   └── namespace.yaml
├── apache/                   # Apache manifests (CLI approach)
│   ├── deployment.yaml
│   ├── service.yaml
│   └── namespace.yaml
└── online-shop/              # Microservices app (Declarative approach)
    ├── deployment.yaml
    ├── service.yaml
    └── namespace.yaml
```

---

## 3. Step 1: Register a Cluster

### What is Cluster Registration?

A "cluster" in ArgoCD is a Kubernetes cluster where applications will be deployed. ArgoCD needs to know about target clusters before it can deploy to them.

### In-Cluster (Default — Auto-Registered)

When ArgoCD is installed in a cluster, that cluster is **automatically registered** as:
- **Server:** `https://kubernetes.default.svc`
- **Name:** `in-cluster`

```bash
# Verify in-cluster is registered
argocd cluster list

# Output:
# SERVER                          NAME        VERSION  STATUS
# https://kubernetes.default.svc  in-cluster  1.33     Successful
```

> 💡 For our lab setup (Kind cluster), the in-cluster is already available. No additional cluster registration needed!

### External Cluster (For Multi-Cluster)

If you want ArgoCD to deploy to ANOTHER cluster:

```bash
# Step 1: List your kubeconfig contexts
kubectl config get-contexts

# Step 2: Add external cluster to ArgoCD
argocd cluster add <context-name> --name production-cluster

# Example with EKS:
argocd cluster add arn:aws:eks:ap-south-1:123456789:cluster/prod-eks --name prod-eks

# Step 3: Verify
argocd cluster list
```

### Register Cluster via UI

1. Go to **⚙️ Settings** → **Clusters**
2. Click **+ CONNECT CLUSTER**
3. Fill in:
   - **Cluster Name:** `production-cluster`
   - **Server URL:** `https://eks-api-server-url.amazonaws.com`
   - **Authentication:** Bearer Token / ServiceAccount / TLS
4. Click **CONNECT**

### Register Cluster via Declarative YAML

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: production-cluster
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: production-cluster
  server: https://eks-api-server-url.amazonaws.com
  config: |
    {
      "bearerToken": "<service-account-token>",
      "tlsClientConfig": {
        "insecure": false,
        "caData": "<base64-encoded-ca-cert>"
      }
    }
```

```bash
kubectl apply -f production-cluster-secret.yaml
```

### Cluster Registration Summary

| Method | When to Use | Persistent in Git? |
|--------|-------------|-------------------|
| **In-cluster (auto)** | Single cluster setup | N/A (always available) |
| **CLI (`argocd cluster add`)** | Quick multi-cluster setup | ❌ No |
| **Declarative (Secret YAML)** | Production, GitOps-managed | ✅ Yes |

---

## 4. Step 2: Connect a Repository

### Why Connect a Repository?

ArgoCD needs to know WHERE your Kubernetes manifests are stored. Without connecting a repo, ArgoCD can't fetch your application's desired state.

### Method 1: Connect via UI

1. Go to **⚙️ Settings** → **Repositories**
2. Click **+ CONNECT REPO**
3. Choose method:

**For Public Repo (no auth needed):**
```
Type:      git
Repo URL:  https://github.com/techmahato/argocd-demos.git
```

**For Private Repo (HTTPS + PAT):**
```
Type:      git
Repo URL:  https://github.com/techmahato/private-config.git
Username:  git
Password:  ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

4. Click **CONNECT** → Should show ✅ "Connection Successful"

### Method 2: Connect via CLI

```bash
# Public repository (no authentication needed)
argocd repo add https://github.com/techmahato/argocd-demos.git

# Private repository with HTTPS token
argocd repo add https://github.com/techmahato/private-config.git \
  --username git \
  --password ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Private repository with SSH key
argocd repo add git@github.com:techmahato/private-config.git \
  --ssh-private-key-path ~/.ssh/id_ed25519

# Verify
argocd repo list
```

### Method 3: Connect via Declarative YAML

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
stringData:
  type: git
  url: https://github.com/techmahato/argocd-demos.git
  # For private repos, add:
  # username: git
  # password: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

```bash
kubectl apply -f my-repo-secret.yaml
```

### Repository Connection Summary

| Method | Use Case | GitOps Friendly? |
|--------|----------|:----------------:|
| **UI** | Quick one-off setup, demos | ❌ |
| **CLI** | Admin setup, scripting | ❌ |
| **Declarative YAML** | Production, version controlled | ✅ |

---

## 5. Step 3: Create a Project

### Why Create a Project?

Projects define the boundaries for your applications — which repos, clusters, and namespaces are allowed.

### Method 1: Create Project via UI

1. **⚙️ Settings** → **Projects** → **+ NEW PROJECT**
2. Fill in:
   - Name: `demo-project`
   - Description: "Demo project for first app deployments"
   - Source Repos: `https://github.com/techmahato/argocd-demos.git`
   - Destinations: Server `https://kubernetes.default.svc`, Namespace `*`
3. Click **CREATE**

### Method 2: Create Project via CLI

```bash
argocd proj create demo-project \
  --description "Demo project for first app deployments" \
  --src "https://github.com/techmahato/argocd-demos.git" \
  --dest "https://kubernetes.default.svc,*"

# Allow namespace creation
argocd proj allow-cluster-resource demo-project "" Namespace

# Verify
argocd proj get demo-project
```

### Method 3: Create Project via Declarative YAML

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: demo-project
  namespace: argocd
spec:
  description: "Demo project for first app deployments"
  sourceRepos:
    - 'https://github.com/techmahato/argocd-demos.git'
  destinations:
    - server: https://kubernetes.default.svc
      namespace: '*'
  clusterResourceWhitelist:
    - group: ''
      kind: Namespace
```

```bash
kubectl apply -f demo-project.yaml
```

> 💡 **For this hands-on demo**, you can use the `default` project to keep things simple. In production, always use custom projects.

---

## 6. Step 4: Deploy Application — Three Methods

ArgoCD supports three ways to create and deploy an application:

```
┌──────────────────────────────────────────────────────────────────────┐
│                   THREE DEPLOYMENT METHODS                             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────────────┐ │
│  │  METHOD 1: UI  │  │  METHOD 2: CLI │  │  METHOD 3: DECLARATIVE │ │
│  │                 │  │                 │  │                         │ │
│  │  Click buttons │  │  Run commands  │  │  Write YAML in Git     │ │
│  │  in ArgoCD     │  │  in terminal   │  │  + kubectl apply       │ │
│  │  Dashboard     │  │                 │  │                         │ │
│  │                 │  │                 │  │  ✅ TRUE GITOPS!       │ │
│  │  Best for:     │  │  Best for:     │  │                         │ │
│  │  • Learning    │  │  • Scripting   │  │  Best for:             │ │
│  │  • Demos       │  │  • Quick ops   │  │  • Production          │ │
│  │  • POCs        │  │  • Automation  │  │  • Teams               │ │
│  │                 │  │                 │  │  • Reproducibility     │ │
│  └────────────────┘  └────────────────┘  └────────────────────────┘ │
│                                                                        │
│  ⚠️ NOT GitOps       ⚠️ NOT GitOps       ✅ TRUE GitOps              │
│  (config not in Git) (config not in Git) (everything in Git)          │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. Method 1: UI Approach (NGINX)

### Overview

Deploy an **NGINX** application using the ArgoCD Web Dashboard. This is the easiest method for beginners.

### Step-by-Step

**1. Open ArgoCD UI** → `https://<EC2_PUBLIC_IP>:8080`

**2. Click "+ NEW APP"**

**3. Fill in the Application form:**

```
┌──────────────────────────────────────────────────────────────┐
│  NEW APPLICATION                                               │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  ─── GENERAL ───                                              │
│  Application Name:  [nginx-app                            ]   │
│  Project:           [default ▼]                               │
│  Sync Policy:       ○ Manual   ○ Automatic                   │
│                                                                │
│  ─── SOURCE ───                                               │
│  Repository URL:    [https://github.com/<user>/argocd-demos] │
│  Revision:          [main ▼]  (branch/tag/commit)            │
│  Path:              [nginx                                ]   │
│                                                                │
│  ─── DESTINATION ───                                          │
│  Cluster URL:       [https://kubernetes.default.svc ▼]       │
│  Namespace:         [nginx-app                            ]   │
│                                                                │
│  ─── SYNC OPTIONS ───                                         │
│  ☑ Auto-Create Namespace                                      │
│  ☐ Prune Resources                                            │
│  ☐ Self Heal                                                  │
│                                                                │
│                                        [CANCEL]  [CREATE]     │
└──────────────────────────────────────────────────────────────┘
```

**4. Click CREATE**

**5. Click SYNC** (if manual sync policy was selected)

**6. Verify in the Resource Tree:**
```
Application: nginx-app ✅ Synced / 💚 Healthy
├── Namespace: nginx-app
├── Deployment: nginx-deployment (3/3 replicas)
│   └── ReplicaSet: nginx-deployment-xxxxx
│       ├── Pod: nginx-deployment-xxxxx-a1 (Running ✅)
│       ├── Pod: nginx-deployment-xxxxx-b2 (Running ✅)
│       └── Pod: nginx-deployment-xxxxx-c3 (Running ✅)
└── Service: nginx-service (ClusterIP)
```

### Verify via kubectl

```bash
kubectl get all -n nginx-app
kubectl get pods -n nginx-app
kubectl port-forward svc/nginx-service -n nginx-app 9090:80 --address=0.0.0.0 &
# Access: http://<EC2_PUBLIC_IP>:9090
```

### Limitations of UI Approach

| Limitation | Impact |
|-----------|--------|
| Config not stored in Git | Not reproducible, not auditable |
| Can't be version controlled | No PR/review workflow |
| Manual process | Error-prone, can't automate |
| Single app at a time | Doesn't scale |
| No disaster recovery | If ArgoCD is deleted, app config is lost |

---

## 8. Method 2: CLI Approach (Apache)

### Overview

Deploy an **Apache** application using the `argocd` CLI. Better than UI because it can be scripted, but still not true GitOps.

### Step-by-Step

**1. Create the Application via CLI:**

```bash
argocd app create apache-app \
  --repo https://github.com/<your-username>/argocd-demos.git \
  --path apache \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace apache-app \
  --project default \
  --sync-option CreateNamespace=true \
  --revision main
```

**2. Check Application Status:**

```bash
argocd app get apache-app

# Output:
# Name:               argocd/apache-app
# Project:            default
# Server:             https://kubernetes.default.svc
# Namespace:          apache-app
# URL:                https://<argocd-server>:8080/applications/apache-app
# Repo:               https://github.com/<user>/argocd-demos.git
# Path:               apache
# Target:             main
# Sync Status:        OutOfSync
# Health Status:      Missing
```

**3. Sync the Application:**

```bash
# Manual sync
argocd app sync apache-app

# Sync with prune (delete resources not in Git)
argocd app sync apache-app --prune

# Force sync (recreate resources)
argocd app sync apache-app --force
```

**4. Verify Deployment:**

```bash
# Check app status
argocd app get apache-app

# Check pods
kubectl get pods -n apache-app

# Check all resources
kubectl get all -n apache-app

# Access Apache
kubectl port-forward svc/apache-service -n apache-app 9091:80 --address=0.0.0.0 &
# Access: http://<EC2_PUBLIC_IP>:9091
```

### Enable Auto-Sync via CLI

```bash
# Enable auto-sync with self-heal and prune
argocd app set apache-app \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```

### CLI Useful Commands

```bash
# List all apps
argocd app list

# View diff (what will change on sync)
argocd app diff apache-app

# View app history
argocd app history apache-app

# Rollback to previous revision
argocd app rollback apache-app 1

# Delete app (keep resources)
argocd app delete apache-app --cascade=false

# Delete app AND resources
argocd app delete apache-app --cascade=true
```

### Advantages of CLI over UI

| Advantage | Description |
|-----------|-------------|
| **Scriptable** | Can be used in shell scripts and CI pipelines |
| **Bulk operations** | `argocd app sync -l team=backend` syncs all matching apps |
| **Automation** | Integrate with GitHub Actions, Jenkins, etc. |
| **Reproducible** | Command can be documented and re-run |
| **Faster** | No clicks, just commands |

### Limitations of CLI Approach

| Limitation | Impact |
|-----------|--------|
| Config not in Git | App definition exists only in ArgoCD/cluster |
| Imperative | "Run this command" instead of "define desired state" |
| Not reviewable | No PR/approval workflow for app creation |
| Lost on reinstall | If ArgoCD is reinstalled, app definitions are lost |

---

## 9. Method 3: Declarative Approach (Online Shop) ✅ TRUE GITOPS

### Overview

Deploy an **Online Shop** application by defining an ArgoCD Application CRD in a YAML file and storing it in Git. This is the **only method that is true GitOps** — the application definition itself lives in Git.

### Why Declarative is the Right Way

```
┌──────────────────────────────────────────────────────────────┐
│  WHY DECLARATIVE = TRUE GITOPS                                │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  ✅ Application YAML is in Git (version controlled)           │
│  ✅ Changes go through PR review                              │
│  ✅ Complete audit trail                                      │
│  ✅ Reproducible (re-apply YAML = same result)                │
│  ✅ Disaster recovery (Git has everything)                    │
│  ✅ Scales to hundreds of apps (ApplicationSets)              │
│  ✅ Self-documenting (YAML IS the documentation)              │
│                                                                │
└──────────────────────────────────────────────────────────────┘
```

### Step-by-Step

**1. Create the Application YAML file:**

```yaml
# online-shop-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: online-shop
  namespace: argocd        # Application CRD always lives in argocd namespace
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default         # Or your custom project

  # SOURCE: Where the manifests live
  source:
    repoURL: https://github.com/<your-username>/argocd-demos.git
    targetRevision: main
    path: online-shop      # Folder in the repo containing manifests

  # DESTINATION: Where to deploy
  destination:
    server: https://kubernetes.default.svc
    namespace: online-shop

  # SYNC POLICY: How to sync
  syncPolicy:
    automated:
      prune: true          # Delete resources removed from Git
      selfHeal: true       # Revert manual changes
      allowEmpty: false    # Don't sync if manifests are empty
    syncOptions:
      - CreateNamespace=true
      - PruneLast=true
      - ApplyOutOfSyncOnly=true
      - ServerSideApply=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

**2. Apply the Application YAML:**

```bash
kubectl apply -f online-shop-app.yaml
```

**3. ArgoCD automatically:**
- Clones the Git repo
- Reads manifests from `online-shop/` path
- Creates the namespace (because `CreateNamespace=true`)
- Deploys all resources
- Monitors health continuously
- Auto-syncs on Git changes (because `automated` policy)

**4. Verify:**

```bash
# Check via CLI
argocd app get online-shop

# Check via kubectl
kubectl get all -n online-shop

# Check in ArgoCD UI
# Go to https://<EC2_IP>:8080 → Click on "online-shop" app
```

### Declarative with Helm Chart

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: online-shop-helm
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/<your-username>/argocd-demos.git
    targetRevision: main
    path: online-shop-helm
    helm:
      valueFiles:
        - values.yaml
        - values-production.yaml
      parameters:
        - name: image.tag
          value: "v2.1.0"
        - name: replicaCount
          value: "3"
  destination:
    server: https://kubernetes.default.svc
    namespace: online-shop
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### Declarative with Kustomize

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: online-shop-kustomize
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/<your-username>/argocd-demos.git
    targetRevision: main
    path: online-shop/overlays/production    # Kustomize overlay path
  destination:
    server: https://kubernetes.default.svc
    namespace: online-shop-prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### Store Application YAML in Git (The GitOps Way!)

```
gitops-config-repo/
├── argocd-apps/
│   ├── nginx-app.yaml
│   ├── apache-app.yaml
│   └── online-shop-app.yaml      ← Application definitions in Git!
├── apps/
│   ├── nginx/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── apache/
│   └── online-shop/
└── README.md
```

> 💡 **Pro Tip:** You can even manage Application YAMLs through ArgoCD itself using the "App of Apps" pattern — one root Application that syncs all other Application definitions from Git!

---

## 10. Comparison: UI vs CLI vs Declarative

### Complete Comparison Table

| Feature | UI Approach | CLI Approach | Declarative Approach |
|---------|-------------|--------------|---------------------|
| **How app is created** | Click buttons in dashboard | Run `argocd app create` | Apply Application YAML |
| **Config stored in Git?** | ❌ No | ❌ No | ✅ Yes |
| **Version controlled?** | ❌ No | ❌ No | ✅ Yes (Git history) |
| **PR/Review workflow?** | ❌ No | ❌ No | ✅ Yes |
| **Reproducible?** | ❌ No (manual clicks) | ⚠️ Partially (if scripted) | ✅ Yes (apply same YAML) |
| **Disaster recovery?** | ❌ Lost on reinstall | ❌ Lost on reinstall | ✅ Re-apply from Git |
| **Scalable?** | ❌ One at a time | ⚠️ Scriptable | ✅ ApplicationSets |
| **Audit trail?** | ❌ Only ArgoCD logs | ❌ Only ArgoCD logs | ✅ Full Git history |
| **True GitOps?** | ❌ NO | ❌ NO | ✅ YES |
| **Best for** | Learning, demos | Quick ops, scripting | Production, teams |
| **Example app** | NGINX | Apache | Online Shop |
| **Difficulty** | Easy | Medium | Medium-Advanced |

### The GitOps Maturity Model

```
Level 0: Manual kubectl        → "SSH and run commands"
Level 1: UI-based ArgoCD      → "Click to deploy" (this chapter, Method 1)
Level 2: CLI-based ArgoCD     → "Script and automate" (this chapter, Method 2)
Level 3: Declarative ArgoCD   → "Everything in Git" (this chapter, Method 3) ← TARGET!
Level 4: App of Apps          → "One app manages all apps"
Level 5: ApplicationSets      → "Templates generate apps automatically"
```

---

## 11. Verify & Monitor Deployment

### Check Application Status

```bash
# Quick status
argocd app list

# Detailed status
argocd app get <app-name>

# Resource-level view
argocd app resources <app-name>

# Health only
argocd app get <app-name> -o json | jq '.status.health.status'
```

### Check via kubectl

```bash
# All resources in namespace
kubectl get all -n <namespace>

# Pods with details
kubectl get pods -n <namespace> -o wide

# Events (for debugging)
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# Describe specific resource
kubectl describe deployment <name> -n <namespace>
```

### Access Deployed Applications

```bash
# Port-forward to access services
kubectl port-forward svc/nginx-service -n nginx-app 9090:80 --address=0.0.0.0 &
kubectl port-forward svc/apache-service -n apache-app 9091:80 --address=0.0.0.0 &

# Access in browser:
# NGINX:  http://<EC2_PUBLIC_IP>:9090
# Apache: http://<EC2_PUBLIC_IP>:9091
```

---

## 12. Sync, Rollback & Troubleshoot

### Sync Operations

```bash
# Manual sync
argocd app sync <app-name>

# Sync with prune (delete extra resources)
argocd app sync <app-name> --prune

# Sync specific resource only
argocd app sync <app-name> --resource apps:Deployment:nginx-deployment

# Dry-run (preview without applying)
argocd app sync <app-name> --dry-run

# Force sync (recreate)
argocd app sync <app-name> --force
```

### Rollback Operations

```bash
# View history
argocd app history <app-name>

# Rollback to specific revision
argocd app rollback <app-name> <revision-number>

# Via Git (permanent rollback)
git revert <bad-commit-sha>
git push    # ArgoCD auto-syncs to previous state
```

### Common Troubleshooting

| Issue | Diagnosis | Fix |
|-------|-----------|-----|
| **OutOfSync but no changes** | `argocd app diff <app>` | Add `ignoreDifferences` for dynamic fields |
| **Sync failed** | `argocd app get <app>` → check message | Fix manifest error in Git |
| **Pods not starting** | `kubectl describe pod <pod> -n <ns>` | Check image, resources, secrets |
| **Health Degraded** | Check pod logs | `kubectl logs <pod> -n <ns>` |
| **Namespace not created** | Missing sync option | Add `CreateNamespace=true` |
| **Permission denied** | Project restrictions | Check project sourceRepos and destinations |

---

## 13. Interview Questions & Answers

---

**Q1: What are the three methods to deploy an application in ArgoCD? Which one is true GitOps?**

**Answer:** The three methods are:
1. **UI (Dashboard)** — Click buttons to create apps. NOT GitOps.
2. **CLI (`argocd app create`)** — Run commands. NOT GitOps (imperative).
3. **Declarative (Application YAML in Git)** — Define app as CRD, store in Git. TRUE GitOps.

Only the declarative method is true GitOps because the application definition itself is stored in Git, version-controlled, reviewable via PRs, and reproducible.

---

**Q2: What is the end-to-end flow of deploying an application with ArgoCD?**

**Answer:**
1. **Register Cluster** — Where to deploy (in-cluster auto-registered or add external)
2. **Connect Repository** — Where manifests are stored (Git/Helm repo)
3. **Create Project** — Define boundaries (allowed repos, namespaces, RBAC)
4. **Create Application** — Link source (Git path) to destination (cluster/namespace)
5. **Sync** — Apply desired state from Git to cluster
6. **Verify** — Check health status and access the app

---

**Q3: Explain what happens internally when you create an ArgoCD Application.**

**Answer:**
1. Application CRD is created in the `argocd` namespace
2. Application Controller picks up the new resource
3. Controller asks Repo Server to clone the Git repo and generate manifests
4. Repo Server returns rendered YAML (plain, Helm, or Kustomize)
5. Controller compares rendered YAML against live cluster state
6. If OutOfSync and auto-sync is enabled → Controller applies manifests via K8s API
7. Controller monitors health of all created resources
8. Status is updated in the Application CRD (Synced/OutOfSync, Healthy/Degraded)

---

**Q4: What is the difference between `--sync-policy automated` and manual sync?**

**Answer:**
- **Manual sync:** ArgoCD detects Git changes and marks app as OutOfSync but does NOTHING. User must manually click Sync or run `argocd app sync`.
- **Automated sync:** ArgoCD automatically applies changes whenever Git changes are detected. No human intervention needed.

Manual is safer for production (approval required). Automated is faster for dev/staging.

---

**Q5: What does `CreateNamespace=true` sync option do?**

**Answer:** If the target namespace doesn't exist in the cluster, ArgoCD will automatically create it before deploying resources. Without this option, sync fails with "namespace not found" error.

```yaml
syncOptions:
  - CreateNamespace=true
```

---

**Q6: Why is the declarative approach better for disaster recovery?**

**Answer:** Because everything is in Git:
- If ArgoCD is deleted and reinstalled → just re-apply the Application YAMLs from Git
- If the cluster is destroyed → create new cluster, install ArgoCD, apply YAMLs → everything rebuilds
- If someone accidentally deletes an app → `git log` shows exactly what was there, re-apply

With UI/CLI approaches, if ArgoCD is reinstalled, all application definitions are lost because they existed only in the cluster.

---

**Q7: How do you deploy the same application to multiple environments (dev/staging/prod)?**

**Answer:** Three approaches:

1. **Kustomize overlays:**
   ```
   app/base/ + app/overlays/dev/ + app/overlays/prod/
   ```
   One Application CRD per environment, each pointing to different overlay path.

2. **Helm values files:**
   ```yaml
   helm:
     valueFiles:
       - values.yaml
       - values-production.yaml
   ```

3. **ApplicationSets:**
   ```yaml
   generators:
     - list:
         elements:
           - env: dev
             namespace: app-dev
           - env: prod
             namespace: app-prod
   ```

---

**Q8: What is the finalizer `resources-finalizer.argocd.argoproj.io` on an Application?**

**Answer:** It controls what happens when the Application is DELETED:
- **With finalizer:** Deleting the Application also deletes all managed K8s resources (cascade delete)
- **Without finalizer:** Deleting the Application leaves resources running in the cluster (orphaned)

In production, be very careful with this! Accidentally deleting an Application with the finalizer will delete your running pods.

---

**Q9: Can you deploy a Helm chart directly from a Helm repository (not Git)?**

**Answer:** Yes! ArgoCD supports deploying directly from Helm repos:

```yaml
source:
  repoURL: https://charts.bitnami.com/bitnami   # Helm repo, not Git
  chart: nginx                                     # Chart name
  targetRevision: 15.0.0                           # Chart version
  helm:
    valueFiles:
      - values.yaml    # From a Git repo or inline
```

You first register the Helm repo in Settings → Repositories, then reference it in the Application source.

---

**Q10: What happens if you try to deploy to a namespace that is NOT allowed in the Project?**

**Answer:** ArgoCD will reject the Application with an error:
```
application destination {server: https://kubernetes.default.svc, namespace: unauthorized-ns}
is not permitted in project 'my-project'
```
The Application will not be created or synced. This is Project-level access control working as designed.

---

**Q11: How do you delete an ArgoCD application without deleting the running pods?**

**Answer:**
```bash
# CLI: Use cascade=false
argocd app delete my-app --cascade=false

# OR: Remove the finalizer first, then delete
kubectl patch app my-app -n argocd -p '{"metadata":{"finalizers":null}}' --type merge
kubectl delete app my-app -n argocd
```

This removes the ArgoCD Application resource but leaves all deployed K8s resources running (orphaned).

---

**Q12: In a real production setup, which approach would you recommend and why?**

**Answer:** Always the **Declarative approach** with these patterns:

1. **Separate repos:** Application code repo + GitOps config repo
2. **App of Apps pattern:** One root Application manages all other Application YAMLs
3. **Custom Projects:** Per-team projects with strict RBAC
4. **Automated sync with self-heal:** For production environments
5. **Sync Windows:** Restrict production deploys to business hours
6. **Notifications:** Slack alerts on sync failures

The declarative approach is the only method that satisfies all GitOps principles: declarative, versioned, automated, and continuously reconciled.

---

## 📌 Quick Reference

| Task | Command |
|------|---------|
| Create app (CLI) | `argocd app create <name> --repo <url> --path <path> --dest-server <server> --dest-namespace <ns>` |
| Create app (YAML) | `kubectl apply -f application.yaml` |
| Sync app | `argocd app sync <name>` |
| Check status | `argocd app get <name>` |
| View diff | `argocd app diff <name>` |
| Rollback | `argocd app rollback <name> <rev>` |
| Delete (keep resources) | `argocd app delete <name> --cascade=false` |
| Enable auto-sync | `argocd app set <name> --sync-policy automated` |
| List all apps | `argocd app list` |

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
> 💡 **Next:** Move to `04_argocd_features` (formerly 05) to learn advanced ArgoCD features like App of Apps, ApplicationSets, and Multi-cluster!
