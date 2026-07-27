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

> 💡 **Continue below for ArgoCD UI, Settings, Projects & Repository configuration.**

---

## 20. 🖥️ ArgoCD UI — Understanding the Web Dashboard

> The entire content about ArgoCD UI, Settings, Projects, and Repositories has been included here as part of ArgoCD fundamentals. For the full detailed guide, see the sections below.

ArgoCD provides a real-time web dashboard for visual control over GitOps deployments. Access it at `https://<your-ip>:8080` after setup.

### UI Layout & Navigation

| Icon | Section | Purpose |
|------|---------|---------|
| 📱 | **Applications** | Main dashboard — view all apps, sync/health status |
| ⚙️ | **Settings** | Configure projects, repos, clusters, accounts, certificates |
| 👤 | **User Info** | Current user details, logout, change password |
| 📖 | **Documentation** | Link to official ArgoCD docs |

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

### UI vs CLI — When to Use What

| Scenario | Best Choice | Why |
|----------|-------------|-----|
| Daily monitoring | **UI** | Visual health/sync overview at a glance |
| Debugging issues | **UI** | Resource tree + logs + events in one place |
| CI/CD integration | **CLI** | Can be scripted in GitHub Actions/Jenkins |
| Bulk sync | **CLI** | `argocd app sync -l team=backend` syncs all team apps |
| Emergency rollback | **UI** | Fastest click-to-rollback |
| Scripted operations | **CLI** | Automation and repeatability |

### ArgoCD Settings — Complete Overview

| Setting | Purpose | When to Configure |
|---------|---------|-------------------|
| **Repositories** | Connect Git/Helm repos | When adding apps from private repos |
| **Repository Credentials** | Shared credential templates | Many repos under same org |
| **Projects** | Logical grouping + RBAC | Multi-team environments |
| **Clusters** | Register external K8s clusters | Multi-cluster deployments |
| **Certificates** | TLS certs & SSH known hosts | Private Git servers |
| **GnuPG Keys** | GPG keys for commit verification | Compliance environments |
| **Accounts** | Local user accounts | Service accounts, pre-SSO |
| **Appearance** | UI customization (banners) | Environment identification |

### Default vs Custom Projects

| Feature | `default` Project | Custom Project |
|---------|-------------------|----------------|
| **Source Repos** | `*` (ALL) | Specific repos/patterns only |
| **Destinations** | `*` (ALL) | Specific clusters/namespaces |
| **RBAC** | None | Project-level roles per team |
| **Security** | ⚠️ No restrictions | ✅ Principle of least privilege |
| **Use Case** | Quick demos, learning | Production, multi-team |

> ⚠️ **Never use `default` project in production!** Always create custom projects.

### Project Creation Example: `e-commerce`

```bash
argocd proj create e-commerce \
  --description "This is E-Commerce-Project for the GitOps ArgoCD demos" \
  --src "https://github.com/techmahato/e-commerce-*" \
  --dest "https://kubernetes.default.svc,ecommerce-dev" \
  --dest "https://kubernetes.default.svc,ecommerce-staging" \
  --dest "https://kubernetes.default.svc,ecommerce-prod"
```

### Repository Connection

```bash
# Private repo with HTTPS + GitHub PAT
argocd repo add https://github.com/techmahato/e-commerce-config.git \
  --username git --password ghp_xxxxxxxxxxxxx --project e-commerce

# Shared credentials for entire org
argocd repocreds add https://github.com/techmahato/ \
  --username git --password ghp_xxxxxxxxxxxxx
```

> 📝 **For the complete detailed guide** with ASCII diagrams, all UI forms explained, all settings options, project YAML examples, repository types, and 15+ related interview Q&As, refer to the dedicated document at `00_ArgoCD_UI_Explanation/README.md`.

---

## 21. 🎯 Interview Questions & Answers (ArgoCD & GitOps)

> This section covers real interview questions asked by interviewers at top companies for DevOps/SRE/Platform Engineering roles. Organized from Basic → Intermediate → Advanced → Practical/Scenario-Based.

---

### 📗 BASIC LEVEL QUESTIONS

---

**Q1: What is ArgoCD?**

**Answer:** ArgoCD is a declarative, GitOps-based continuous delivery tool for Kubernetes. It is a Kubernetes controller that continuously monitors running applications and compares the live state against the desired state defined in a Git repository. When differences are detected, ArgoCD can automatically or manually sync the cluster to match the Git-defined state. It is a CNCF Graduated project, open source under Apache 2.0 license.

---

**Q2: What is GitOps and how does ArgoCD implement it?**

**Answer:** GitOps is a set of practices where Git is used as the single source of truth for declarative infrastructure and applications. ArgoCD implements GitOps through:
- **Pull-based model:** ArgoCD runs inside the cluster and pulls desired state from Git (every 3 minutes by default)
- **Continuous reconciliation:** Constantly compares live cluster state vs Git
- **Drift detection:** Identifies manual changes made outside Git
- **Auto-healing:** Reverts unauthorized manual changes to match Git
- **Audit trail:** All changes go through Git commits (who, what, when, why)

---

**Q3: What is the difference between ArgoCD and Jenkins?**

**Answer:**

| Aspect | Jenkins | ArgoCD |
|--------|---------|--------|
| **Model** | Push-based (pipeline pushes to cluster) | Pull-based (cluster pulls from Git) |
| **Type** | CI/CD tool (general purpose) | CD tool (Kubernetes-specific) |
| **Credentials** | Needs cluster credentials externally | Runs inside cluster, no external creds |
| **Drift Detection** | None | Continuous |
| **Rollback** | Re-run old pipeline | `git revert` auto-syncs |
| **Language** | Groovy (Jenkinsfile) | YAML (K8s manifests) |
| **State** | Stateful (disk-based) | Stateless (state in K8s CRDs + etcd) |

---

**Q4: What are the main features of ArgoCD?**

**Answer:**
1. GitOps-based automated deployment
2. Multi-cluster management from single instance
3. Support for Helm, Kustomize, Jsonnet, plain YAML
4. Real-time web UI with resource tree visualization
5. RBAC with SSO/OIDC integration
6. Automated sync with self-healing
7. Rollback to any previous revision
8. Health status monitoring per resource
9. Sync waves and hooks for ordered deployments
10. ApplicationSets for templated multi-app/multi-cluster deployments
11. Notifications (Slack, email, webhook)
12. Image Updater for auto-detecting new container images

---

**Q5: What is the difference between Continuous Delivery and Continuous Deployment?**

**Answer:**
- **Continuous Delivery:** Code is always ready to deploy but requires a manual approval/button-click before production deployment.
- **Continuous Deployment:** Every change that passes automated tests is automatically deployed to production without any manual intervention.

In ArgoCD terms:
- Continuous Delivery = Manual Sync (`syncPolicy: {}`)
- Continuous Deployment = Automated Sync (`syncPolicy: automated: {}`)

---

**Q6: What is the difference between Push-based and Pull-based CD?**

**Answer:**
- **Push-based (Jenkins, GitLab CI):** CI pipeline finishes building → pipeline pushes changes to the cluster using kubectl/helm from outside. The pipeline needs cluster credentials.
- **Pull-based (ArgoCD, FluxCD):** An agent inside the cluster watches Git. When Git changes, the agent pulls the new state and applies it. No external tool needs cluster access.

**Security implication:** In push-based, if your CI server is compromised, the attacker has production credentials. In pull-based, CI never touches the cluster directly.

---

**Q7: What is an ArgoCD Application?**

**Answer:** An Application is the core CRD (Custom Resource Definition) in ArgoCD. It defines:
- **Source:** Which Git repo, branch, and path to watch
- **Destination:** Which cluster and namespace to deploy to
- **Sync Policy:** Automatic or manual, prune, self-heal settings

It represents one deployed application (or a set of K8s resources from one Git path).

---

**Q8: What is an ArgoCD Project (AppProject)?**

**Answer:** A Project provides multi-tenancy and access control. It defines:
- Which Git repos are allowed as sources
- Which clusters and namespaces are allowed as destinations
- Which K8s resource types can be deployed
- RBAC roles for team members

The `default` project allows everything. In production, you create specific projects to restrict access per team.

---

### 📘 INTERMEDIATE LEVEL QUESTIONS

---

**Q9: Explain the ArgoCD architecture and its components.**

**Answer:** ArgoCD consists of 7 main components deployed in the `argocd` namespace:

| # | Component | K8s Type | Function |
|---|-----------|----------|----------|
| 1 | **argocd-server** | Deployment | API server — serves UI, REST/gRPC API, handles auth, RBAC, webhooks |
| 2 | **argocd-repo-server** | Deployment | Clones Git repos, renders Helm/Kustomize/Jsonnet, caches manifests |
| 3 | **argocd-application-controller** | StatefulSet | Brain — compares desired vs live state, triggers sync, health checks |
| 4 | **argocd-redis** | Deployment | In-memory cache for repo data, sessions, rate limiting |
| 5 | **argocd-dex-server** | Deployment | SSO/OIDC authentication proxy (GitHub, Google, LDAP login) |
| 6 | **argocd-applicationset-controller** | Deployment | Generates Applications from templates using generators |
| 7 | **argocd-notifications-controller** | Deployment | Sends alerts (Slack, email, webhook) on sync/health changes |

---

**Q10: When you install ArgoCD, how many pods are created? Explain each.**

**Answer:** A standard ArgoCD installation creates **7 pods** (one per component):

```bash
$ kubectl get pods -n argocd
NAME                                                READY   STATUS    ROLE
argocd-server-xxxxxxxxxx-xxxxx                      1/1     Running   API Server & Web UI
argocd-repo-server-xxxxxxxxxx-xxxxx                 1/1     Running   Git clone & manifest generation
argocd-application-controller-0                     1/1     Running   Reconciliation engine (StatefulSet)
argocd-redis-xxxxxxxxxx-xxxxx                       1/1     Running   In-memory cache
argocd-dex-server-xxxxxxxxxx-xxxxx                  1/1     Running   SSO authentication
argocd-applicationset-controller-xxxxxxxxxx-xxxxx   1/1     Running   ApplicationSet templating
argocd-notifications-controller-xxxxxxxxxx-xxxxx    1/1     Running   Alert notifications
```

**Detailed breakdown:**

1. **argocd-server (API Server):**
   - Serves the Web UI (React frontend)
   - Exposes REST API and gRPC API
   - Handles user authentication (local users + SSO via Dex)
   - Enforces RBAC policies
   - Processes GitHub/GitLab webhooks for instant sync triggers
   - Manages Application CRUD operations

2. **argocd-repo-server:**
   - Clones Git repositories (caches locally)
   - Executes `helm template` for Helm charts
   - Runs `kustomize build` for Kustomize overlays
   - Evaluates Jsonnet files
   - Returns generated manifests to the Application Controller
   - Most CPU/memory intensive during large repo operations

3. **argocd-application-controller (StatefulSet):**
   - The CORE brain of ArgoCD
   - Continuously compares desired state (from repo-server) with live state (from K8s API)
   - Detects OutOfSync status
   - Executes sync operations (kubectl apply)
   - Performs health assessment on every resource
   - Triggers auto-healing when drift is detected
   - Deployed as StatefulSet for sharding support at scale

4. **argocd-redis:**
   - Caches repository content (avoids repeated Git clones)
   - Stores user sessions
   - Provides rate limiting
   - Message queue for notifications
   - Speeds up UI responsiveness

5. **argocd-dex-server:**
   - OpenID Connect (OIDC) identity provider
   - Integrates with GitHub, Google, LDAP, SAML, Okta
   - Allows "Login with GitHub" on ArgoCD UI
   - If you only use local admin user, this pod is idle but still runs

6. **argocd-applicationset-controller:**
   - Watches ApplicationSet CRDs
   - Uses generators (Git, List, Cluster, Matrix, Merge) to create Applications
   - Enables "one template → 100 applications" pattern
   - Critical for multi-cluster/multi-env deployments

7. **argocd-notifications-controller:**
   - Watches Application sync/health status changes
   - Sends notifications via configured channels (Slack, email, Teams, webhook)
   - Configurable triggers and templates

---

**Q11: Which pod is responsible for actual deployment of applications?**

**Answer:** The **argocd-application-controller** is responsible for the actual deployment. Here's the flow:

```
1. Application Controller detects app is OutOfSync
2. Controller requests manifests from Repo Server
3. Repo Server returns rendered YAML
4. Controller executes "kubectl apply" (server-side apply) against the target cluster
5. Controller monitors the rollout until pods are healthy
6. Updates the Application status accordingly
```

The controller uses the Kubernetes API directly (it has RBAC permissions to create/update/delete resources). It does NOT shell out to `kubectl` — it uses the K8s Go client library internally.

> **Important distinction:** The argocd-server (API server) handles user requests and UI, but the actual deployment is done by the application-controller.

---

**Q12: What happens when multiple pipelines run at the same time and more pods need to be created?**

**Answer:** This is about ArgoCD scaling under load:

**Scenario:** 50 applications all change at once (e.g., a shared library update triggers many apps).

**What happens internally:**

1. **Repo Server gets overloaded:** Multiple clone/render requests come in simultaneously.
   - Solution: Scale repo-server replicas (HPA) or increase CPU/memory limits
   - ArgoCD has a built-in request queue and parallelism settings

2. **Application Controller processes sequentially by default:**
   - It has configurable `--status-processors` (default: 20) and `--operation-processors` (default: 10)
   - These control how many apps are reconciled/synced in parallel
   - For 500+ apps, enable **controller sharding** — multiple controller replicas each handle a subset

3. **K8s cluster resources:**
   - The target cluster's scheduler creates new pods as demanded by the deployments
   - ArgoCD doesn't manage pod scaling — Kubernetes HPA/VPA handles that
   - ArgoCD just applies the desired manifest; K8s does the actual pod scheduling

**Scaling ArgoCD itself:**

```yaml
# Scale repo-server for heavy repo operations
kubectl scale deployment argocd-repo-server -n argocd --replicas=3

# Increase controller parallelism
# Edit argocd-cmd-params-cm ConfigMap:
data:
  controller.status.processors: "50"
  controller.operation.processors: "25"

# Controller sharding (for 500+ apps)
# Set replicas in the StatefulSet and use --sharding flag
```

---

**Q13: What are Sync Waves and Sync Hooks? When would you use them?**

**Answer:**

**Sync Waves** control the ORDER of resource creation:
- Resources with lower wave numbers are synced first
- Default wave is 0
- Use case: Create namespace (wave 0) → Create secrets (wave 1) → Deploy database (wave 2) → Deploy app (wave 3)

**Sync Hooks** run custom jobs at specific phases:
- **PreSync:** Before any resources are applied (DB migrations, backups)
- **Sync:** During resource application
- **PostSync:** After all resources are healthy (smoke tests, notifications)
- **SyncFail:** When sync fails (cleanup, alerting)

**Real-world example:**
```
Wave -1: Create Namespace
Wave 0:  PreSync Hook → Run database migration Job
Wave 1:  Deploy ConfigMaps and Secrets
Wave 2:  Deploy Database StatefulSet
Wave 3:  Deploy Application Deployment
Wave 4:  PostSync Hook → Run integration test Job
```

---

**Q14: What is the difference between `argocd app sync` and `argocd app refresh`?**

**Answer:**
- **Refresh:** Forces ArgoCD to re-fetch the Git repo and recalculate the diff. Does NOT apply changes. Just updates the comparison (desired vs live).
- **Sync:** Actually APPLIES the desired state to the cluster. Makes live state match Git.

```bash
argocd app refresh my-app    # "Check Git again, tell me what's different"
argocd app sync my-app       # "Apply the Git state to the cluster NOW"
```

---

**Q15: How does ArgoCD handle secrets?**

**Answer:** ArgoCD does NOT have built-in secret management. Common approaches:

| Approach | How It Works |
|----------|-------------|
| **Sealed Secrets** | Encrypt secrets, store encrypted version in Git. Controller decrypts in-cluster. |
| **External Secrets Operator** | References secrets from AWS Secrets Manager/Vault/GCP. ArgoCD syncs the ExternalSecret CRD. |
| **HashiCorp Vault + AVP** | ArgoCD Vault Plugin replaces placeholders in manifests with Vault values at render time. |
| **SOPS** | Mozilla SOPS encrypts YAML values. Decrypted during Kustomize/Helm render. |
| **AWS Secrets Manager** | CSI driver mounts secrets as volumes. ArgoCD deploys the SecretProviderClass. |

> **Best Practice:** Never store plain-text secrets in Git. Use External Secrets Operator or Sealed Secrets.

---

**Q16: What is ApplicationSet? When would you use it?**

**Answer:** ApplicationSet is a controller that generates multiple ArgoCD Applications from a single template using generators.

**Use cases:**
- Deploy the same app to 10 clusters
- Create apps for every directory in a monorepo
- Generate per-team or per-environment applications

**Generators:**
- **List Generator:** Static list of clusters/values
- **Cluster Generator:** Auto-discover registered clusters
- **Git Generator:** Auto-discover directories in a repo
- **Matrix Generator:** Combine two generators (cartesian product)
- **Merge Generator:** Merge results from multiple generators

---

### 📕 ADVANCED LEVEL QUESTIONS

---

**Q17: If we delete an ArgoCD pod and it gets recreated, will the admin password reset? Explain why or why not.**

**Answer:** **NO, the admin password will NOT reset when pods are deleted and recreated.**

**Why?**

The admin password is stored in a Kubernetes **Secret** object (`argocd-initial-admin-secret` for initial password, and `argocd-secret` for the active password hash). Secrets are stored in etcd (Kubernetes' persistent data store), NOT inside the pod.

```
┌─────────────────────────────────────────────────────────────────┐
│                    PASSWORD STORAGE                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Pod (argocd-server)          Secret (argocd-secret)             │
│  ┌───────────────────┐        ┌───────────────────────┐         │
│  │                     │        │ admin.password:       │         │
│  │  STATELESS!        │        │   <bcrypt-hash>       │         │
│  │  No data stored    │◀─reads─│                       │         │
│  │  inside the pod    │        │ admin.passwordMtime:  │         │
│  │                     │        │   2024-01-15T10:00    │         │
│  └───────────────────┘        └───────────────────────┘         │
│         │                              │                          │
│    DELETE POD                    PERSISTS IN ETCD                 │
│         │                        (independent of pods)            │
│         ▼                              │                          │
│  Pod recreated by                      │                          │
│  ReplicaSet/Deployment                 │                          │
│  ┌───────────────────┐                │                          │
│  │                     │◀──still reads─┘                          │
│  │  New pod reads      │                                          │
│  │  SAME Secret        │    ← Password unchanged!                │
│  │                     │                                          │
│  └───────────────────┘                                           │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Technical explanation:**
- Pods are stateless compute units. They don't store persistent data.
- The `argocd-server` Deployment's pod reads the password from the `argocd-secret` Secret at startup.
- When you delete the pod, the Deployment controller recreates it.
- The new pod reads the SAME Secret from etcd → same password.
- Even `kubectl rollout restart deployment argocd-server -n argocd` won't change the password.

**When DOES the password change?**
1. You run `argocd account update-password`
2. You manually patch `argocd-secret` with a new bcrypt hash
3. You delete BOTH `argocd-secret` AND `argocd-initial-admin-secret`, then restart — ArgoCD regenerates a new random password

---

**Q18: Explain ArgoCD architecture with a real-time example from your experience.**

**Answer (Sample answer for interviews):**

"In my previous role, we managed a microservices platform with 120+ services across 3 environments (dev, staging, production) on AWS EKS. Here's how ArgoCD architecture worked in our real setup:

**Our Setup:**
- 1 Management EKS cluster running ArgoCD (managing 3 target clusters)
- GitHub organization with 120+ repos (application code) + 1 GitOps config repo
- ArgoCD managing ~360 Applications (120 services × 3 environments)

**How each component worked in practice:**

1. **API Server (argocd-server):** 
   - Our developers used the ArgoCD UI daily to check deployment status
   - We had GitHub webhooks configured to notify ArgoCD immediately on push (instead of waiting 3-min poll)
   - SSO configured via Dex with GitHub OAuth — devs logged in with their GitHub accounts

2. **Repo Server (argocd-repo-server):**
   - We scaled this to 3 replicas because our Helm charts were complex (10+ subcharts)
   - Rendering 360 apps' Helm templates was CPU-intensive
   - We increased cache expiry to reduce Git clone frequency

3. **Application Controller:**
   - With 360 apps, we enabled sharding (3 replicas)
   - Each controller shard handled ~120 apps
   - Status processors set to 50, operation processors to 25
   - Self-heal enabled on production to prevent kubectl cowboys

4. **Redis:**
   - Critical for performance — without it, every UI page load would trigger Git clones
   - We monitored Redis memory usage and set appropriate limits

5. **Dex:**
   - GitHub SSO let us map GitHub teams to ArgoCD RBAC roles
   - `backend-team` GitHub group → can only sync apps in `team-backend` Project
   - `platform-team` → admin access to all Projects

6. **ApplicationSet Controller:**
   - We used Git Generator to auto-discover new services
   - When a dev created a new service directory in the config repo, ApplicationSet automatically created the ArgoCD Application for all 3 environments
   - This was our 'self-service' — no tickets needed for new service onboarding

7. **Notifications Controller:**
   - Slack alerts on sync failures and degraded health
   - On-call engineer got paged via PagerDuty webhook when production apps went Degraded

**Failure scenario we handled:**
A developer accidentally ran `kubectl scale deployment payment-service --replicas=0` in production at 2 AM. Because self-heal was enabled, ArgoCD detected the drift within 30 seconds and scaled it back to the Git-defined 5 replicas. Zero customer impact. No human intervention needed."

---

**Q19: How do you handle multi-cluster deployments with ArgoCD?**

**Answer:**

**Approach 1: Hub-Spoke Model (Recommended)**
- One ArgoCD instance in a management cluster
- Register target clusters via `argocd cluster add`
- ApplicationSets with Cluster Generator to deploy across all clusters

```bash
# Register a target cluster
argocd cluster add eks-production-cluster --name production

# ArgoCD stores cluster credentials as K8s Secrets
kubectl get secrets -n argocd -l argocd.argoproj.io/secret-type=cluster
```

**Approach 2: ArgoCD per Cluster**
- Each cluster runs its own ArgoCD
- More isolated, but harder to manage centrally
- Used when strict network isolation is required

**Best Practice:** Hub-spoke for 90% of cases. One ArgoCD managing up to 100 clusters works well with proper resource allocation.

---

**Q20: What is the difference between `prune: true` and `selfHeal: true`?**

**Answer:**

| Feature | `prune: true` | `selfHeal: true` |
|---------|---------------|-------------------|
| **What it does** | Deletes resources that exist in cluster but NOT in Git | Reverts manual changes to resources that ARE in Git |
| **Direction** | Removes extra resources | Restores existing resources |
| **Example** | You remove a ConfigMap from Git → ArgoCD deletes it from cluster | Someone scales deployment from 3 to 1 → ArgoCD scales back to 3 |
| **Risk** | Can accidentally delete if you remove a file from Git by mistake | Can undo intentional emergency changes |

**Both together provide full GitOps enforcement:**
```yaml
syncPolicy:
  automated:
    prune: true      # Delete what's not in Git
    selfHeal: true   # Revert what's been changed from Git
```

---

**Q21: How does ArgoCD detect drift? What's the reconciliation loop?**

**Answer:**

ArgoCD's Application Controller runs a continuous reconciliation loop:

1. **Every 3 minutes** (default, configurable via `timeout.reconciliation` in argocd-cm):
   - Controller queries Repo Server for desired manifests
   - Controller queries K8s API for live state
   - Performs a 3-way diff (desired vs live vs last-applied)
   
2. **On webhook trigger** (if configured):
   - GitHub/GitLab sends a webhook to ArgoCD on push
   - ArgoCD immediately refreshes the affected Application

3. **Diff algorithm:**
   - Compares every field in every resource
   - Uses `ignoreDifferences` config to skip dynamic fields (e.g., `.status`, `.metadata.resourceVersion`)
   - Uses normalized JSON comparison

4. **If drift detected:**
   - Status changes to `OutOfSync`
   - If auto-sync enabled → applies desired state
   - If manual → waits for user action
   - Notifications sent if configured

---

**Q22: What happens if Git is unavailable? Does ArgoCD still work?**

**Answer:**
- **Existing applications continue running.** ArgoCD doesn't affect running workloads if Git is down.
- **Reconciliation pauses.** ArgoCD can't fetch new desired state, so it marks apps with a "refresh failed" error.
- **No new syncs** can happen because ArgoCD can't read the desired state.
- **Redis cache helps temporarily** — if the repo was recently cached, ArgoCD may still show correct diff.
- **When Git comes back,** ArgoCD automatically resumes reconciliation within the next poll cycle.

> ArgoCD is designed to be resilient to Git outages. It uses an eventual consistency model — it will catch up once Git is available again.

---

**Q23: How do you handle rollbacks in ArgoCD?**

**Answer:**

**Method 1: Git Revert (Preferred — maintains history)**
```bash
git revert <bad-commit>
git push
# ArgoCD auto-syncs to the previous state
```

**Method 2: ArgoCD Rollback (Quick, but temporary if auto-sync is on)**
```bash
argocd app rollback my-app <revision-number>
```

**Method 3: Pin to a specific Git commit**
```yaml
source:
  targetRevision: "abc123def"  # Pin to exact commit SHA
```

**Important:** If `automated sync` is enabled and you rollback via CLI/UI, ArgoCD will re-sync to the latest Git state on the next reconciliation. For permanent rollback, ALWAYS use `git revert`.

---

**Q24: What is the App of Apps pattern?**

**Answer:** A pattern where one "parent" ArgoCD Application manages other ArgoCD Applications as resources.

```
Root Application (app-of-apps)
├── Application: frontend
├── Application: backend
├── Application: database
├── Application: monitoring
└── Application: ingress
```

**Benefits:**
- Bootstrap entire environments with a single Application
- Hierarchical management (one sync → deploys everything)
- Team-level grouping

**Example root app:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root-app
spec:
  source:
    repoURL: https://github.com/org/gitops-config.git
    path: apps/          # This folder contains Application YAML files
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd    # Applications are in argocd namespace
```

---

**Q25: How do you secure ArgoCD in production?**

**Answer:**

| Security Layer | Implementation |
|---------------|----------------|
| **Authentication** | SSO via OIDC/SAML (disable local admin in production) |
| **Authorization** | RBAC policies per project/team |
| **Network** | TLS termination, network policies, restrict API access |
| **Secrets** | External Secrets Operator / Sealed Secrets (never plain in Git) |
| **Git Access** | Deploy keys (read-only) per repo, not personal tokens |
| **Audit** | Enable audit logging, integrate with SIEM |
| **Sync Windows** | Restrict deployments to business hours only |
| **Resource Quotas** | Limit what each Project can deploy |
| **Image Allowlist** | Restrict which container registries are allowed |
| **Cluster Access** | Least-privilege ServiceAccount for target clusters |

---

### 📙 SCENARIO-BASED / PRACTICAL QUESTIONS

---

**Q26: You deployed ArgoCD and noticed the application shows "OutOfSync" but nothing has changed in Git. What could be the reason?**

**Answer:** Common causes for false OutOfSync:

1. **Dynamic fields:** Kubernetes adds fields like `.metadata.resourceVersion`, `.metadata.uid`, `.status` that differ from Git. Fix: Use `ignoreDifferences` in the Application spec.

2. **Default values:** K8s API server adds default values not in your YAML (e.g., `spec.restartPolicy: Always`). Fix: Explicitly define all important fields or use `ignoreDifferences`.

3. **Mutating webhooks:** Admission controllers (like Istio sidecar injector) modify pod specs. Fix: Ignore injected sidecar fields.

4. **HPA conflicts:** HPA changes `.spec.replicas` but Git has a fixed number. Fix: Remove `replicas` from Git manifest or ignore it:
   ```yaml
   ignoreDifferences:
     - group: apps
       kind: Deployment
       jsonPointers:
         - /spec/replicas
   ```

5. **Last-applied-configuration annotation:** Old `kubectl apply` annotations causing diff. Fix: Use `ServerSideApply=true` sync option.

---

**Q27: Your ArgoCD application is stuck in "Progressing" state. How do you debug?**

**Answer:**

```bash
# Step 1: Check application details
argocd app get my-app

# Step 2: Check for resource-level issues
argocd app resources my-app

# Step 3: Look at events
kubectl describe deployment <name> -n <namespace>

# Step 4: Check pod status
kubectl get pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>

# Step 5: Check for image pull issues
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# Step 6: Check ArgoCD controller logs
kubectl logs -n argocd deployment/argocd-application-controller --tail=100

# Step 7: Check resource health
argocd app get my-app --show-operation
```

Common causes:
- Image not found (wrong tag or private registry auth)
- Insufficient resources (CPU/memory limits exceeded, no node capacity)
- Readiness probe failing
- PVC not binding (storage class issue)
- Init containers stuck

---

**Q28: How would you migrate from Jenkins-based CD to ArgoCD in a running production environment?**

**Answer (step-by-step approach):**

1. **Parallel run:** Install ArgoCD alongside Jenkins. Don't disable Jenkins yet.
2. **Start with non-production:** Set up ArgoCD for dev/staging first.
3. **Create GitOps repo:** Move K8s manifests from Jenkins pipeline into a dedicated Git config repo.
4. **Manual sync first:** Configure ArgoCD apps with manual sync policy initially.
5. **Validate:** Compare Jenkins deployments vs ArgoCD deployments. Ensure identical results.
6. **Enable auto-sync for staging:** Once confident, enable automated sync for staging.
7. **Production cutover:** After 2-4 weeks of staging success, move production to ArgoCD.
8. **Remove Jenkins deploy stages:** Keep Jenkins for CI (build/test), remove CD steps.
9. **Monitor:** Watch for drift detection catching issues Jenkins missed.
10. **Decommission:** After all environments are on ArgoCD, remove Jenkins CD plugins.

**Key principle:** Never do a big-bang migration. Gradual, environment-by-environment.

---

**Q29: A developer accidentally deleted a namespace in production. How does ArgoCD help recover?**

**Answer:**

**With ArgoCD (GitOps approach):**
1. ArgoCD detects the namespace and all its resources are "Missing"
2. If `selfHeal: true` and `CreateNamespace=true` in sync options:
   - ArgoCD automatically recreates the namespace
   - Recreates all resources defined in Git
   - Full recovery in minutes without human intervention
3. If manual sync: Click "Sync" in UI → everything rebuilds from Git

**Recovery timeline:**
```
00:00  Namespace deleted accidentally
00:03  ArgoCD reconciliation detects all resources are Missing
00:03  Auto-sync triggers (if enabled)
00:04  Namespace recreated
00:05  All deployments, services, configmaps recreated
00:07  Pods scheduled and running
00:10  Application healthy again ✅
```

**Without GitOps:**
- Scramble to find what was in the namespace
- Search through old kubectl commands, CI logs, chat messages
- Manually recreate each resource one by one
- Recovery takes hours, may be incomplete

---

**Q30: How do you implement a canary deployment with ArgoCD?**

**Answer:** ArgoCD alone does basic deployments. For advanced strategies (canary, blue-green), use **Argo Rollouts**:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: my-app
spec:
  replicas: 10
  strategy:
    canary:
      steps:
        - setWeight: 10      # Send 10% traffic to new version
        - pause: {duration: 5m}   # Wait 5 minutes
        - setWeight: 30      # Increase to 30%
        - pause: {duration: 5m}
        - setWeight: 50      # 50%
        - pause: {duration: 10m}
        - setWeight: 100     # Full rollout
      canaryService: my-app-canary
      stableService: my-app-stable
```

ArgoCD manages the Rollout resource via GitOps. Argo Rollouts controller handles the progressive traffic shifting.

---

**Q31: Your company has 50 microservices. How do you structure the Git repository for ArgoCD?**

**Answer:** Two recommended approaches:

**Approach 1: Monorepo (Config repo)**
```
gitops-config/
├── apps/
│   ├── service-a/
│   │   ├── base/
│   │   │   ├── deployment.yaml
│   │   │   ├── service.yaml
│   │   │   └── kustomization.yaml
│   │   └── overlays/
│   │       ├── dev/
│   │       ├── staging/
│   │       └── production/
│   ├── service-b/
│   └── service-c/
├── infrastructure/
│   ├── monitoring/
│   ├── ingress/
│   └── cert-manager/
└── applicationsets/
    └── all-services.yaml    # One ApplicationSet generates all apps
```

**Approach 2: Multi-repo**
- Each team has their own config repo
- ArgoCD Projects restrict which repos each team can use
- Better for large orgs with strict team boundaries

**Best Practice:** Start with monorepo. Split into multi-repo only when team size requires it.

---

**Q32: What is the difference between `helm install` and deploying Helm charts through ArgoCD?**

**Answer:**

| Aspect | `helm install` (direct) | ArgoCD + Helm |
|--------|------------------------|---------------|
| **State management** | Helm stores release in K8s Secret | ArgoCD manages state via CRDs |
| **Drift detection** | None (Helm doesn't watch) | Continuous reconciliation |
| **Rollback** | `helm rollback` (from release history) | `git revert` (from Git history) |
| **Values management** | CLI flags or values file | values.yaml in Git (version controlled) |
| **Visibility** | `helm list` only | Full UI visualization |
| **Team collaboration** | SSH + run command | Git PR → review → merge → auto-deploy |
| **Audit trail** | Helm release history (limited) | Full Git commit history |

ArgoCD runs `helm template` (render only) and then applies the output. It does NOT use `helm install/upgrade`. This means Helm hooks and lifecycle management work differently — ArgoCD uses its own sync waves and hooks instead.

---

**Q33: How do you monitor ArgoCD itself in production?**

**Answer:**

ArgoCD exposes Prometheus metrics on port 8082 (controller) and 8083 (server).

**Key metrics to monitor:**

| Metric | Alert Threshold | Meaning |
|--------|----------------|---------|
| `argocd_app_info{health_status="Degraded"}` | > 0 | Unhealthy apps |
| `argocd_app_sync_total{phase="Failed"}` | Increasing | Sync failures |
| `argocd_app_reconcile_duration_seconds` | > 60s | Slow reconciliation |
| `argocd_git_request_duration_seconds` | > 30s | Slow Git operations |
| `argocd_redis_request_duration` | > 5s | Redis performance issues |
| `argocd_cluster_api_resource_objects` | Sudden drop | Cluster connectivity issue |

**Setup:**
```bash
# Install Prometheus ServiceMonitor for ArgoCD
kubectl apply -f argocd-service-monitors.yaml

# Import ArgoCD Grafana dashboard (ID: 14584)
```

---

**Q34: What is the `argocd-cm` ConfigMap and what can you configure in it?**

**Answer:** `argocd-cm` is the main configuration ConfigMap for ArgoCD.

Key configurations:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  # Git repository poll interval
  timeout.reconciliation: "180"    # seconds (default: 180 = 3 min)
  
  # URL for ArgoCD server (used in notifications/UI links)
  url: "https://argocd.company.com"
  
  # Enable admin user (disable in production with SSO)
  admin.enabled: "true"
  
  # OIDC/SSO configuration
  oidc.config: |
    name: GitHub
    issuer: https://dex.argocd.company.com
    clientID: xxxxxxxx
    clientSecret: $dex.github.clientSecret
  
  # Resource exclusions (don't track these)
  resource.exclusions: |
    - apiGroups: [""]
      kinds: ["Event"]
      clusters: ["*"]
  
  # Custom health checks
  resource.customizations.health.networking.k8s.io_Ingress: |
    hs = {}
    hs.status = "Healthy"
    return hs
```

---

**Q35: How does ArgoCD handle Helm value files from different environments?**

**Answer:**

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app-production
spec:
  source:
    repoURL: https://github.com/org/helm-charts.git
    path: charts/my-app
    targetRevision: main
    helm:
      # Multiple values files (applied in order, last wins)
      valueFiles:
        - values.yaml              # Base values
        - values-production.yaml   # Production overrides
      
      # Inline parameter overrides
      parameters:
        - name: image.tag
          value: "v2.3.1"
        - name: replicas
          value: "5"
      
      # Or reference values from another repo
      # valuesObject for inline YAML values
```

**Multi-environment with Kustomize (alternative):**
```
my-app/
├── base/
│   ├── deployment.yaml
│   └── kustomization.yaml
└── overlays/
    ├── dev/
    │   └── kustomization.yaml       # replicas: 1, image: dev
    ├── staging/
    │   └── kustomization.yaml       # replicas: 2, image: staging
    └── production/
        └── kustomization.yaml       # replicas: 5, image: production
```

---

**Q36: What are ArgoCD Resource Hooks and when would you use them?**

**Answer:** Resource Hooks are Kubernetes resources (usually Jobs) that run at specific sync phases.

**Practical use cases:**

| Phase | Use Case | Example |
|-------|----------|---------|
| **PreSync** | Database migration before deploying app | `python manage.py migrate` |
| **PreSync** | Backup before risky deployment | `pg_dump > backup.sql` |
| **PostSync** | Run smoke tests after deployment | `curl health-endpoint` |
| **PostSync** | Notify team on successful deploy | Send Slack message |
| **SyncFail** | Clean up partial deployment | Delete temp resources |
| **SyncFail** | Alert on-call team | PagerDuty webhook |

**Hook delete policies:**
- `HookSucceeded`: Delete the Job after it succeeds
- `HookFailed`: Delete the Job after it fails
- `BeforeHookCreation`: Delete previous hook before creating new one

---

**Q37: Explain the difference between ArgoCD Application health vs sync status.**

**Answer:**

| Aspect | Sync Status | Health Status |
|--------|-------------|---------------|
| **What it checks** | Does live state match Git? | Are resources actually working? |
| **Values** | Synced, OutOfSync, Unknown | Healthy, Degraded, Progressing, Missing, Suspended |
| **Example: Synced + Degraded** | Git says 3 replicas, cluster has 3 replicas (Synced) but 2 are CrashLooping (Degraded) |
| **Example: OutOfSync + Healthy** | Someone scaled to 5 (OutOfSync from Git's 3) but all 5 pods are running fine (Healthy) |

**They are independent:**
- An app can be `Synced + Degraded` (matches Git but not working)
- An app can be `OutOfSync + Healthy` (doesn't match Git but is working)
- Ideal state: `Synced + Healthy` ✅

---

**Q38: How do you handle database migrations with ArgoCD?**

**Answer:** Use PreSync hooks with Jobs:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
  annotations:
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: BeforeHookCreation
    argocd.argoproj.io/sync-wave: "-1"    # Run before everything
spec:
  template:
    spec:
      containers:
      - name: migrate
        image: myapp:v2.0
        command: ["python", "manage.py", "migrate", "--no-input"]
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: url
      restartPolicy: Never
  backoffLimit: 3
```

**Flow:**
1. Developer merges PR with new migration + new code
2. ArgoCD detects change
3. PreSync: Migration Job runs first
4. If migration succeeds → Sync: Deploy new application version
5. If migration fails → Sync aborted, app stays on old version

---

**Q39: What is controller sharding and when do you need it?**

**Answer:**

**Controller sharding** allows running multiple Application Controller replicas, each managing a subset of applications.

**When needed:** When you have 500+ Applications and single controller becomes a bottleneck.

**How it works:**
- Each Application is assigned a shard based on its name hash
- Each controller replica only processes applications in its shard
- Uses Redis for coordination

**Configuration:**
```yaml
# argocd-application-controller StatefulSet
spec:
  replicas: 3    # 3 shards
  template:
    spec:
      containers:
      - name: argocd-application-controller
        env:
        - name: ARGOCD_CONTROLLER_REPLICAS
          value: "3"
```

**Scaling guidelines:**
| Applications | Controller Replicas | Status Processors | Operation Processors |
|-------------|--------------------|--------------------|---------------------|
| < 100 | 1 | 20 (default) | 10 (default) |
| 100-500 | 1-2 | 50 | 25 |
| 500-1000 | 3-5 | 100 | 50 |
| 1000+ | 5-10 | 200 | 100 |

---

**Q40: What happens to ArgoCD-managed resources when you delete the ArgoCD Application?**

**Answer:** It depends on the **finalizer** and **cascade delete** setting:

**With finalizer (default):**
```yaml
metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io
```
→ Deleting the Application also **deletes all managed K8s resources** (cascading delete).

**Without finalizer:**
```yaml
metadata:
  finalizers: []    # or remove the finalizer
```
→ Deleting the Application leaves K8s resources running (orphaned).

**CLI options:**
```bash
# Delete app AND all its resources (cascade)
argocd app delete my-app --cascade

# Delete app but KEEP resources running (non-cascade)
argocd app delete my-app --cascade=false
```

> **Production tip:** In production, always double-check cascade settings. Accidentally deleting an Application with cascade=true will delete the running workloads!

---

### 📓 RAPID-FIRE QUESTIONS (Quick Answers)

---

| # | Question | Answer |
|---|----------|--------|
| 41 | What port does ArgoCD UI run on? | 443 (HTTPS) by default. We port-forward to 8080 for convenience. |
| 42 | What is the default sync interval? | 3 minutes (180 seconds), configurable in `argocd-cm` |
| 43 | Can ArgoCD deploy to non-Kubernetes targets? | No. ArgoCD is Kubernetes-only. For VMs, use Ansible/Terraform. |
| 44 | What is the `default` project in ArgoCD? | A pre-created project that allows all sources, all destinations. Restrict in production. |
| 45 | How does ArgoCD compare desired vs live state? | Uses a 3-way diff: desired (Git) vs live (cluster) vs last-applied annotation |
| 46 | Can ArgoCD manage itself? | Yes! "Argo manages Argo" pattern — ArgoCD application that syncs its own installation. |
| 47 | What is `targetRevision` in Application spec? | The Git branch, tag, or commit SHA to track. `HEAD` means latest on default branch. |
| 48 | What happens if two Applications deploy to the same namespace? | Both work fine unless they manage the same resource (conflict). Use `FailOnSharedResource` option. |
| 49 | Can you sync specific resources only? | Yes! `argocd app sync my-app --resource apps:Deployment:my-deploy` |
| 50 | What is the health check interval? | Same as reconciliation interval (3 min default). Health is assessed during each reconciliation. |
| 51 | Does ArgoCD support Terraform? | Not natively. Use Crossplane or Terraform Controller CRDs which ArgoCD can manage. |
| 52 | What is `replace` vs `apply` in sync? | Apply = patch existing. Replace = delete and recreate. Use replace for immutable fields. |
| 53 | How to temporarily disable auto-sync? | `argocd app set my-app --sync-policy none` or remove automated from spec |
| 54 | What is Sync Window? | Time-based restriction: "only allow sync Mon-Fri 9am-5pm". Protects production off-hours. |
| 55 | How to force sync even if app is synced? | `argocd app sync my-app --force` or use `Replace=true` sync option |
| 56 | What K8s version does ArgoCD support? | Officially supports N-2 (current and two previous minor versions) |
| 57 | Can ArgoCD deploy CRDs? | Yes. CRDs sync first by default (built-in wave ordering). |
| 58 | What is `ignoreDifferences`? | Tells ArgoCD to skip certain fields during diff (e.g., fields managed by HPA or mutating webhooks) |
| 59 | How to see what ArgoCD would deploy without deploying? | `argocd app diff my-app` shows the diff. Or use `--dry-run` with sync. |
| 60 | What is the maximum number of apps ArgoCD can manage? | No hard limit. Tested up to 10,000+ with proper sharding and resource allocation. |

---

### 🏆 BONUS: Top 5 Questions Interviewers Love to Ask

1. **"Walk me through what happens from git push to production deployment with ArgoCD."**
   - Dev pushes code → CI builds image → CI updates image tag in config repo → ArgoCD detects change → ArgoCD syncs → New pods rolled out → Health check passes → Done.

2. **"How would you handle a production incident at 3 AM where ArgoCD keeps reverting a hotfix?"**
   - Disable auto-sync for that app: `argocd app set my-app --sync-policy none`
   - Apply the hotfix manually
   - After incident: commit the fix to Git, re-enable auto-sync

3. **"Your ArgoCD repo-server is consuming 8GB RAM. What do you do?"**
   - Check which repos are large (repo-server caches entire repos)
   - Enable shallow clones: `GIT_CLONE_DEPTH=1`
   - Increase replicas to distribute load
   - Check if Helm charts have large dependencies
   - Reduce `reposerver.parallelism.limit`

4. **"How do you implement environment promotion (dev → staging → prod) with ArgoCD?"**
   - Kustomize overlays per environment
   - PR from dev overlay to staging overlay
   - Automated sync in dev, manual/approval in staging, sync windows in prod
   - Or: use branch-per-environment strategy with PRs for promotion

5. **"Explain a situation where GitOps (ArgoCD) is NOT the right choice."**
   - Non-Kubernetes workloads (VMs, bare-metal)
   - Batch processing systems that need imperative control
   - Very small teams with 1-2 services (overhead not justified)
   - Legacy systems that can't be described declaratively
   - Systems requiring complex orchestration Jenkins is better at (approval gates across multiple systems)

---

> 💡 **Interview Tip:** Always relate answers to your real experience. Interviewers value practical examples over textbook definitions. Use the STAR method (Situation, Task, Action, Result) for scenario questions.

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

> 🙏 **If this helped you crack your interview, please Star ⭐ the repo and Subscribe 🔔 to [TECH MAHATO on YouTube](https://www.youtube.com/techmahato)!**
>
> 💡 **Next:** Move to `03_setup_installation` to set up ArgoCD hands-on!
