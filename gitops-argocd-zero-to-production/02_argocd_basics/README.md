# 🚀 02 - GitOps & ArgoCD Fundamentals | TECH MAHATO

> **From SDLC to GitOps: Understanding the Complete Evolution of Software Delivery**
>
> By **Arbind Kr. Mahato** | ♾️ Cloud & DevOps Engineer | 🏆 AWS Certified | ☸️ CKA & CKAD | 🌍 AWS Community Builder
>
> 📺 [TECH MAHATO YouTube](https://www.youtube.com/techmahato) | 📝 [Medium Blog](https://medium.com/@techmahato) | 💼 [LinkedIn](https://www.linkedin.com/in/arbindmahato/)

---

## 📋 Table of Contents

1. [What is SDLC?](#1-what-is-sdlc)
2. [What is CI/CD?](#2-what-is-cicd)
3. [Why CI/CD Came and What Problem Does It Solve?](#3-why-cicd-came-and-what-problem-does-it-solve)
4. [Traditional CI/CD vs Modern CI/CD](#4-traditional-cicd-vs-modern-cicd)
5. [Popular CI/CD Tools](#5-popular-cicd-tools)
6. [Which Tools Are Gaining More Popularity and Why?](#6-which-tools-are-gaining-more-popularity-and-why)
7. [Limitations of Jenkins](#7-limitations-of-jenkins)
8. [Why GitOps Came?](#8-why-gitops-came)
9. [What Problems Does GitOps Solve?](#9-what-problems-does-gitops-solve)
10. [Why GitOps is a High-Demand Skill](#10-why-gitops-is-a-high-demand-skill-in-current-market)
11. [What is the Future of GitOps?](#11-what-is-the-future-of-gitops)
12. [Why Should You Learn GitOps?](#12-why-should-you-learn-gitops)
13. [Is GitOps Free or Paid?](#13-is-gitops-free-or-paid)
14. [GitOps Principles with Examples](#14-gitops-principles-with-examples)
15. [GitOps vs Traditional CI/CD](#15-gitops-vs-traditional-cicd)
16. [Why ArgoCD for GitOps?](#16-why-argocd-for-gitops)
17. [ArgoCD vs FluxCD vs Jenkins X](#17-argocd-vs-fluxcd-vs-jenkins-x)
18. [ArgoCD Architecture](#18-argocd-architecture)
19. [Key ArgoCD Concepts](#19-key-argocd-concepts)

---

## 1. What is SDLC?

**SDLC (Software Development Life Cycle)** is a structured process that defines the stages involved in developing software applications from initial planning to deployment and maintenance.

### SDLC Phases

```
┌─────────────────────────────────────────────────────────────────────┐
│                     SOFTWARE DEVELOPMENT LIFE CYCLE                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐     │
│   │ 1.PLAN   │───▶│ 2.DESIGN │───▶│ 3.DEVELOP│───▶│ 4.TEST   │     │
│   │          │    │          │    │  (Code)  │    │          │     │
│   └──────────┘    └──────────┘    └──────────┘    └──────────┘     │
│        ▲                                                │            │
│        │                                                ▼            │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐     │
│   │7.MAINTAIN│◀───│6.MONITOR │◀───│5.DEPLOY  │◀───│4.5 BUILD │     │
│   │          │    │          │    │          │    │& RELEASE │     │
│   └──────────┘    └──────────┘    └──────────┘    └──────────┘     │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

| Phase | What Happens | Example |
|-------|-------------|---------|
| **1. Planning** | Define requirements, scope, timeline | "We need a user login feature" |
| **2. Design** | Architecture, DB schema, API design | System design document |
| **3. Development** | Write code | Developers write Python/Java/Go code |
| **4. Testing** | Unit tests, integration tests, QA | Jest, Selenium, manual testing |
| **5. Deployment** | Release to production | Push to servers/Kubernetes |
| **6. Monitoring** | Track performance, errors | Prometheus, Grafana, CloudWatch |
| **7. Maintenance** | Bug fixes, updates, patches | Hotfixes, version upgrades |

### SDLC Models

| Model | Description | Best For |
|-------|-------------|----------|
| **Waterfall** | Linear, sequential phases | Small, well-defined projects |
| **Agile** | Iterative, sprints (2-4 weeks) | Most modern software teams |
| **DevOps** | Agile + Operations collaboration | Continuous delivery teams |
| **GitOps** | DevOps + Git as single source of truth | Cloud-native/Kubernetes teams |

> 💡 **Key Insight:** SDLC gives us the framework, but **CI/CD automates** the repetitive parts (build, test, deploy) so developers can focus on writing code.

---

## 2. What is CI/CD?

**CI/CD** stands for **Continuous Integration / Continuous Delivery (or Deployment)**. It's the automation backbone of modern software development.

### CI (Continuous Integration)

```
Developer pushes code → Automated Build → Automated Tests → Merge to Main Branch
```

**CI ensures:** Every code change is automatically built and tested. If tests fail, the team knows immediately.

### CD (Continuous Delivery)

```
Code merged → Build artifact → Deploy to Staging → Manual approval → Deploy to Production
```

**Continuous Delivery:** Code is always in a deployable state. Deployment to production requires a manual trigger.

### CD (Continuous Deployment)

```
Code merged → Build artifact → Deploy to Staging → Auto-deploy to Production (no manual step!)
```

**Continuous Deployment:** Every change that passes tests is automatically deployed to production. No human intervention.

### Visual: CI/CD Pipeline

```
┌──────────────────────────────────────────────────────────────────────────┐
│                          CI/CD PIPELINE                                    │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐  │
│  │  CODE   │──▶│  BUILD  │──▶│  TEST   │──▶│ RELEASE │──▶│ DEPLOY  │  │
│  │         │   │         │   │         │   │         │   │         │  │
│  │ git push│   │ compile │   │ unit    │   │ package │   │ staging │  │
│  │         │   │ docker  │   │ integ   │   │ docker  │   │ prod    │  │
│  │         │   │ build   │   │ security│   │ push    │   │         │  │
│  └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘  │
│                                                                            │
│  ◀────── Continuous Integration ──────▶◀── Continuous Delivery/Deploy ─▶  │
│                                                                            │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Why CI/CD Came and What Problem Does It Solve?

### Before CI/CD (The Pain Points)

| Problem | Impact |
|---------|--------|
| **"Integration Hell"** | Developers work in isolation for weeks, merge code breaks everything |
| **Manual builds** | "It works on my machine" — different environments, different results |
| **Manual testing** | QA takes days/weeks, bugs found too late |
| **Manual deployment** | SSH into servers, run scripts, human errors, downtime |
| **Slow releases** | Companies release once per month/quarter |
| **No rollback** | If deployment fails, panic mode — no easy way back |
| **No audit trail** | "Who deployed what and when?" — nobody knows |

### After CI/CD (Problems Solved)

| Solution | Benefit |
|----------|---------|
| **Automated builds** | Every push triggers a build — consistent every time |
| **Automated tests** | Bugs caught in minutes, not days |
| **Automated deployment** | One-click or zero-click deploys |
| **Fast feedback** | Developer knows within minutes if code is broken |
| **Frequent releases** | Companies deploy multiple times per day (Netflix: 1000+/day) |
| **Rollbacks** | Easy revert to last working version |
| **Audit trail** | Full pipeline history — who, what, when |

### Real-World Example

```
WITHOUT CI/CD:
Developer → Finishes feature → Emails code → Ops team reviews → 
Ops manually deploys after hours → Something breaks → 
3 AM phone call → Manual rollback → Post-mortem meeting

WITH CI/CD:
Developer → git push → Pipeline builds → Tests pass → 
Auto-deploys to staging → Approved → Auto-deploys to production → 
Monitoring confirms health → Done in minutes, not days
```

---

## 4. Traditional CI/CD vs Modern CI/CD

### Traditional CI/CD (2010-2018 Era)

- Centralized CI server (Jenkins master + agents)
- VM-based builds
- Shell scripts for deployment
- Push-based: pipeline pushes to servers
- Monolithic applications
- Manual infrastructure provisioning

### Modern CI/CD (2018-Present)

- Cloud-native, container-based pipelines
- Kubernetes-native deployments
- Infrastructure as Code (Terraform, Pulumi)
- Pull-based (GitOps): cluster pulls from Git
- Microservices architecture
- Everything is declarative YAML

### Comparison Table

| Aspect | Traditional CI/CD | Modern CI/CD |
|--------|-------------------|--------------|
| **Infrastructure** | VMs, bare metal | Containers, Kubernetes |
| **Build Environment** | Dedicated build servers | Ephemeral containers (clean every time) |
| **Deployment Model** | Push (pipeline → server) | Pull (cluster ← Git) |
| **Configuration** | Scripts, manual configs | Declarative YAML, IaC |
| **Scaling** | Vertical (bigger servers) | Horizontal (more pods) |
| **Rollback** | Re-run old pipeline | `git revert` → auto-sync |
| **Security** | CI needs prod credentials | No external credentials needed |
| **Drift Detection** | Manual checks | Automated, continuous |
| **Multi-cluster** | Complex, custom scripts | Native support (ArgoCD) |
| **Observability** | Basic logs | Rich dashboards, metrics |
| **Example Tools** | Jenkins, Bamboo, TeamCity | ArgoCD, FluxCD, Tekton, GitHub Actions |

---

## 5. Popular CI/CD Tools

### CI Tools (Build & Test)

| Tool | Type | Best For | Pricing |
|------|------|----------|---------|
| **Jenkins** | Self-hosted | Enterprise, maximum flexibility | Free (OSS) |
| **GitHub Actions** | Cloud/SaaS | GitHub repos, simple workflows | Free tier + paid |
| **GitLab CI** | Cloud/Self-hosted | Full DevOps platform | Free tier + paid |
| **CircleCI** | Cloud | Fast builds, good Docker support | Free tier + paid |
| **Travis CI** | Cloud | Open source projects | Free for OSS |
| **Azure DevOps** | Cloud | Microsoft ecosystem, .NET | Free tier + paid |
| **AWS CodePipeline** | Cloud | AWS-native workloads | Pay-per-use |
| **Tekton** | Kubernetes-native | Cloud-native CI in K8s | Free (OSS) |

### CD Tools (Deployment)

| Tool | Type | Best For | Pricing |
|------|------|----------|---------|
| **ArgoCD** | Kubernetes-native | GitOps for K8s | Free (OSS) |
| **FluxCD** | Kubernetes-native | Lightweight GitOps | Free (OSS) |
| **Spinnaker** | Multi-cloud | Enterprise multi-cloud CD | Free (OSS) |
| **Harness** | Cloud | AI-powered CD | Free tier + paid |
| **Octopus Deploy** | Cloud/Self-hosted | .NET, Windows deployments | Paid |

### Full CI/CD Platforms

| Tool | Covers |
|------|--------|
| **GitHub Actions + ArgoCD** | CI (GitHub) + CD (GitOps) — Most popular combo |
| **GitLab CI/CD** | Full platform (CI + CD + Registry + K8s) |
| **Jenkins + ArgoCD** | Legacy CI + Modern CD |
| **Tekton + ArgoCD** | K8s-native CI + K8s-native CD |

---

## 6. Which Tools Are Gaining More Popularity and Why?

### 📈 Trending Up (2024-2026)

| Tool | Growth Reason |
|------|---------------|
| **GitHub Actions** | Largest developer platform, native GitHub integration, marketplace of 20,000+ actions, YAML-first, free for public repos |
| **ArgoCD** | #1 GitOps tool, 18,000+ GitHub stars, CNCF graduated project, visual UI, multi-cluster, Kubernetes-native |
| **Tekton** | Kubernetes-native CI, cloud-agnostic, used by Google Cloud Build and Red Hat OpenShift |
| **FluxCD** | CNCF graduated, lightweight alternative to ArgoCD, great for teams who prefer CLI |

### 📉 Declining or Stagnant

| Tool | Why Declining |
|------|---------------|
| **Jenkins** | Legacy architecture, plugin hell, hard to scale on K8s |
| **Travis CI** | Pricing changes drove OSS community away |
| **CircleCI** | Security breaches impacted trust |
| **Bamboo** | Atlassian ending support, moving to cloud-only |

### Why ArgoCD & GitHub Actions Are Winning

```
┌────────────────────────────────────────────────────────────┐
│    THE WINNING COMBINATION (2024-2026)                      │
├────────────────────────────────────────────────────────────┤
│                                                              │
│    GitHub Actions          +          ArgoCD                │
│    (CI: Build & Test)                 (CD: Deploy)          │
│                                                              │
│    ✅ Free for public repos          ✅ 100% Free & OSS     │
│    ✅ YAML-based                      ✅ Visual UI           │
│    ✅ Huge marketplace                ✅ Multi-cluster       │
│    ✅ No server to manage            ✅ Auto-healing        │
│    ✅ Native GitHub integration      ✅ CNCF Graduated      │
│                                                              │
│    Together: Push code → GH Actions builds → ArgoCD deploys│
│                                                              │
└────────────────────────────────────────────────────────────┘
```

---

## 7. Limitations of Jenkins

Jenkins has been the king of CI/CD for over 15 years, but it has significant limitations in the cloud-native era:

| # | Limitation | Impact |
|---|-----------|--------|
| 1 | **Plugin Dependency Hell** | 1800+ plugins, many outdated/incompatible. Updates break other plugins. |
| 2 | **Not Kubernetes-Native** | Designed for VMs. Running on K8s requires extra plugins (Jenkins X). |
| 3 | **Groovy Scripting** | Jenkinsfile uses Groovy — complex, hard to debug, not YAML-friendly |
| 4 | **Stateful Architecture** | Jenkins master stores state on disk. Not cloud-native. Hard to scale. |
| 5 | **Security Concerns** | Credentials stored on Jenkins server. Pipeline has cluster access. |
| 6 | **Single Point of Failure** | Master goes down = all CI/CD stops |
| 7 | **No Built-in GitOps** | Push-based only. No drift detection. No auto-healing. |
| 8 | **Heavy Maintenance** | Needs dedicated team to manage Jenkins infrastructure |
| 9 | **Slow Feedback Loop** | Agent provisioning takes time. No ephemeral runners by default. |
| 10 | **No Native Multi-cluster** | Managing deployments across clusters is complex |

### Jenkins vs Modern Tools — Quick Example

```groovy
// Jenkins (Groovy Jenkinsfile) — Complex
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myapp:${BUILD_NUMBER} .'
                sh 'docker push myapp:${BUILD_NUMBER}'
            }
        }
        stage('Deploy') {
            steps {
                sh 'kubectl set image deployment/myapp myapp=myapp:${BUILD_NUMBER}'
            }
        }
    }
}
// Problem: Jenkins needs kubectl credentials! Security risk.
```

```yaml
# GitHub Actions (YAML) — Simple, declarative
name: Build and Push
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t myapp:${{ github.sha }} .
      - run: docker push myapp:${{ github.sha }}
      # ArgoCD automatically detects the new image and deploys!
      # No kubectl credentials needed in CI!
```

> 💡 **Key Takeaway:** Jenkins is not dead, but for Kubernetes-native workloads, ArgoCD + GitHub Actions is the better choice. Jenkins still works well for non-K8s, legacy, or highly customized enterprise pipelines.

---

## 8. Why GitOps Came?

### The Problems That Led to GitOps

GitOps emerged because **traditional CI/CD had gaps** that became critical in the Kubernetes era:

```
┌────────────────────────────────────────────────────────────────────┐
│                  PROBLEMS THAT CREATED GITOPS                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. Configuration Drift                                             │
│     → Someone ran "kubectl edit" in production                      │
│     → Cluster state no longer matches what's in Git                 │
│     → Nobody knows the "real" state of production                   │
│                                                                      │
│  2. Security Risks                                                  │
│     → CI pipelines have cluster admin credentials                   │
│     → If Jenkins is compromised, attacker has prod access           │
│     → Credentials scattered across pipeline configs                 │
│                                                                      │
│  3. No Single Source of Truth                                       │
│     → State is split between Git, CI server, cluster                │
│     → "What's actually running in production?" — hard to answer     │
│                                                                      │
│  4. Manual Recovery                                                 │
│     → Cluster crashes, how do you rebuild?                          │
│     → Re-running old pipelines is fragile                           │
│     → Disaster recovery takes hours/days                            │
│                                                                      │
│  5. Audit & Compliance                                              │
│     → "Who deployed this change?" — check CI logs (if they exist)  │
│     → "Can we reproduce the exact prod state from 2 weeks ago?"    │
│                                                                      │
└────────────────────────────────────────────────────────────────────┘
```

### The History

| Year | Event |
|------|-------|
| 2006 | AWS launched, cloud computing begins |
| 2013 | Docker released — containers revolution |
| 2014 | Kubernetes released by Google |
| 2015 | Jenkins dominates CI/CD |
| 2017 | **Weaveworks coins "GitOps"** — Alexis Richardson defines the pattern |
| 2018 | FluxCD released (Weaveworks) |
| 2019 | ArgoCD released (Intuit/Argoproj) |
| 2020 | CNCF adopts both Flux and ArgoCD as sandbox projects |
| 2022 | ArgoCD & FluxCD become CNCF graduated projects |
| 2023 | OpenGitOps standard formalized by CNCF |
| 2024-26 | GitOps becomes industry standard for K8s deployments |

---

## 9. What Problems Does GitOps Solve?

| Problem | How GitOps Solves It |
|---------|---------------------|
| **Configuration Drift** | Continuous reconciliation — if someone manually changes the cluster, GitOps reverts it back to match Git |
| **Security Risk** | Pull-based model — no external tool needs cluster credentials. Only the GitOps agent (inside the cluster) has access |
| **No Source of Truth** | Git IS the truth. What's in Git = what's in production. Period. |
| **Slow Recovery** | Delete the cluster → Point GitOps at Git → Everything rebuilds automatically |
| **Poor Audit Trail** | Every change is a Git commit. Who changed what, when, and why — all in Git history |
| **Complex Rollbacks** | `git revert <commit>` → ArgoCD auto-deploys the previous state. Instant rollback |
| **Multi-cluster Chaos** | One ArgoCD managing 50 clusters from one Git repo. Consistent everywhere |
| **Team Collaboration** | Pull requests for infrastructure changes. Code review before deploy |
| **Compliance** | SOC2, HIPAA, PCI — Git provides immutable audit trail + approval workflows |

### Before & After GitOps

```
BEFORE GitOps:
┌──────┐    kubectl apply     ┌─────────┐
│ Dev  │ ──────────────────▶  │ Cluster │  ← "What's running? Nobody knows!"
└──────┘    ssh + scripts     └─────────┘

AFTER GitOps:
┌──────┐   git push   ┌──────┐   auto-sync   ┌─────────┐
│ Dev  │ ───────────▶  │ Git  │ ◀──────────── │ ArgoCD  │
└──────┘               └──────┘               └────┬────┘
                                                    │ deploys
                                                    ▼
                                              ┌─────────┐
                                              │ Cluster │  ← "State = Git. Always."
                                              └─────────┘
```

---

## 10. Why GitOps is a High-Demand Skill in Current Market

### Job Market Data (2024-2026)

| Metric | Value |
|--------|-------|
| **GitOps job postings** | 300% increase since 2022 |
| **Average salary (India)** | ₹15-35 LPA for GitOps/K8s engineers |
| **Average salary (US)** | $130K-$180K for Senior DevOps with GitOps |
| **ArgoCD adoption** | Used by 70%+ of Kubernetes-using companies |
| **CNCF Survey 2024** | ArgoCD is #1 most used CD tool for Kubernetes |

### Why Companies Need GitOps Engineers

1. **Kubernetes is everywhere** — 96% of organizations use or evaluate Kubernetes (CNCF 2024)
2. **Compliance requirements** — SOC2, HIPAA, PCI-DSS all need audit trails → GitOps provides it
3. **Multi-cloud strategy** — Companies run on AWS + Azure + GCP → GitOps unifies management
4. **Platform Engineering** — Internal Developer Platforms (IDPs) are built on GitOps
5. **AI/ML Infrastructure** — Model deployments use GitOps for reproducibility

### Companies Using ArgoCD in Production

| Company | Scale |
|---------|-------|
| **Intuit** (TurboTax, QuickBooks) | Created ArgoCD, 100+ clusters |
| **Red Hat/IBM** | OpenShift GitOps (based on ArgoCD) |
| **Tesla** | Vehicle software deployment |
| **NVIDIA** | AI infrastructure |
| **Alibaba** | Massive scale K8s |
| **Adobe** | Creative Cloud services |
| **Ticketmaster** | Event platform |
| **New Relic** | Observability platform |

---

## 11. What is the Future of GitOps?

### Current Trends (2025-2026)

| Trend | Description |
|-------|-------------|
| **Platform Engineering** | GitOps as the backbone of Internal Developer Platforms |
| **AI-Assisted GitOps** | AI suggesting config changes, auto-remediation |
| **Multi-cluster at Scale** | Managing 100+ clusters from single control plane |
| **Progressive Delivery** | Canary, Blue-Green, A/B testing via Argo Rollouts |
| **GitOps for Everything** | Not just K8s — databases, cloud resources, policies |
| **Policy as Code** | OPA/Kyverno policies managed via GitOps |
| **Secret Management** | External Secrets Operator + GitOps |
| **Edge Computing** | GitOps for edge/IoT Kubernetes clusters |

### What's Coming Next

```
2025-2026: GitOps Standard        → OpenGitOps v1.0 standard widely adopted
2025-2026: AI + GitOps            → Auto-remediation, smart rollbacks
2026-2027: GitOps Everywhere      → Non-K8s workloads (VMs, serverless)
2027+:     Autonomous Operations  → Self-healing infrastructure with zero human input
```

---

## 12. Why Should You Learn GitOps?

### For Your Career

| Reason | Impact |
|--------|--------|
| **High salary** | GitOps/K8s skills command 30-50% premium over traditional DevOps |
| **Job security** | K8s adoption only growing — GitOps is the standard CD approach |
| **Future-proof** | Even as AI evolves, declarative infrastructure management stays |
| **Leadership path** | Platform Engineers (GitOps experts) are the new Staff Engineers |
| **Freelancing** | GitOps consulting rates: $150-300/hour internationally |

### For Your Organization

| Reason | Impact |
|--------|--------|
| **Faster deployments** | From weekly to multiple-times-daily releases |
| **Reduced downtime** | Auto-healing + instant rollbacks |
| **Security compliance** | Built-in audit trail satisfies auditors |
| **Lower MTTR** | Mean Time to Recovery drops from hours to minutes |
| **Cost savings** | Less manual ops work = smaller ops team needed |
| **Developer happiness** | Developers self-serve via Git PRs, no ops tickets |

### Learning Path

```
1. Learn Kubernetes basics (pods, deployments, services)
2. Understand Git workflows (branches, PRs, merge strategies)
3. Set up ArgoCD (this course!)
4. Master Helm & Kustomize (templating for GitOps)
5. Learn ApplicationSets & App of Apps pattern
6. Production: RBAC, SSO, monitoring, multi-cluster
7. Advanced: Argo Rollouts, Workflows, Events
```

---

## 13. Is GitOps Free or Paid?

### The Core Tools — 100% FREE & Open Source

| Tool | License | Cost |
|------|---------|------|
| **ArgoCD** | Apache 2.0 | ✅ FREE forever |
| **FluxCD** | Apache 2.0 | ✅ FREE forever |
| **Git** | GPL v2 | ✅ FREE |
| **Kubernetes** | Apache 2.0 | ✅ FREE |
| **Helm** | Apache 2.0 | ✅ FREE |
| **Kustomize** | Apache 2.0 | ✅ FREE |

### What You Might Pay For

| Service | Why You Pay | Cost Range |
|---------|-------------|------------|
| **Cloud Infrastructure** | EC2/EKS/GKE to run the cluster | $50-$500+/month |
| **GitHub/GitLab** | Private repos, advanced features | Free tier available |
| **Enterprise Support** | Akuity (ArgoCD enterprise), Weaveworks | $5K-$50K/year |
| **Managed ArgoCD** | Akuity Platform, Red Hat OpenShift GitOps | Varies |

### Bottom Line

```
┌────────────────────────────────────────────────────────┐
│                                                          │
│   GitOps ITSELF is 100% FREE.                           │
│                                                          │
│   ArgoCD is open source — no license fees, ever.        │
│                                                          │
│   You pay for: infrastructure to run it (cloud/VMs)     │
│   and optionally: enterprise support & managed service  │
│                                                          │
│   For learning: You can run it on your laptop for $0.   │
│                                                          │
└────────────────────────────────────────────────────────┘
```

---

## 14. GitOps Principles with Examples

GitOps is built on **4 core principles** defined by the [OpenGitOps](https://opengitops.dev/) standard (CNCF):

### Principle 1: Declarative

> "The entire system MUST be described declaratively."

**What it means:** You define WHAT you want (desired state), not HOW to get there (imperative commands).

```yaml
# ✅ DECLARATIVE (GitOps way) — "I want 3 replicas of nginx"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
```

```bash
# ❌ IMPERATIVE (Non-GitOps way) — "Run these commands"
kubectl create deployment nginx --image=nginx:1.25
kubectl scale deployment nginx --replicas=3
# Problem: This isn't stored anywhere! If cluster dies, what commands do you re-run?
```

### Principle 2: Versioned and Immutable

> "The desired state is stored in a way that enforces immutability, versioning, and retains a complete version history."

**What it means:** Git provides complete history. Every change is a commit. You can go back to any point in time.

```bash
# Example: Complete deployment history in Git
git log --oneline
a1b2c3d  (HEAD) Update nginx to 1.26 (3 replicas)
e4f5g6h  Scale nginx to 5 replicas for Black Friday
i7j8k9l  Initial nginx deployment (1.25, 3 replicas)

# Want to rollback to last week? Just revert!
git revert a1b2c3d
# ArgoCD automatically deploys the previous state
```

### Principle 3: Pulled Automatically

> "Software agents automatically pull the desired state declarations from the source."

**What it means:** The GitOps controller (ArgoCD) runs INSIDE the cluster and continuously pulls the desired state from Git. No external tool pushes changes in.

```
PUSH Model (Traditional CI/CD):
┌──────────┐      ┌─────────────┐      ┌─────────┐
│ Git Repo │─────▶│ CI Pipeline │─────▶│ Cluster │
└──────────┘      └─────────────┘      └─────────┘
                   Has cluster credentials (RISK!)

PULL Model (GitOps):
┌──────────┐                           ┌─────────┐
│ Git Repo │◀──── pulls every 3 min ───│ ArgoCD  │ (runs inside cluster)
└──────────┘                           └────┬────┘
                                            │ deploys locally
                                            ▼
                                       ┌─────────┐
                                       │ Cluster │
                                       └─────────┘
                   No external credentials needed!
```

### Principle 4: Continuously Reconciled

> "Software agents continuously observe actual system state and attempt to apply the desired state."

**What it means:** If someone manually changes the cluster (drift), ArgoCD detects it and automatically reverts to match Git.

```bash
# Example: Auto-healing in action

# Someone manually deletes a pod:
kubectl delete pod nginx-abc123 -n production

# ArgoCD detects drift within seconds:
# Live state (2 pods) ≠ Desired state in Git (3 pods)
# → ArgoCD recreates the pod automatically!

# Someone manually scales down:
kubectl scale deployment nginx --replicas=1

# ArgoCD detects drift:
# Live (1 replica) ≠ Git (3 replicas)
# → ArgoCD scales back to 3 automatically!
```

---

## 15. GitOps vs Traditional CI/CD

### Detailed Comparison

| Feature | Traditional CI/CD | GitOps |
|---------|-------------------|--------|
| **Deployment Model** | Push (CI pushes to cluster) | Pull (cluster pulls from Git) |
| **Source of Truth** | CI pipeline / scripts | Git repository |
| **Security** | CI needs cluster credentials (risky!) | Agent runs in-cluster (no external creds) |
| **Drift Detection** | None (manual checks) | Continuous, automatic |
| **Rollback** | Re-run old pipeline (may fail) | `git revert` → auto-sync (always works) |
| **Recovery** | Rebuild from scratch (hours) | Point to Git → rebuild (minutes) |
| **Audit Trail** | CI logs (may expire) | Git history (permanent, immutable) |
| **Visibility** | Check CI dashboard | ArgoCD UI shows real-time cluster state |
| **Multi-cluster** | Custom scripts per cluster | Native (one ArgoCD → many clusters) |
| **Approval Flow** | CI-specific (varies) | Git Pull Request (universal) |
| **Learning Curve** | Tool-specific (Jenkins, GitLab, etc.) | Git + K8s knowledge (transferable) |
| **Scalability** | Add more CI agents | Single ArgoCD manages 100+ apps |

### Flow Comparison

```
TRADITIONAL CI/CD FLOW:
┌────────┐   ┌─────────────┐   ┌────────────────┐   ┌─────────┐
│ Dev    │──▶│ Git (code)  │──▶│ CI: Build+Test │──▶│ Deploy  │
│ pushes │   │             │   │ Jenkins/GH     │   │ kubectl │
│ code   │   │             │   │ Actions        │   │ apply   │
└────────┘   └─────────────┘   └────────────────┘   └────┬────┘
                                                          │
                                   Who has access? ◀──────┘
                                   What if CI hacked?
                                   What if drift?

GITOPS FLOW:
┌────────┐   ┌─────────────┐   ┌────────────────┐   ┌──────────┐
│ Dev    │──▶│ Git (code)  │──▶│ CI: Build+Test │──▶│ Git      │
│ pushes │   │             │   │ Build image    │   │ (config) │
│ code   │   │             │   │ Update YAML    │   │ repo     │
└────────┘   └─────────────┘   └────────────────┘   └─────┬────┘
                                                           │
                                              ArgoCD polls │ (every 3 min)
                                                           ▼
                                                     ┌──────────┐
                                                     │ ArgoCD   │
                                                     │ (in K8s) │
                                                     └─────┬────┘
                                                           │ syncs
                                                           ▼
                                                     ┌──────────┐
                                                     │ Cluster  │
                                                     │ (safe!)  │
                                                     └──────────┘
```

---

## 16. Why ArgoCD for GitOps?

### Top Reasons to Choose ArgoCD

| # | Reason | Details |
|---|--------|---------|
| 1 | **Kubernetes-Native** | Built as a K8s controller. Uses CRDs. Feels native. |
| 2 | **Beautiful UI** | Real-time visualization of apps, resources, sync status |
| 3 | **Multi-Cluster** | Manage 100+ clusters from one ArgoCD instance |
| 4 | **Multiple Config Tools** | Supports Helm, Kustomize, Jsonnet, plain YAML |
| 5 | **CNCF Graduated** | Production-ready, enterprise-grade, community-backed |
| 6 | **RBAC & SSO** | Fine-grained access control, integrates with OIDC/SAML/LDAP |
| 7 | **App of Apps** | Scale to hundreds of apps with patterns |
| 8 | **ApplicationSets** | Template apps for multiple clusters/environments |
| 9 | **Notifications** | Slack, email, webhook alerts on sync/health changes |
| 10 | **Image Updater** | Auto-detect new container images and update Git |
| 11 | **Rich Ecosystem** | Part of Argo Project: Rollouts, Workflows, Events |
| 12 | **Free & Open Source** | Apache 2.0 license, no vendor lock-in |
| 13 | **Active Community** | 18,000+ GitHub stars, 600+ contributors, weekly releases |
| 14 | **Enterprise Proven** | Used by Intuit, Tesla, Adobe, Red Hat at massive scale |

### ArgoCD Unique Features

```
┌────────────────────────────────────────────────────────────────┐
│                  ArgoCD — WHAT MAKES IT SPECIAL                  │
├────────────────────────────────────────────────────────────────┤
│                                                                  │
│  🔄 Continuous Reconciliation                                   │
│     → Checks every 3 minutes (configurable)                    │
│     → Detects & fixes drift automatically                      │
│                                                                  │
│  🏥 Health Assessment                                           │
│     → Custom health checks per resource type                   │
│     → Knows if your app is truly healthy (not just running)    │
│                                                                  │
│  📊 Resource Tree Visualization                                 │
│     → See Deployment → ReplicaSet → Pods → Containers         │
│     → Drill down to individual pod logs                        │
│                                                                  │
│  ⏱️  Sync Windows                                                │
│     → "Only deploy Mon-Fri 9am-5pm"                            │
│     → Protect production during off-hours                      │
│                                                                  │
│  🌊 Sync Waves & Hooks                                          │
│     → Order-dependent deployments (DB before App)              │
│     → Pre/Post sync jobs (migrations, notifications)           │
│                                                                  │
│  🔐 Web-based Terminal                                           │
│     → SSH into pods directly from ArgoCD UI                    │
│                                                                  │
└────────────────────────────────────────────────────────────────┘
```

---

## 17. ArgoCD vs FluxCD vs Jenkins X

### Detailed Comparison

| Feature | ArgoCD | FluxCD | Jenkins X |
|---------|--------|--------|-----------|
| **UI Dashboard** | ✅ Rich, real-time | ❌ No UI (CLI only) | ⚠️ Basic |
| **Multi-cluster** | ✅ Native, first-class | ⚠️ Requires Flux per cluster | ⚠️ Complex |
| **Helm Support** | ✅ Full | ✅ Full | ✅ Full |
| **Kustomize** | ✅ Full | ✅ Full | ⚠️ Limited |
| **RBAC** | ✅ Fine-grained | ⚠️ K8s RBAC only | ⚠️ Basic |
| **SSO/OIDC** | ✅ Built-in (Dex) | ❌ External | ⚠️ Complex |
| **App of Apps** | ✅ Native pattern | ⚠️ Kustomization refs | ❌ No |
| **ApplicationSets** | ✅ Powerful generators | ❌ No equivalent | ❌ No |
| **Notifications** | ✅ Built-in controller | ⚠️ External (Flux Alert) | ❌ No |
| **Image Updater** | ✅ Separate controller | ✅ Built-in (image automation) | ⚠️ CI-based |
| **Progressive Delivery** | ✅ Argo Rollouts | ⚠️ Flagger (separate) | ❌ No |
| **CI Integration** | ❌ CD only | ❌ CD only | ✅ CI + CD |
| **Resource Footprint** | Medium (~200MB RAM) | Light (~100MB RAM) | Heavy (~1GB+) |
| **CNCF Status** | ✅ Graduated | ✅ Graduated | ❌ Archived |
| **Community** | 18K+ stars, very active | 7K+ stars, active | Declining |
| **Learning Curve** | Medium | Easy (CLI-focused) | Hard |
| **Best For** | Teams wanting visual control + scale | Teams preferring CLI + lightweight | Legacy Jenkins users |

### When to Choose What

| Choose **ArgoCD** when: | Choose **FluxCD** when: |
|------------------------|------------------------|
| You want a visual UI | You prefer CLI-only |
| Multi-cluster management | Single cluster, lightweight |
| Enterprise RBAC/SSO needed | Simple team structure |
| You need ApplicationSets | You want image auto-update built-in |
| Argo Rollouts for progressive delivery | Flagger is acceptable |
| Large teams, many apps | Small teams, few apps |

---

## 18. ArgoCD Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           ArgoCD ARCHITECTURE                                     │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                   │
│   EXTERNAL                          KUBERNETES CLUSTER (argocd namespace)         │
│                                                                                   │
│  ┌─────────┐                     ┌──────────────────────────────────────────┐   │
│  │  Users  │                     │                                            │   │
│  │ (UI/CLI)│────HTTPS────▶      │   ┌─────────────────────────────────┐     │   │
│  └─────────┘                     │   │     ArgoCD API SERVER            │     │   │
│                                  │   │  (argocd-server)                 │     │   │
│  ┌─────────┐                     │   │                                   │     │   │
│  │CI/CD    │────REST API──▶     │   │  • REST/gRPC API                 │     │   │
│  │(GH      │                     │   │  • Web UI serving                │     │   │
│  │Actions) │                     │   │  • Authentication (Dex/OIDC)     │     │   │
│  └─────────┘                     │   │  • RBAC enforcement              │     │   │
│                                  │   │  • Webhook processing            │     │   │
│                                  │   └──────────┬──────────────────────┘     │   │
│                                  │              │                              │   │
│                                  │              ▼                              │   │
│  ┌─────────┐                     │   ┌─────────────────────────────────┐     │   │
│  │  Git    │◀───── clones ──────│   │     REPO SERVER                  │     │   │
│  │  Repos  │                     │   │  (argocd-repo-server)            │     │   │
│  │(GitHub, │                     │   │                                   │     │   │
│  │ GitLab) │                     │   │  • Clones Git repositories       │     │   │
│  └─────────┘                     │   │  • Generates manifests           │     │   │
│                                  │   │  • Helm template rendering       │     │   │
│  ┌─────────┐                     │   │  • Kustomize build              │     │   │
│  │  Helm   │◀───── pulls ───────│   │  • Jsonnet evaluation            │     │   │
│  │  Repos  │                     │   │  • Caches repo content           │     │   │
│  └─────────┘                     │   └──────────┬──────────────────────┘     │   │
│                                  │              │                              │   │
│                                  │              ▼                              │   │
│                                  │   ┌─────────────────────────────────┐     │   │
│                                  │   │   APPLICATION CONTROLLER         │     │   │
│                                  │   │(argocd-application-controller)   │     │   │
│                                  │   │                                   │     │   │
│                                  │   │  • Compares desired vs live      │     │   │
│                                  │   │  • Detects OutOfSync state       │     │   │
│                                  │   │  • Triggers sync operations      │     │   │
│                                  │   │  • Health assessment             │     │   │
│                                  │   │  • Auto-healing (if enabled)     │     │   │
│                                  │   └──────────┬──────────────────────┘     │   │
│                                  │              │                              │   │
│                                  │   ┌──────────┴──────────────────────┐     │   │
│                                  │   │     SUPPORTING COMPONENTS        │     │   │
│                                  │   ├─────────────────────────────────┤     │   │
│                                  │   │                                   │     │   │
│                                  │   │  📦 Redis (argocd-redis)         │     │   │
│                                  │   │     → Caching, session store     │     │   │
│                                  │   │                                   │     │   │
│                                  │   │  🔐 Dex (argocd-dex-server)      │     │   │
│                                  │   │     → SSO/OIDC authentication    │     │   │
│                                  │   │                                   │     │   │
│                                  │   │  📋 ApplicationSet Controller    │     │   │
│                                  │   │     → Templated app generation   │     │   │
│                                  │   │                                   │     │   │
│                                  │   │  🔔 Notifications Controller     │     │   │
│                                  │   │     → Slack/email/webhook alerts │     │   │
│                                  │   │                                   │     │   │
│                                  │   └─────────────────────────────────┘     │   │
│                                  │                                            │   │
│                                  └──────────────────────────────────────────┘   │
│                                                                                   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Core Components and Their Functions

| # | Component | K8s Resource | Function | Scalable? |
|---|-----------|-------------|----------|-----------|
| 1 | **API Server** | Deployment | Frontend for UI/CLI/API. Handles auth, RBAC, webhooks | Yes (HPA) |
| 2 | **Repo Server** | Deployment | Clones Git repos, renders Helm/Kustomize, caches manifests | Yes (HPA) |
| 3 | **Application Controller** | StatefulSet | Core brain — compares desired vs live state, triggers sync | Sharding |
| 4 | **Redis** | Deployment | In-memory cache for repo data, session store, rate limiting | Yes |
| 5 | **Dex Server** | Deployment | SSO/OIDC proxy for authentication (GitHub, Google, LDAP) | Yes |
| 6 | **ApplicationSet Controller** | Deployment | Generates Applications from templates (generators) | Yes |
| 7 | **Notifications Controller** | Deployment | Sends alerts via Slack, email, webhook, Teams, etc. | Yes |

### How Components Interact (Data Flow)

```
1. User creates Application CRD (via UI/CLI/Git)
         │
         ▼
2. API Server receives request, validates RBAC
         │
         ▼
3. Application Controller picks up the new Application
         │
         ▼
4. Controller asks Repo Server: "What manifests are in this Git path?"
         │
         ▼
5. Repo Server clones the repo, runs Helm/Kustomize, returns manifests
         │
         ▼
6. Controller compares manifests (desired) vs live cluster state
         │
         ├── If SAME → Status: Synced ✅
         │
         └── If DIFFERENT → Status: OutOfSync ⚠️
                    │
                    ▼
         7. If auto-sync enabled → Controller applies changes to cluster
         8. If manual sync → Waits for user to click "Sync"
                    │
                    ▼
         9. Notifications Controller sends alert (if configured)
```

### Why Application Controller is a StatefulSet

The Application Controller is deployed as a **StatefulSet** (not Deployment) because:
- It maintains in-memory state about all applications
- Supports sharding for horizontal scaling (each instance handles a subset of apps)
- Needs stable network identity for cluster sharding
- At large scale (500+ apps), you shard across multiple controller instances

### Reconciliation Loop (Every 3 Minutes)

```
┌─────────────────────────────────────────┐
│     ArgoCD Reconciliation Loop          │
│     (runs every 3 minutes by default)   │
├─────────────────────────────────────────┤
│                                          │
│  1. Poll Git repo for changes           │
│         │                                │
│         ▼                                │
│  2. Generate desired manifests           │
│     (Helm template / Kustomize build)   │
│         │                                │
│         ▼                                │
│  3. Fetch live state from K8s API       │
│         │                                │
│         ▼                                │
│  4. Compare desired vs live (diff)       │
│         │                                │
│         ├── No diff → Synced ✅          │
│         │                                │
│         └── Diff found → OutOfSync ⚠️   │
│                   │                      │
│                   ▼                      │
│         5a. Auto-sync ON → Apply diff    │
│         5b. Auto-sync OFF → Alert user  │
│                   │                      │
│                   ▼                      │
│         6. Update health status          │
│         7. Send notifications            │
│                                          │
│  ─── Wait 3 minutes ─── Loop again ──── │
│                                          │
└─────────────────────────────────────────┘
```

> 💡 **Tip:** You can also configure webhooks from Git (GitHub/GitLab) to notify ArgoCD immediately on push, rather than waiting for the next poll cycle.

---

## 19. Key ArgoCD Concepts

### 1. Application

The **Application** is the most fundamental object in ArgoCD. It defines the connection between a Git source and a Kubernetes destination.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default

  # SOURCE: Where to get the manifests
  source:
    repoURL: https://github.com/techmahato/my-app-config.git
    targetRevision: main
    path: k8s/production        # Folder containing YAML files

  # DESTINATION: Where to deploy
  destination:
    server: https://kubernetes.default.svc   # In-cluster
    namespace: production

  # SYNC POLICY: How to sync
  syncPolicy:
    automated:
      prune: true               # Delete resources not in Git
      selfHeal: true            # Revert manual changes
    syncOptions:
      - CreateNamespace=true    # Auto-create namespace if missing
```

**Key fields:**
| Field | Purpose |
|-------|---------|
| `source.repoURL` | Git repository URL |
| `source.path` | Path within the repo containing manifests |
| `source.targetRevision` | Branch, tag, or commit SHA |
| `destination.server` | Target Kubernetes cluster API URL |
| `destination.namespace` | Target namespace for deployment |
| `syncPolicy.automated` | Enable automatic sync |

---

### 2. Project (AppProject)

**Projects** provide logical grouping and access control for Applications. They define WHAT repositories, clusters, and namespaces an Application can use.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-backend
  namespace: argocd
spec:
  description: "Backend team - production services"

  # Allowed source repositories
  sourceRepos:
    - 'https://github.com/techmahato/backend-*'
    - 'https://github.com/techmahato/shared-infra'

  # Allowed destination clusters and namespaces
  destinations:
    - server: https://kubernetes.default.svc
      namespace: 'backend-*'
    - server: https://kubernetes.default.svc
      namespace: 'shared'

  # Allowed cluster-scoped resources
  clusterResourceWhitelist:
    - group: ''
      kind: Namespace

  # RBAC: Who can manage apps in this project
  roles:
    - name: developer
      description: "Backend developers"
      policies:
        - p, proj:team-backend:developer, applications, get, team-backend/*, allow
        - p, proj:team-backend:developer, applications, sync, team-backend/*, allow
      groups:
        - backend-team     # Maps to SSO/OIDC group
```

**Why use Projects?**
| Use Case | How Projects Help |
|----------|-------------------|
| **Multi-team** | Team A can only deploy to their namespaces |
| **Security** | Restrict which repos and clusters a team can access |
| **Blast radius** | Limit what a misconfiguration can affect |
| **Compliance** | Enforce policies per team/environment |

**Default Project:** ArgoCD comes with a `default` project that allows everything. In production, always create specific projects.

---

### 3. Repositories

Repositories are Git repos or Helm chart repos registered with ArgoCD.

**Types of Repositories:**

| Type | Example | Use Case |
|------|---------|----------|
| **Git (HTTPS)** | `https://github.com/org/repo.git` | Most common |
| **Git (SSH)** | `git@github.com:org/repo.git` | Private repos with SSH keys |
| **Helm Repo** | `https://charts.bitnami.com/bitnami` | Pre-built Helm charts |
| **OCI Registry** | `oci://ghcr.io/org/chart` | Helm charts in OCI format |

**Register a repo via CLI:**

```bash
# Public repo (no auth needed)
argocd repo add https://github.com/techmahato/my-app.git

# Private repo with SSH key
argocd repo add git@github.com:techmahato/private-app.git \
  --ssh-private-key-path ~/.ssh/id_ed25519

# Private repo with HTTPS token
argocd repo add https://github.com/techmahato/private-app.git \
  --username git --password <GITHUB_PAT>

# Helm repository
argocd repo add https://charts.bitnami.com/bitnami --type helm --name bitnami
```

**Supported manifest formats per repo:**
- Plain YAML/JSON files
- Helm charts (Chart.yaml + templates/)
- Kustomize (kustomization.yaml)
- Jsonnet (.jsonnet files)
- Custom Config Management Plugins (CMP)

---

### 4. Health Status

ArgoCD continuously assesses the **health** of every resource in your application. This goes beyond just "pod is running" — it checks if the resource is functioning correctly.

| Status | Icon | Meaning | Example |
|--------|------|---------|---------|
| **Healthy** | 💚 | Resource is working as expected | Deployment has all replicas ready |
| **Progressing** | 🔵 | Resource is being updated | Deployment rolling out new version |
| **Degraded** | 🔴 | Resource has a problem | Pod in CrashLoopBackOff |
| **Suspended** | ⏸️ | Resource is paused | CronJob suspended |
| **Missing** | ❓ | Resource expected but not found | Deleted manually from cluster |
| **Unknown** | ❔ | Health cannot be determined | Custom resource without health check |

**Health check hierarchy:**

```
Application Health
├── Deployment (Healthy ✅ — all replicas ready)
│   ├── ReplicaSet (Healthy ✅)
│   │   ├── Pod 1 (Running ✅)
│   │   ├── Pod 2 (Running ✅)
│   │   └── Pod 3 (CrashLoop 🔴) ← Degraded!
│   └── Overall: Degraded 🔴 (one pod failing)
├── Service (Healthy ✅ — endpoints registered)
├── Ingress (Healthy ✅ — address assigned)
└── ConfigMap (Healthy ✅ — exists)

Application Overall: DEGRADED 🔴
(because at least one child is degraded)
```

**Custom health checks:** ArgoCD supports custom Lua scripts for health assessment of CRDs:

```lua
-- Custom health check for a CRD
hs = {}
if obj.status ~= nil then
  if obj.status.phase == "Ready" then
    hs.status = "Healthy"
    hs.message = "Resource is ready"
  elseif obj.status.phase == "Failed" then
    hs.status = "Degraded"
    hs.message = obj.status.message
  else
    hs.status = "Progressing"
    hs.message = "Resource is being provisioned"
  end
end
return hs
```

---

### 5. Rollbacks

ArgoCD maintains a **history** of all sync operations. You can rollback to any previous successful revision.

**How Rollback Works:**

```
Revision History:
┌────────┬──────────────────────────┬────────┬──────────────┐
│ Rev #  │ Git Commit               │ Status │ Date         │
├────────┼──────────────────────────┼────────┼──────────────┤
│ 5      │ abc123 (broken image)    │ Failed │ Today 10:00  │
│ 4      │ def456 (add feature X)   │ Synced │ Yesterday    │  ← Rollback here!
│ 3      │ ghi789 (update config)   │ Synced │ 2 days ago   │
│ 2      │ jkl012 (scale to 5)      │ Synced │ 1 week ago   │
│ 1      │ mno345 (initial deploy)  │ Synced │ 2 weeks ago  │
└────────┴──────────────────────────┴────────┴──────────────┘
```

**Rollback methods:**

```bash
# Method 1: ArgoCD CLI
argocd app rollback my-app 4    # Rollback to revision 4

# Method 2: Git revert (preferred — maintains Git history)
git revert abc123               # Reverts the broken commit
git push                        # ArgoCD auto-syncs to previous state

# Method 3: ArgoCD UI
# Click on app → History → Select revision → "Rollback"
```

> ⚠️ **Important:** If `automated sync` is enabled, a CLI/UI rollback will be temporary — ArgoCD will re-sync to the latest Git state on the next reconciliation. For permanent rollback, always use `git revert`.

---

### 6. Auto-Healing (Self-Heal)

When `selfHeal: true` is set in the sync policy, ArgoCD automatically reverts any manual changes made to the cluster.

**How it works:**

```
1. Desired State (Git): replicas = 3
2. Someone runs: kubectl scale deployment myapp --replicas=1
3. ArgoCD detects: Live (1) ≠ Desired (3) → DRIFT!
4. ArgoCD auto-heals: scales back to 3 replicas

Timeline:
00:00  kubectl scale --replicas=1  (manual change)
00:05  ArgoCD detects drift (within polling interval)
00:06  ArgoCD applies desired state from Git
00:07  Replicas back to 3  ← Auto-healed!
```

**Enable auto-healing:**

```yaml
syncPolicy:
  automated:
    selfHeal: true    # ← This enables auto-healing
    prune: true       # Also delete resources removed from Git
```

**What auto-healing protects against:**
- Someone manually deleting pods
- Someone manually scaling deployments
- Someone editing ConfigMaps directly
- Someone adding resources not in Git (if prune is enabled, these get deleted)

> 💡 **Production Tip:** Always enable `selfHeal` in production. It's your safety net against unauthorized or accidental manual changes.

---

### 7. Sync & Sync Policies

**Sync** is the process of making the live cluster state match the desired state in Git.

#### Sync Modes

| Mode | Trigger | Use Case |
|------|---------|----------|
| **Manual Sync** | User clicks "Sync" or runs `argocd app sync` | Controlled deployments, production |
| **Automatic Sync** | ArgoCD auto-syncs when Git changes detected | Dev/staging, fast iteration |

#### Sync Policy Configuration

```yaml
syncPolicy:
  automated:
    prune: true           # Delete resources removed from Git
    selfHeal: true        # Revert manual cluster changes
    allowEmpty: false     # Don't sync if Git returns empty manifests (safety)
  retry:
    limit: 5             # Retry failed syncs up to 5 times
    backoff:
      duration: 5s       # Initial retry delay
      factor: 2          # Multiply delay each retry (5s, 10s, 20s, 40s, 80s)
      maxDuration: 3m    # Maximum retry delay
```

#### Sync Waves

Sync Waves control the **order** in which resources are synced. Lower wave numbers sync first.

```yaml
# Wave 0: Namespace (created first)
apiVersion: v1
kind: Namespace
metadata:
  name: production
  annotations:
    argocd.argoproj.io/sync-wave: "0"

# Wave 1: ConfigMap and Secrets (created second)
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  annotations:
    argocd.argoproj.io/sync-wave: "1"

# Wave 2: Database (created third)
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  annotations:
    argocd.argoproj.io/sync-wave: "2"

# Wave 3: Application (created last, after DB is ready)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  annotations:
    argocd.argoproj.io/sync-wave: "3"
```

#### Sync Hooks

Hooks run custom Jobs/Pods at specific phases of the sync lifecycle.

| Hook Phase | When It Runs | Use Case |
|------------|-------------|----------|
| **PreSync** | Before sync starts | DB migrations, backups |
| **Sync** | During sync | Deploy alongside resources |
| **PostSync** | After sync completes | Smoke tests, notifications |
| **SyncFail** | When sync fails | Cleanup, alerting |
| **Skip** | Never synced | Documentation resources |

```yaml
# Example: Run DB migration before deploying app
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migrate
  annotations:
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
spec:
  template:
    spec:
      containers:
      - name: migrate
        image: myapp:latest
        command: ["python", "manage.py", "migrate"]
      restartPolicy: Never
```

#### Sync Flags

| Flag | Effect |
|------|--------|
| `--prune` | Delete resources in cluster that are NOT in Git |
| `--force` | Force-apply (recreate resources instead of patch) |
| `--replace` | Use `kubectl replace` instead of `kubectl apply` |
| `--dry-run` | Preview changes without applying |
| `--retry` | Retry sync if it fails |

---

### 8. Sync Options

Sync Options provide fine-grained control over how ArgoCD applies resources.

| Sync Option | Default | What It Does |
|-------------|---------|--------------|
| `Validate=false` | true | Skip Kubernetes schema validation |
| `CreateNamespace=true` | false | Auto-create target namespace if missing |
| `PruneLast=true` | false | Delete resources at END of sync (safer order) |
| `ApplyOutOfSyncOnly=true` | false | Only apply resources that have changed |
| `PrunePropagationPolicy=foreground` | background | Wait for child resources to be deleted |
| `RespectIgnoreDifferences=true` | false | Don't overwrite fields marked as "ignore" |
| `ServerSideApply=true` | false | Use K8s server-side apply (better for large CRDs) |
| `Replace=true` | false | Replace instead of patch (for immutable fields) |
| `FailOnSharedResource=true` | false | Fail if resource is managed by another app |

**Configure in Application spec:**

```yaml
syncPolicy:
  syncOptions:
    - CreateNamespace=true
    - PruneLast=true
    - ApplyOutOfSyncOnly=true
    - ServerSideApply=true
```

**Per-resource sync options (annotation):**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
  annotations:
    argocd.argoproj.io/sync-options: Replace=true
    # This specific resource will use kubectl replace instead of apply
```

#### Ignore Differences

Sometimes you want ArgoCD to ignore certain fields that are auto-managed by K8s (like `status` or `metadata.resourceVersion`):

```yaml
spec:
  ignoreDifferences:
    - group: apps
      kind: Deployment
      jsonPointers:
        - /spec/replicas           # Ignore replica count (managed by HPA)
    - group: ""
      kind: Service
      jqPathExpressions:
        - .spec.clusterIP          # Ignore auto-assigned cluster IP
```

---

## 📋 Summary

```
┌──────────────────────────────────────────────────────────────────────┐
│                         CHAPTER SUMMARY                                │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  📖 SDLC → CI/CD → GitOps (The evolution)                            │
│                                                                        │
│  🔄 CI/CD automates build, test, deploy                              │
│     → Solved manual, error-prone processes                           │
│                                                                        │
│  🚨 Traditional CI/CD limitations led to GitOps                      │
│     → Push model, credential risk, no drift detection                │
│                                                                        │
│  🌟 GitOps = Git as Single Source of Truth                           │
│     → Declarative, Versioned, Pulled, Reconciled                     │
│                                                                        │
│  🏆 ArgoCD = Best GitOps tool for Kubernetes                         │
│     → UI, Multi-cluster, RBAC, CNCF Graduated, Free                 │
│                                                                        │
│  🏗️  ArgoCD Architecture                                              │
│     → API Server + Repo Server + App Controller + Redis + Dex        │
│                                                                        │
│  📦 Key Concepts                                                      │
│     → Application, Project, Repos, Health, Rollbacks,                │
│       Auto-Healing, Sync Policies, Sync Options                      │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
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

## 📚 References

- [ArgoCD Official Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [ArgoCD Architecture](https://argo-cd.readthedocs.io/en/stable/operator-manual/architecture/)
- [OpenGitOps Principles](https://opengitops.dev/)
- [CNCF GitOps Working Group](https://github.com/cncf/tag-app-delivery/tree/main/gitops-wg)
- [Argo Project GitHub](https://github.com/argoproj/argo-cd)

---

> 🙏 **If this helped you, please Star ⭐ the repo and Subscribe 🔔 to [TECH MAHATO on YouTube](https://www.youtube.com/techmahato)!**
>
> 💡 **Next:** Move to `03_setup_installation` to set up ArgoCD on your own cluster!
