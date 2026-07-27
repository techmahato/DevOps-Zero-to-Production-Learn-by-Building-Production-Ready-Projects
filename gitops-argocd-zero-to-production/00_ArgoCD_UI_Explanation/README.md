# 🖥️ 00 - ArgoCD UI Explanation & Settings | TECH MAHATO

> **Complete Guide to Understanding ArgoCD Web UI, Settings, Projects & Repository Configuration**
>
> By **Arbind Kr. Mahato** | ♾️ Cloud & DevOps Engineer | 🏆 AWS Certified | ☸️ CKA & CKAD | 🌍 AWS Community Builder
>
> 📺 [TECH MAHATO YouTube](https://www.youtube.com/techmahato) | 📝 [Medium Blog](https://medium.com/@techmahato) | 💼 [LinkedIn](https://www.linkedin.com/in/arbindmahato/)

---

## 📋 Table of Contents

1. [Understanding ArgoCD UI](#1-understanding-argocd-ui)
2. [Difference Between UI and CLI](#2-difference-between-ui-and-cli)
3. [ArgoCD Settings — Complete Overview](#3-argocd-settings--complete-overview)
4. [Projects — Detailed Explanation](#4-projects--detailed-explanation)
5. [Difference Between Default and Custom Projects](#5-difference-between-default-and-custom-projects)
6. [Project Creation — Hands-On Demo](#6-project-creation--hands-on-demo)
7. [Repositories — Settings & Configuration](#7-repositories--settings--configuration)
8. [Other Settings Options Explained](#8-other-settings-options-explained)
9. [Interview Questions & Answers](#9-interview-questions--answers)

---

## 1. Understanding ArgoCD UI

ArgoCD provides a powerful **real-time web-based dashboard** that gives you visual control over all your GitOps deployments. Once you login at `https://<your-ip>:8080`, you'll see the ArgoCD interface.

### ArgoCD UI Layout

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  ArgoCD Web UI                                                     [Logout]  │
├──────┬───────────────────────────────────────────────────────────────────────┤
│      │                                                                        │
│  ◀   │              APPLICATION DASHBOARD (Main View)                        │
│      │                                                                        │
│ NAV  │   ┌───────────────┐  ┌───────────────┐  ┌───────────────┐           │
│ BAR  │   │  App: frontend │  │  App: backend │  │  App: database │           │
│      │   │  ✅ Synced     │  │  ⚠️ OutOfSync │  │  ✅ Synced     │           │
│      │   │  💚 Healthy    │  │  💚 Healthy    │  │  🔵 Progressing│           │
│      │   └───────────────┘  └───────────────┘  └───────────────┘           │
│ 📱   │                                                                        │
│ Apps │   Filters: [Project ▼] [Sync Status ▼] [Health ▼] [Cluster ▼]       │
│      │                                                                        │
│ ⚙️   │   [+ NEW APP]  [SYNC ALL]  [REFRESH]                                 │
│ Set  │                                                                        │
│      │                                                                        │
│ 👤   │                                                                        │
│ User │                                                                        │
│      │                                                                        │
└──────┴───────────────────────────────────────────────────────────────────────┘
```

### Left Navigation Bar

| Icon | Section | Purpose |
|------|---------|---------|
| 📱 | **Applications** | Main dashboard — view all apps, their sync/health status |
| ⚙️ | **Settings** | Configure projects, repos, clusters, accounts, certificates |
| 👤 | **User Info** | Current user details, logout, change password |
| 📖 | **Documentation** | Link to official ArgoCD docs |

### Application Card — What Each Field Means

When you see an application card on the dashboard:

```
┌─────────────────────────────────────────┐
│  📦 my-app                               │
│                                           │
│  Project:    default                      │
│  Sync:       ✅ Synced / ⚠️ OutOfSync    │
│  Health:     💚 Healthy / 🔴 Degraded    │
│  Repo:       github.com/org/repo          │
│  Path:       k8s/production               │
│  Target:     https://kubernetes.default   │
│  Namespace:  production                   │
│  Revision:   main (abc123d)               │
│                                           │
│  [SYNC] [REFRESH] [DELETE] [DETAILS]     │
└─────────────────────────────────────────┘
```

### Application Detail View (Click on an App)

When you click an application, you get:

```
┌──────────────────────────────────────────────────────────────────┐
│  📦 my-app                                      [SYNC] [REFRESH] │
├──────────────────────────────────────────────────────────────────┤
│                                                                    │
│  TABS: [Summary] [Resource Tree] [Diff] [Events] [Logs] [History]│
│                                                                    │
│  RESOURCE TREE VIEW:                                              │
│                                                                    │
│  Application: my-app                                              │
│  ├── 📁 Namespace: production                                     │
│  │   ├── 🔷 Deployment: my-app (3/3 replicas) ✅                 │
│  │   │   └── 🔷 ReplicaSet: my-app-abc123                        │
│  │   │       ├── 🟢 Pod: my-app-abc123-x1 (Running)              │
│  │   │       ├── 🟢 Pod: my-app-abc123-x2 (Running)              │
│  │   │       └── 🟢 Pod: my-app-abc123-x3 (Running)              │
│  │   ├── 🔷 Service: my-app-svc ✅                               │
│  │   │   └── 🔷 Endpoints: my-app-svc                            │
│  │   ├── 🔷 ConfigMap: my-app-config ✅                           │
│  │   ├── 🔷 Ingress: my-app-ingress ✅                           │
│  │   └── 🔷 HPA: my-app-hpa ✅                                   │
│  │                                                                 │
│  └── [Click any resource to see details, logs, events, YAML]     │
│                                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### Key UI Features

| Feature | What You Can Do |
|---------|----------------|
| **Resource Tree** | Visualize all K8s resources in a tree hierarchy |
| **Live Logs** | Stream pod logs directly from UI (no kubectl needed) |
| **Diff View** | See exact differences between Git (desired) and live (actual) |
| **Events** | K8s events for each resource (like `kubectl describe`) |
| **History** | All sync operations with timestamps and revision details |
| **Terminal** | SSH into pods directly from ArgoCD UI (if enabled) |
| **Rollback** | Click "Rollback" on any previous revision |
| **Manual Sync** | Sync individual resources or entire app |
| **Parameters** | Override Helm values or Kustomize patches from UI |

---

## 2. Difference Between UI and CLI

### Comparison Table

| Feature | ArgoCD UI (Web Dashboard) | ArgoCD CLI (`argocd` command) |
|---------|---------------------------|-------------------------------|
| **Access** | Browser-based, any device | Terminal/command-line only |
| **Visualization** | Resource tree, graphs, colors | Text-based output |
| **Real-time logs** | ✅ Stream in browser | ✅ `argocd app logs` |
| **Diff view** | ✅ Side-by-side visual diff | ✅ `argocd app diff` (text) |
| **Bulk operations** | Limited (one app at a time) | ✅ Scriptable, batch operations |
| **Automation** | ❌ Not scriptable | ✅ Used in CI/CD pipelines |
| **RBAC/SSO Login** | Browser-based login | Token-based or SSO login |
| **Speed** | Visual but slower for power users | Fast for experienced engineers |
| **Learning curve** | Easy for beginners | Requires terminal experience |
| **App creation** | Form-based wizard | `argocd app create` with flags |
| **Rollback** | Click on history revision | `argocd app rollback <rev>` |
| **Multiple apps** | Must click each | `argocd app sync --selector team=backend` |

### When to Use What

| Scenario | Best Choice | Why |
|----------|-------------|-----|
| Daily monitoring | **UI** | Visual health/sync overview at a glance |
| Debugging issues | **UI** | Resource tree + logs + events in one place |
| Creating apps | **Both** | UI for one-off, CLI for automation |
| CI/CD integration | **CLI** | Can be scripted in GitHub Actions/Jenkins |
| Bulk sync | **CLI** | `argocd app sync -l team=backend` syncs all team apps |
| Demos & presentations | **UI** | Visual, impressive for stakeholders |
| Emergency rollback | **UI** | Fastest click-to-rollback |
| Scripted operations | **CLI** | Automation and repeatability |

### CLI Quick Reference

```bash
# Login
argocd login <server>:8080 --username admin --password <pass> --insecure

# List applications
argocd app list

# Get app details
argocd app get my-app

# Sync an application
argocd app sync my-app

# View diff
argocd app diff my-app

# Rollback
argocd app rollback my-app 3

# Delete app (keep resources)
argocd app delete my-app --cascade=false

# List projects
argocd proj list

# Add repository
argocd repo add https://github.com/org/repo.git --username git --password <PAT>
```

---

## 3. ArgoCD Settings — Complete Overview

When you click the **⚙️ Settings** icon in the left navigation bar, you see the following options:

```
┌──────────────────────────────────────────────────────────┐
│  ⚙️  SETTINGS                                            │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  📁 Repositories           — Git/Helm repos connected     │
│  🔑 Repository Credentials — Shared credentials templates │
│  📋 Projects               — AppProjects (access control) │
│  🖥️  Clusters               — Registered K8s clusters     │
│  🔐 Certificates           — TLS & SSH known hosts        │
│  🔏 GnuPG Keys             — GPG keys for commit signing  │
│  👤 Accounts               — Local user accounts          │
│  📜 Appearance             — UI customization             │
│                                                            │
└──────────────────────────────────────────────────────────┘
```

### Settings Overview Table

| Setting | Purpose | When to Configure |
|---------|---------|-------------------|
| **Repositories** | Connect Git repos and Helm chart repos | When adding new apps from private repos |
| **Repository Credentials** | Reusable credential templates for repos | When many repos share same auth (e.g., same GitHub org) |
| **Projects** | Logical grouping + RBAC for applications | Multi-team environments, access control |
| **Clusters** | Register external K8s clusters | Multi-cluster deployments |
| **Certificates** | TLS certs & SSH known hosts | Private Git servers with custom certs |
| **GnuPG Keys** | GPG public keys for commit verification | When enforcing signed commits |
| **Accounts** | Local ArgoCD user accounts | When not using SSO, or for service accounts |
| **Appearance** | Customize UI (banners, labels) | Branding, environment identification |

---

## 4. Projects — Detailed Explanation

### What is a Project?

A **Project (AppProject)** in ArgoCD is a logical boundary that controls:
- Which **Git repositories** applications can pull from
- Which **clusters and namespaces** applications can deploy to
- Which **Kubernetes resources** can be created
- Which **team members** can manage applications within it

Think of it as a "sandbox" — each team gets their own sandbox with defined boundaries.

### Why Projects Matter

```
WITHOUT PROJECTS (Single "default" project):
┌─────────────────────────────────────────────────────────┐
│  All teams share everything                              │
│  Any team can deploy to any namespace                    │
│  Any team can use any repo                               │
│  No isolation, no access control                         │
│  ⚠️ RISKY for production!                                │
└─────────────────────────────────────────────────────────┘

WITH PROJECTS (Custom projects per team):
┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐
│ Project: frontend │  │ Project: backend  │  │ Project: infra    │
│                    │  │                    │  │                    │
│ Repos: frontend-* │  │ Repos: backend-*  │  │ Repos: infra-*    │
│ NS: frontend-*    │  │ NS: backend-*     │  │ NS: monitoring,   │
│ Team: frontend    │  │ Team: backend     │  │      istio-system │
│                    │  │                    │  │ Team: platform    │
│ ✅ ISOLATED!       │  │ ✅ ISOLATED!       │  │ ✅ ISOLATED!       │
└───────────────────┘  └───────────────────┘  └───────────────────┘
```

### Project Configuration Options

| Field | Description | Example |
|-------|-------------|---------|
| **Name** | Unique project identifier | `e-commerce` |
| **Description** | Human-readable description | "E-Commerce services for GitOps demo" |
| **Source Repositories** | Allowed Git repo URLs (wildcards supported) | `https://github.com/techmahato/e-commerce-*` |
| **Destinations** | Allowed cluster + namespace combinations | `server: *, namespace: ecommerce-*` |
| **Cluster Resource Allow List** | Which cluster-scoped resources can be created | `Namespace`, `ClusterRole` |
| **Cluster Resource Deny List** | Which cluster-scoped resources are blocked | Block `CustomResourceDefinition` for safety |
| **Namespace Resource Allow List** | Allowed namespaced resource kinds | `Deployment`, `Service`, `ConfigMap` |
| **Namespace Resource Deny List** | Blocked namespaced resource kinds | Block `ResourceQuota` changes |
| **Signature Keys** | Required GPG keys for commit signing | For compliance environments |
| **Orphaned Resources** | Monitor resources not managed by any app | Detect configuration drift |
| **Roles** | RBAC roles within the project | `developer`, `admin`, `viewer` |
| **Sync Windows** | Time-based deployment restrictions | "Only sync Mon-Fri 9am-5pm" |

---

## 5. Difference Between Default and Custom Projects

### Default Project (`default`)

The `default` project comes pre-installed with ArgoCD. It has NO restrictions:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: default
  namespace: argocd
spec:
  sourceRepos:
    - '*'              # ← Allows ALL repositories
  destinations:
    - server: '*'      # ← Allows ALL clusters
      namespace: '*'   # ← Allows ALL namespaces
  clusterResourceWhitelist:
    - group: '*'       # ← Allows ALL cluster resources
      kind: '*'
```

### Custom Project (Example: `e-commerce`)

A custom project has specific restrictions and policies:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: e-commerce
  namespace: argocd
spec:
  description: "E-Commerce Project for GitOps ArgoCD demos"
  sourceRepos:
    - 'https://github.com/techmahato/e-commerce-*'
    - 'https://github.com/techmahato/shared-configs'
  destinations:
    - server: https://kubernetes.default.svc
      namespace: 'ecommerce-dev'
    - server: https://kubernetes.default.svc
      namespace: 'ecommerce-staging'
    - server: https://kubernetes.default.svc
      namespace: 'ecommerce-prod'
  clusterResourceWhitelist:
    - group: ''
      kind: Namespace
  roles:
    - name: developer
      policies:
        - p, proj:e-commerce:developer, applications, get, e-commerce/*, allow
        - p, proj:e-commerce:developer, applications, sync, e-commerce/*, allow
    - name: admin
      policies:
        - p, proj:e-commerce:admin, applications, *, e-commerce/*, allow
```

### Comparison Table

| Feature | `default` Project | Custom Project (e.g., `e-commerce`) |
|---------|-------------------|-------------------------------------|
| **Source Repos** | `*` (ALL repos allowed) | Only specific repos/patterns |
| **Destination Clusters** | `*` (ALL clusters) | Only specific clusters |
| **Destination Namespaces** | `*` (ALL namespaces) | Only specific namespaces |
| **Cluster Resources** | ALL allowed | Whitelist specific kinds |
| **RBAC Roles** | None (uses global RBAC) | Project-level roles per team |
| **Sync Windows** | None | Can restrict deployment times |
| **Signature Verification** | Disabled | Can enforce signed commits |
| **Use Case** | Quick demos, learning | Production, multi-team |
| **Security** | ⚠️ No restrictions | ✅ Principle of least privilege |
| **Risk** | Any app can deploy anywhere | Blast radius is limited |

> ⚠️ **Production Warning:** NEVER use the `default` project in production! Always create custom projects to enforce access control and limit blast radius.

---

## 6. Project Creation — Hands-On Demo

### Create Project: `e-commerce`

**Project Details:**
- **Name:** `e-commerce`
- **Description:** "This is E-Commerce-Project for the GitOps ArgoCD demos"
- **Repository:** `https://github.com/techmahato/e-commerce-config`
- **Destinations:** `ecommerce-dev`, `ecommerce-staging`, `ecommerce-prod` namespaces

### Method 1: Create via ArgoCD UI

1. Click **⚙️ Settings** (left sidebar)
2. Click **Projects**
3. Click **+ NEW PROJECT**
4. Fill in the form:

```
┌──────────────────────────────────────────────────────────────┐
│  CREATE PROJECT                                                │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  Project Name:  [e-commerce                               ]   │
│  Description:   [This is E-Commerce-Project for the        ]  │
│                 [GitOps ArgoCD demos                        ]  │
│                                                                │
│  ─── SOURCE REPOSITORIES ───                                  │
│  [+ ADD SOURCE]                                               │
│  • https://github.com/techmahato/e-commerce-*                 │
│                                                                │
│  ─── DESTINATIONS ───                                         │
│  [+ ADD DESTINATION]                                          │
│  • Server: https://kubernetes.default.svc                     │
│    Namespace: ecommerce-dev                                   │
│  • Server: https://kubernetes.default.svc                     │
│    Namespace: ecommerce-staging                               │
│  • Server: https://kubernetes.default.svc                     │
│    Namespace: ecommerce-prod                                  │
│                                                                │
│  ─── CLUSTER RESOURCE ALLOW LIST ───                          │
│  [+ ADD RESOURCE]                                             │
│  • Group: ""  Kind: Namespace                                 │
│                                                                │
│                                        [CANCEL]  [CREATE]     │
└──────────────────────────────────────────────────────────────┘
```

5. Click **CREATE**

### Method 2: Create via CLI

```bash
argocd proj create e-commerce \
  --description "This is E-Commerce-Project for the GitOps ArgoCD demos" \
  --src "https://github.com/techmahato/e-commerce-*" \
  --dest "https://kubernetes.default.svc,ecommerce-dev" \
  --dest "https://kubernetes.default.svc,ecommerce-staging" \
  --dest "https://kubernetes.default.svc,ecommerce-prod"

# Allow namespace creation
argocd proj allow-cluster-resource e-commerce "" Namespace

# Verify
argocd proj get e-commerce
```

### Method 3: Create via YAML (Declarative — GitOps Way!)

```yaml
# e-commerce-project.yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: e-commerce
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: "This is E-Commerce-Project for the GitOps ArgoCD demos"

  # Source repositories allowed
  sourceRepos:
    - 'https://github.com/techmahato/e-commerce-*'
    - 'https://github.com/techmahato/shared-helm-charts'

  # Destination clusters and namespaces
  destinations:
    - server: https://kubernetes.default.svc
      namespace: ecommerce-dev
    - server: https://kubernetes.default.svc
      namespace: ecommerce-staging
    - server: https://kubernetes.default.svc
      namespace: ecommerce-prod

  # Allow creating namespaces
  clusterResourceWhitelist:
    - group: ''
      kind: Namespace

  # Project-level RBAC roles
  roles:
    - name: developer
      description: "E-commerce developers - can view and sync"
      policies:
        - p, proj:e-commerce:developer, applications, get, e-commerce/*, allow
        - p, proj:e-commerce:developer, applications, sync, e-commerce/*, allow
        - p, proj:e-commerce:developer, logs, get, e-commerce/*, allow
    - name: lead
      description: "E-commerce tech lead - full app access"
      policies:
        - p, proj:e-commerce:lead, applications, *, e-commerce/*, allow

  # Orphaned resource monitoring (detect unmanaged resources)
  orphanedResources:
    warn: true

  # Sync windows (optional — restrict deployment times)
  syncWindows:
    - kind: allow
      schedule: "0 9 * * 1-5"    # Mon-Fri 9 AM
      duration: 8h                # For 8 hours (9am-5pm)
      applications:
        - '*'
      namespaces:
        - ecommerce-prod
```

Apply it:
```bash
kubectl apply -f e-commerce-project.yaml
```

---

## 7. Repositories — Settings & Configuration

### What are Repositories in ArgoCD?

Repositories are **Git repos or Helm chart registries** that ArgoCD connects to for fetching application manifests. You must register a repository before ArgoCD can pull manifests from it.

### Types of Repositories

| Type | Protocol | Use Case | Example URL |
|------|----------|----------|-------------|
| **Git (HTTPS)** | HTTPS | Public or private repos with token auth | `https://github.com/techmahato/my-app.git` |
| **Git (SSH)** | SSH | Private repos with SSH key auth | `git@github.com:techmahato/my-app.git` |
| **Git (GitHub App)** | HTTPS | Organization-level access | Uses App ID + private key |
| **Helm (HTTPS)** | HTTPS | Helm chart repositories | `https://charts.bitnami.com/bitnami` |
| **Helm (OCI)** | OCI | Helm charts in container registries | `oci://ghcr.io/org/charts` |
| **Google Cloud Source** | HTTPS | GCP-hosted repos | Uses service account |

### Add Repository via UI

1. Go to **⚙️ Settings** → **Repositories**
2. Click **+ CONNECT REPO**
3. Choose connection method:

```
┌──────────────────────────────────────────────────────────────┐
│  CONNECT REPO                                                  │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  Connection Method:                                           │
│  ○ VIA HTTPS     ○ VIA SSH     ○ VIA GitHub App              │
│                                                                │
│  ─── For HTTPS: ───                                           │
│  Type:        [git ▼]    (git or helm)                        │
│  Project:     [e-commerce ▼]                                  │
│  Repo URL:    [https://github.com/techmahato/e-commerce-app] │
│  Username:    [git                                         ]  │
│  Password:    [ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx           ]  │
│               (GitHub Personal Access Token)                  │
│                                                                │
│  ☑ Enable LFS (Large File Storage)                            │
│  ☐ Skip server verification (insecure)                        │
│                                                                │
│  ─── For SSH: ───                                             │
│  Repo URL:    [git@github.com:techmahato/e-commerce-app.git] │
│  SSH Key:     [paste private key content here              ]  │
│                                                                │
│                                        [CANCEL]  [CONNECT]    │
└──────────────────────────────────────────────────────────────┘
```

### Add Repository via CLI

```bash
# Public repo (no auth needed)
argocd repo add https://github.com/techmahato/e-commerce-config.git

# Private repo with HTTPS + GitHub PAT
argocd repo add https://github.com/techmahato/e-commerce-config.git \
  --username git \
  --password ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
  --project e-commerce

# Private repo with SSH key
argocd repo add git@github.com:techmahato/e-commerce-config.git \
  --ssh-private-key-path ~/.ssh/id_ed25519 \
  --project e-commerce

# Helm repository
argocd repo add https://charts.bitnami.com/bitnami \
  --type helm \
  --name bitnami

# Verify connection
argocd repo list
```

### Repository Credentials (Shared Templates)

If you have many repos under the same GitHub organization, use **Repository Credentials** to set authentication once:

```
┌──────────────────────────────────────────────────────────────┐
│  REPOSITORY CREDENTIALS                                        │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  Instead of adding auth to EACH repo individually:            │
│  • repo1.git + token                                          │
│  • repo2.git + token                                          │
│  • repo3.git + token (tedious!)                               │
│                                                                │
│  Use a CREDENTIAL TEMPLATE:                                   │
│  URL Pattern: https://github.com/techmahato/                  │
│  Username:    git                                             │
│  Password:    ghp_xxxxxxxx (applies to ALL matching repos)    │
│                                                                │
│  Now ANY repo under techmahato/ auto-uses these credentials!  │
└──────────────────────────────────────────────────────────────┘
```

```bash
# Create repository credential template
argocd repocreds add https://github.com/techmahato/ \
  --username git \
  --password ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Repository Use Cases & Examples

| Use Case | Repository Setup | Example |
|----------|-----------------|---------|
| **Single app** | One repo with K8s manifests | `my-app-config/k8s/` |
| **Monorepo** | One repo, multiple paths per app | `gitops-config/apps/frontend/`, `apps/backend/` |
| **Helm charts** | Helm repo + values in Git | Bitnami repo + `values-prod.yaml` in config repo |
| **Multi-env** | One repo with overlays per env | `base/ + overlays/dev/ + overlays/prod/` |
| **Shared infra** | Separate repo for platform tools | `infra-config/monitoring/`, `infra-config/ingress/` |

---

## 8. Other Settings Options Explained

### 🖥️ Clusters

Clusters are the Kubernetes clusters where ArgoCD deploys applications.

**Default cluster:** `https://kubernetes.default.svc` — this is the cluster where ArgoCD is running (in-cluster). It's auto-registered.

**Add external clusters:**
```bash
# Add a remote cluster (uses your kubeconfig context)
argocd cluster add eks-production-context --name production-cluster

# List clusters
argocd cluster list
```

| Field | Description |
|-------|-------------|
| **Server URL** | Kubernetes API server URL |
| **Name** | Human-friendly name (e.g., "production-eks") |
| **Connection Status** | Successful / Failed |
| **K8s Version** | Kubernetes version of the cluster |
| **Namespaces** | Number of namespaces discovered |

**When to add clusters:**
- You want one ArgoCD to manage multiple clusters (hub-spoke pattern)
- Deploying to EKS/GKE/AKS from a management cluster
- Multi-region deployments

---

### 🔐 Certificates

Manage TLS certificates and SSH known hosts for secure Git/cluster communication.

**Two types:**

1. **TLS Certificates:** For Git servers using self-signed or private CA certificates
   ```bash
   # Add TLS cert for private Git server
   argocd cert add-tls git.company.com --from /path/to/ca-cert.pem
   ```

2. **SSH Known Hosts:** Verify Git server SSH fingerprints (prevent MITM attacks)
   ```bash
   # Add SSH known host
   argocd cert add-ssh --batch < known_hosts_file
   
   # List SSH known hosts
   argocd cert list --cert-type ssh
   ```

**When to configure:**
- Private Git servers with self-signed TLS certificates
- Corporate environments with internal CAs
- First-time connecting to a Git server via SSH

---

### 🔏 GnuPG Keys

Used for **commit signature verification**. When enabled on a Project, ArgoCD will only sync if the Git commit is signed with a known GPG key.

```bash
# Add a GPG public key
argocd gpg add --from /path/to/public-key.asc

# List GPG keys
argocd gpg list
```

**When to use:**
- Compliance environments (SOC2, HIPAA, PCI-DSS)
- Ensure only authorized developers' commits are deployed
- Financial services where auditability is critical

---

### 👤 Accounts

Local user accounts in ArgoCD (separate from SSO/OIDC users).

**Default account:** `admin` (created at installation)

**Account capabilities:**
| Capability | Description |
|-----------|-------------|
| `login` | Can login to UI and CLI |
| `apiKey` | Can generate API tokens (for automation) |

**Create additional accounts:**
```yaml
# In argocd-cm ConfigMap
data:
  accounts.deployer: apiKey, login
  accounts.readonly: login
  accounts.ci-bot: apiKey          # Only API access, no UI login
```

```bash
# Set password for new account
argocd account update-password --account deployer --new-password <pass>

# Generate API token (for CI/CD bots)
argocd account generate-token --account ci-bot
```

**When to use:**
- Service accounts for CI/CD pipelines
- Read-only accounts for monitoring dashboards
- Before SSO is configured

---

### 📜 Appearance

Customize ArgoCD UI for visual identification.

**Options:**
| Setting | Purpose | Example |
|---------|---------|---------|
| **Banner** | Show a message at top of UI | "⚠️ PRODUCTION ENVIRONMENT" |
| **Banner Position** | Top or bottom | Top (more visible) |
| **Banner Color** | Background color of banner | Red for prod, green for dev |
| **Label** | Custom label on login page | "TechMahato ArgoCD" |

**Configuration (in argocd-cm ConfigMap):**
```yaml
data:
  ui.bannercontent: "⚠️ PRODUCTION - All changes require PR approval"
  ui.bannerurl: "https://wiki.company.com/deployment-policy"
  ui.bannerpermanent: "true"
  ui.bannerposition: "top"
```

**When to use:**
- Distinguish between production/staging ArgoCD instances
- Show important notices to developers
- Compliance banners (e.g., "Authorized users only")

---

## 9. Interview Questions & Answers

### ArgoCD UI, Settings, Projects & Repositories

---

**Q1: What are the different sections available in ArgoCD Settings?**

**Answer:** ArgoCD Settings contains 8 main sections:
1. **Repositories** — Git/Helm repos for fetching application manifests
2. **Repository Credentials** — Shared authentication templates for repo groups
3. **Projects** — Logical grouping with RBAC, source/destination restrictions
4. **Clusters** — Registered Kubernetes clusters for deployment targets
5. **Certificates** — TLS certificates and SSH known hosts
6. **GnuPG Keys** — GPG public keys for commit signature verification
7. **Accounts** — Local user accounts with login/apiKey capabilities
8. **Appearance** — UI customization (banners, labels)

---

**Q2: What is the purpose of ArgoCD Projects? Why not use the `default` project?**

**Answer:** Projects provide multi-tenancy, access control, and blast radius limitation.

The `default` project allows:
- Any repository as source
- Any cluster and namespace as destination
- Any resource type

This is dangerous in production because:
- A misconfigured app could deploy to the wrong namespace
- A team could accidentally access another team's cluster
- No audit boundary between teams

Custom projects enforce the **principle of least privilege** — each team can only deploy from specific repos to specific namespaces.

---

**Q3: How do you connect a private Git repository to ArgoCD?**

**Answer:** Three common methods:

1. **HTTPS with Personal Access Token (PAT):**
   ```bash
   argocd repo add https://github.com/org/repo.git \
     --username git --password ghp_xxxxxxxxxx
   ```

2. **SSH with Deploy Key:**
   ```bash
   argocd repo add git@github.com:org/repo.git \
     --ssh-private-key-path ~/.ssh/deploy_key
   ```

3. **GitHub App (for organizations):**
   ```bash
   argocd repo add https://github.com/org/repo.git \
     --github-app-id <APP_ID> \
     --github-app-installation-id <INSTALL_ID> \
     --github-app-private-key-path /path/to/key.pem
   ```

Best practice: Use SSH deploy keys (read-only) per repository in production.

---

**Q4: What is the difference between "Repositories" and "Repository Credentials" in Settings?**

**Answer:**

| Feature | Repositories | Repository Credentials |
|---------|-------------|----------------------|
| **Scope** | Single specific repo | Pattern-matching multiple repos |
| **Use case** | One-off repo connection | Organization-wide auth template |
| **URL** | Exact repo URL | URL prefix pattern (e.g., `https://github.com/org/`) |
| **Override** | Can override credential template | Applies to all matching repos |

**Example:** If you have 50 repos under `github.com/techmahato/`, add ONE repository credential with pattern `https://github.com/techmahato/` → all 50 repos auto-authenticate.

---

**Q5: Can ArgoCD manage applications across multiple Kubernetes clusters?**

**Answer:** Yes! ArgoCD supports multi-cluster management from a single instance.

- **In-cluster** (default): `https://kubernetes.default.svc` (auto-registered)
- **External clusters**: Added via `argocd cluster add <context-name>`

ArgoCD stores cluster credentials as K8s Secrets in the `argocd` namespace. The Application Controller connects to each registered cluster to apply manifests and check health.

---

**Q6: What happens if you create an Application in a Project that doesn't allow its source repository?**

**Answer:** ArgoCD will **reject** the Application creation with an error:

```
application repo https://github.com/org/repo.git is not permitted in project e-commerce
```

The Application won't be created or synced. This is the access control working as designed — Projects enforce source restrictions at creation time.

---

**Q7: How do you restrict deployments to only business hours using Projects?**

**Answer:** Use **Sync Windows** in the Project spec:

```yaml
spec:
  syncWindows:
    - kind: allow
      schedule: "0 9 * * 1-5"     # Monday-Friday, 9:00 AM
      duration: 8h                  # Allow for 8 hours (until 5 PM)
      applications:
        - '*'                       # All apps in this project
      manualSync: true             # Even manual syncs blocked outside window
    - kind: deny
      schedule: "0 0 25 12 *"      # Christmas Day
      duration: 24h
      applications:
        - '*'
```

Outside the allowed window, both automatic and manual syncs are blocked.

---

**Q8: What is the `orphanedResources` field in a Project?**

**Answer:** It monitors resources in project-allowed namespaces that are NOT managed by any ArgoCD Application.

```yaml
spec:
  orphanedResources:
    warn: true        # Show warning in UI
    ignore:
      - group: ""
        kind: ConfigMap
        name: "kube-root-ca.crt"  # Ignore system ConfigMaps
```

**Use case:** Detect "shadow deployments" — resources someone created with `kubectl` bypassing GitOps. Helps maintain GitOps discipline.

---

**Q9: How do you give a CI/CD bot API access to ArgoCD without a login?**

**Answer:** Create an account with `apiKey` capability only:

```yaml
# argocd-cm ConfigMap
data:
  accounts.github-actions: apiKey    # No login capability
```

```bash
# Generate a long-lived API token
argocd account generate-token --account github-actions --expires-in 0

# Use in GitHub Actions:
# argocd app sync my-app --auth-token <token> --server argocd.company.com
```

The bot can sync apps via API but cannot login to the UI.

---

**Q10: What is the difference between ArgoCD UI "Sync" button and "Refresh" button?**

**Answer:**
- **Refresh** (🔄): Forces ArgoCD to re-read Git repository and recalculate the diff. Does NOT apply any changes. Just "re-check" if anything is different.
- **Sync** (🔁): Actually APPLIES changes to make the cluster match Git. This modifies the live state.

**Think of it as:**
- Refresh = "Look at the menu again" (read-only)
- Sync = "Order the food" (action)

---

**Q11: In the ArgoCD UI, what does the "App Diff" tab show?**

**Answer:** The Diff tab shows a side-by-side or unified comparison between:
- **Left (Desired state):** What's defined in Git (after Helm/Kustomize rendering)
- **Right (Live state):** What's currently running in the cluster

This helps you see EXACTLY what changes a sync will apply before clicking Sync. It's similar to `kubectl diff` but with a visual interface.

---

**Q12: How do you add a Helm repository in ArgoCD?**

**Answer:**

```bash
# Public Helm repo
argocd repo add https://charts.bitnami.com/bitnami --type helm --name bitnami

# Private Helm repo with auth
argocd repo add https://charts.company.com --type helm --name company \
  --username admin --password secret123

# OCI Helm registry (e.g., AWS ECR, GitHub Container Registry)
argocd repo add ghcr.io/org --type helm --name org-charts \
  --enable-oci --username x --password <GITHUB_TOKEN>
```

Once added, you can use these charts in Application specs:
```yaml
source:
  repoURL: https://charts.bitnami.com/bitnami
  chart: nginx
  targetRevision: 15.0.0
  helm:
    valueFiles:
      - values-production.yaml
```

---

**Q13: What is the significance of the "Finalizer" on a Project?**

**Answer:** The finalizer `resources-finalizer.argocd.argoproj.io` on a Project prevents accidental deletion.

When you try to delete a Project that still has Applications:
- **With finalizer:** Deletion is blocked until all apps in the project are removed first
- **Without finalizer:** Project deletes immediately (apps become orphaned)

```yaml
metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io   # Protect from accidental deletion
```

---

**Q14: How do you view application logs from the ArgoCD UI?**

**Answer:**
1. Click on the Application
2. In the Resource Tree, click on a **Pod**
3. Click the **Logs** tab
4. Select the container (if multiple containers in pod)
5. Optionally: filter by time, search text, auto-scroll

This replaces: `kubectl logs <pod-name> -n <namespace> -f`

You can also stream logs in real-time (equivalent to `kubectl logs -f`).

---

**Q15: What is the "Resource Tree" in ArgoCD UI and why is it useful?**

**Answer:** The Resource Tree shows the hierarchical relationship between all Kubernetes resources in an application:

```
Application
├── Deployment (owner)
│   └── ReplicaSet (owned by Deployment)
│       ├── Pod 1 (owned by ReplicaSet)
│       ├── Pod 2
│       └── Pod 3
├── Service
│   └── Endpoints (auto-created)
├── ConfigMap
├── Secret
├── Ingress
└── HPA (references Deployment)
```

**Why useful:**
- Immediately see which pods belong to which deployment
- Identify failing resources at a glance (red icons)
- Understand resource ownership chain
- Debug issues faster than `kubectl get all -n <ns>`
- One-click access to logs, events, YAML of any resource

---

## 📌 Quick Reference — ArgoCD Settings Commands

```bash
# ─── REPOSITORIES ───
argocd repo add <URL> --username <user> --password <pass>
argocd repo list
argocd repo rm <URL>

# ─── REPOSITORY CREDENTIALS ───
argocd repocreds add <URL-pattern> --username <user> --password <pass>
argocd repocreds list

# ─── PROJECTS ───
argocd proj create <name> --description "<desc>" --src "<repo>" --dest "<server>,<ns>"
argocd proj list
argocd proj get <name>
argocd proj delete <name>
argocd proj add-source <name> <repo-url>
argocd proj add-destination <name> <cluster> <namespace>

# ─── CLUSTERS ───
argocd cluster add <context-name> --name <friendly-name>
argocd cluster list
argocd cluster rm <server-url>

# ─── ACCOUNTS ───
argocd account list
argocd account update-password --account <name>
argocd account generate-token --account <name>
argocd account get-user-info

# ─── CERTIFICATES ───
argocd cert add-tls <hostname> --from <cert-file>
argocd cert add-ssh --batch < known_hosts
argocd cert list
```

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
> 💡 **Next:** Move to `01_GitOps_ArgoCD_Lab_setup` to set up your own ArgoCD environment!
