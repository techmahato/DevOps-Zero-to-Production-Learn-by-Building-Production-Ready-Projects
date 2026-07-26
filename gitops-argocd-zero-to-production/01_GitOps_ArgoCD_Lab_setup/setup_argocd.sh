#!/bin/bash
#╔══════════════════════════════════════════════════════════════════════════════╗
#║                                                                              ║
#║            ████████╗███████╗ ██████╗██╗  ██╗                                ║
#║            ╚══██╔══╝██╔════╝██╔════╝██║  ██║                                ║
#║               ██║   █████╗  ██║     ███████║                                ║
#║               ██║   ██╔══╝  ██║     ██╔══██║                                ║
#║               ██║   ███████╗╚██████╗██║  ██║                                ║
#║               ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝                              ║
#║                                                                              ║
#║       ███╗   ███╗ █████╗ ██╗  ██╗ █████╗ ████████╗ ██████╗                 ║
#║       ████╗ ████║██╔══██╗██║  ██║██╔══██╗╚══██╔══╝██╔═══██╗                ║
#║       ██╔████╔██║███████║███████║███████║   ██║   ██║   ██║                ║
#║       ██║╚██╔╝██║██╔══██║██╔══██║██╔══██║   ██║   ██║   ██║                ║
#║       ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██║   ██║   ╚██████╔╝               ║
#║       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝                ║
#║                                                                              ║
#║          🚀 ArgoCD Production-Ready Setup Script                            ║
#║          📺 YouTube: youtube.com/techmahato                                 ║
#║          📝 Medium:  medium.com/@techmahato                                 ║
#║          💼 LinkedIn: linkedin.com/in/arbindmahato                          ║
#║          🌐 Website: techmahato.com                                         ║
#║                                                                              ║
#╚══════════════════════════════════════════════════════════════════════════════╝

set -e

# ═══════════════════════════════════════════════════════════════
# COLOR DEFINITIONS
# ═══════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════════
# CONFIGURABLE VARIABLES
# ═══════════════════════════════════════════════════════════════
CLUSTER_NAME="argocd-cluster"
KIND_CONFIG="kind-config.yaml"
NAMESPACE="argocd"
KIND_VERSION="v1.33.1"
ARGOCD_PORT=8080

# ═══════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║   ████████╗███████╗ ██████╗██╗  ██╗                             ║"
    echo "║   ╚══██╔══╝██╔════╝██╔════╝██║  ██║                             ║"
    echo "║      ██║   █████╗  ██║     ███████║                             ║"
    echo "║      ██║   ██╔══╝  ██║     ██╔══██║                             ║"
    echo "║      ██║   ███████╗╚██████╗██║  ██║                             ║"
    echo "║      ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝                            ║"
    echo "║                                                                  ║"
    echo "║   ███╗   ███╗ █████╗ ██╗  ██╗ █████╗ ████████╗ ██████╗         ║"
    echo "║   ████╗ ████║██╔══██╗██║  ██║██╔══██╗╚══██╔══╝██╔═══██╗        ║"
    echo "║   ██╔████╔██║███████║███████║███████║   ██║   ██║   ██║        ║"
    echo "║   ██║╚██╔╝██║██╔══██║██╔══██║██╔══██║   ██║   ██║   ██║        ║"
    echo "║   ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██║   ██║   ╚██████╔╝       ║"
    echo "║   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝        ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║   🚀 ArgoCD Production-Ready Setup Script v2.0                  ║"
    echo "║                                                                  ║"
    echo "║   👨‍💻 Author : Arbind Kr. Mahato (TECH MAHATO)                   ║"
    echo "║   🏢 Role   : Cloud & DevOps Engineer                           ║"
    echo "║   🏆 Certs  : AWS Certified | CKA | CKAD                        ║"
    echo "║   🌍 Community: AWS Community Builder                            ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║   📺 YouTube  : youtube.com/techmahato                          ║"
    echo "║   📝 Medium   : medium.com/@techmahato                          ║"
    echo "║   💼 LinkedIn : linkedin.com/in/arbindmahato                    ║"
    echo "║   🌐 Website  : techmahato.com                                  ║"
    echo "║   🐙 GitHub   : github.com/techmahato                           ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║   📚 Learn DevOps from Zero to Production!                      ║"
    echo "║   🎯 10+ Years in IT | Empowering Engineers Worldwide           ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo ""
    echo -e "${MAGENTA}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${MAGENTA}│${BOLD}${WHITE}  $1${NC}"
    echo -e "${MAGENTA}└──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}  ▶ ${WHITE}$1${NC}"
}

print_info() {
    echo -e "${BLUE}  ℹ ${DIM}$1${NC}"
}

print_success() {
    echo -e "${GREEN}  ✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}  ⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}  ❌ $1${NC}"
}

print_separator() {
    echo -e "${DIM}  ─────────────────────────────────────────────────────────${NC}"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "${CYAN}  %c ${NC}Working...  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
    done
    printf "                          \r"
}

# ═══════════════════════════════════════════════════════════════
# PREREQUISITE CHECK FUNCTIONS
# ═══════════════════════════════════════════════════════════════
check_prerequisites() {
    print_section "🔍 STEP 0: Checking Prerequisites"

    local all_ok=true

    # Check Docker
    if command -v docker &> /dev/null; then
        print_success "Docker       : $(docker --version | awk '{print $3}' | tr -d ',')"
    else
        print_error "Docker is NOT installed!"
        print_info "Install: sudo apt install docker.io -y"
        all_ok=false
    fi

    # Check Kind
    if command -v kind &> /dev/null; then
        print_success "Kind         : $(kind version | awk '{print $2}')"
    else
        print_error "Kind is NOT installed!"
        print_info "Install: https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
        all_ok=false
    fi

    # Check kubectl
    if command -v kubectl &> /dev/null; then
        print_success "kubectl      : $(kubectl version --client --short 2>/dev/null || kubectl version --client -o json 2>/dev/null | grep gitVersion | awk -F'"' '{print $4}')"
    else
        print_error "kubectl is NOT installed!"
        print_info "Install: https://kubernetes.io/docs/tasks/tools/"
        all_ok=false
    fi

    # Check Helm
    if command -v helm &> /dev/null; then
        print_success "Helm         : $(helm version --short 2>/dev/null)"
    else
        print_warning "Helm is NOT installed (needed only for Helm-based install)"
        print_info "Install: https://helm.sh/docs/intro/install/"
    fi

    print_separator

    if [ "$all_ok" = false ]; then
        print_error "Some prerequisites are missing. Please install them first."
        print_info "Run this script again after installing the missing tools."
        exit 1
    fi

    print_success "All prerequisites satisfied! Continuing..."
}

# ═══════════════════════════════════════════════════════════════
# STEP 1: CREATE KIND CLUSTER
# ═══════════════════════════════════════════════════════════════
create_kind_cluster() {
    print_section "📦 STEP 1: Creating Kind Kubernetes Cluster"

    # Auto-detect EC2 Private IP
    PRIVATE_IP=$(hostname -I | awk '{print $1}')
    print_info "Auto-detected Private IP: ${PRIVATE_IP}"
    echo ""

    read -p "  🔧 Use this IP for apiServerAddress? [Y/n]: " confirm_ip
    if [[ "$confirm_ip" =~ ^[Nn]$ ]]; then
        read -p "  🔧 Enter your EC2 Private IP: " PRIVATE_IP
    fi

    print_step "Generating Kind cluster config..."

    cat > $KIND_CONFIG <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "${PRIVATE_IP}"
  apiServerPort: 33893
nodes:
  - role: control-plane
    image: kindest/node:${KIND_VERSION}
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
      - containerPort: 30443
        hostPort: 30443
        protocol: TCP
  - role: worker
    image: kindest/node:${KIND_VERSION}
  - role: worker
    image: kindest/node:${KIND_VERSION}
EOF

    print_success "Kind config generated: ${KIND_CONFIG}"
    print_separator

    # Create Cluster
    if kind get clusters 2>/dev/null | grep -q "$CLUSTER_NAME"; then
        print_warning "Cluster '${CLUSTER_NAME}' already exists. Skipping creation."
    else
        print_step "Creating Kind cluster '${CLUSTER_NAME}' (this may take 2-3 mins)..."
        echo ""
        kind create cluster --name $CLUSTER_NAME --config $KIND_CONFIG
    fi

    print_separator
    print_success "Kind cluster is ready!"
    echo ""
    kubectl cluster-info
    echo ""
    kubectl get nodes
}

# ═══════════════════════════════════════════════════════════════
# STEP 2: INSTALL ARGOCD
# ═══════════════════════════════════════════════════════════════
install_argocd_helm() {
    print_step "Installing ArgoCD using Helm (Production-Grade)..."
    echo ""

    helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
    helm repo update

    print_step "Deploying ArgoCD Helm chart..."
    helm upgrade --install argocd argo/argo-cd \
        -n $NAMESPACE \
        --set server.service.type=ClusterIP \
        --set server.extraArgs[0]="--insecure" \
        --wait --timeout 300s

    print_success "ArgoCD installed via Helm!"
}

install_argocd_manifests() {
    print_step "Installing ArgoCD using official manifests..."
    echo ""

    kubectl apply -n $NAMESPACE \
        -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    print_step "Waiting for ArgoCD server to be ready..."
    kubectl wait --for=condition=Available deployment/argocd-server \
        -n $NAMESPACE --timeout=300s || true

    print_success "ArgoCD installed via manifests!"
}

choose_install_method() {
    print_section "🚀 STEP 2: Install ArgoCD"

    # Create namespace
    kubectl create namespace $NAMESPACE 2>/dev/null || print_info "Namespace '${NAMESPACE}' already exists."
    echo ""

    echo -e "${WHITE}  ┌─────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │  Choose ArgoCD Installation Method:             │${NC}"
    echo -e "${WHITE}  │                                                 │${NC}"
    echo -e "${WHITE}  │  ${GREEN}[1]${WHITE} Helm Chart ${DIM}(Production/Customizable)${WHITE}      │${NC}"
    echo -e "${WHITE}  │  ${GREEN}[2]${WHITE} Official Manifests ${DIM}(Quick Demo/Lab)${WHITE}      │${NC}"
    echo -e "${WHITE}  │                                                 │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "  🔧 Enter your choice [1/2]: " install_choice

    case $install_choice in
        1) install_argocd_helm ;;
        2) install_argocd_manifests ;;
        *)
            print_error "Invalid choice! Defaulting to Manifests method..."
            install_argocd_manifests
            ;;
    esac

    print_separator
    echo ""
    print_step "ArgoCD Pods Status:"
    kubectl get pods -n $NAMESPACE
    echo ""
    print_step "ArgoCD Services:"
    kubectl get svc -n $NAMESPACE
}

# ═══════════════════════════════════════════════════════════════
# STEP 3: INSTALL ARGOCD CLI
# ═══════════════════════════════════════════════════════════════
install_argocd_cli() {
    print_section "🔧 STEP 3: Installing ArgoCD CLI"

    if command -v argocd &> /dev/null; then
        print_success "ArgoCD CLI already installed: $(argocd version --client --short 2>/dev/null || echo 'installed')"
    else
        print_step "Downloading ArgoCD CLI..."
        curl -sSL -o argocd-linux-amd64 \
            https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
        sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
        rm -f argocd-linux-amd64
        print_success "ArgoCD CLI installed successfully!"
    fi

    argocd version --client 2>/dev/null || true
}

# ═══════════════════════════════════════════════════════════════
# STEP 4: ACCESS & CREDENTIALS
# ═══════════════════════════════════════════════════════════════
setup_access() {
    print_section "🔐 STEP 4: Access Credentials & Port Forwarding"

    print_step "Fetching ArgoCD admin password..."
    echo ""

    # Wait for the secret to be available
    for i in {1..30}; do
        if kubectl get secret argocd-initial-admin-secret -n $NAMESPACE &>/dev/null; then
            break
        fi
        sleep 2
    done

    PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n $NAMESPACE \
        -o jsonpath="{.data.password}" 2>/dev/null | base64 -d)

    if [ -z "$PASSWORD" ]; then
        print_warning "Password not yet available. ArgoCD may still be initializing."
        print_info "Run later: kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath=\"{.data.password}\" | base64 -d"
    else
        PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "<YOUR_PUBLIC_IP>")

        echo -e "${CYAN}  ┌─────────────────────────────────────────────────────────┐${NC}"
        echo -e "${CYAN}  │          🎉 ArgoCD Login Credentials                    │${NC}"
        echo -e "${CYAN}  ├─────────────────────────────────────────────────────────┤${NC}"
        echo -e "${CYAN}  │  ${WHITE}URL      : ${GREEN}https://${PUBLIC_IP}:${ARGOCD_PORT}${CYAN}${NC}"
        echo -e "${CYAN}  │  ${WHITE}Username : ${GREEN}admin${CYAN}                                    │${NC}"
        echo -e "${CYAN}  │  ${WHITE}Password : ${GREEN}${PASSWORD}${CYAN}              │${NC}"
        echo -e "${CYAN}  └─────────────────────────────────────────────────────────┘${NC}"
    fi

    echo ""
    print_step "Starting port-forward in background..."
    kubectl port-forward svc/argocd-server -n $NAMESPACE ${ARGOCD_PORT}:443 --address=0.0.0.0 &>/dev/null &
    print_success "Port-forward started on port ${ARGOCD_PORT}"
}

# ═══════════════════════════════════════════════════════════════
# FINAL SUMMARY
# ═══════════════════════════════════════════════════════════════
print_final_summary() {
    echo ""
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║          🎊  SETUP COMPLETE! ArgoCD is READY!  🎊              ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║  📋 Quick Commands:                                             ║"
    echo "║                                                                  ║"
    echo "║  • Check Pods  : kubectl get pods -n argocd                     ║"
    echo "║  • Get Password: kubectl get secret argocd-initial-admin-secret ║"
    echo "║                   -n argocd -o jsonpath='{.data.password}'       ║"
    echo "║                   | base64 -d                                    ║"
    echo "║  • Port Forward: kubectl port-forward svc/argocd-server         ║"
    echo "║                   -n argocd 8080:443 --address=0.0.0.0 &        ║"
    echo "║  • CLI Login   : argocd login <IP>:8080 --username admin        ║"
    echo "║                   --password <PASS> --insecure                   ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║  🙏 Thank you for using this script!                            ║"
    echo "║                                                                  ║"
    echo "║  If this helped you, please:                                    ║"
    echo "║  ⭐ Star the repo on GitHub                                     ║"
    echo "║  🔔 Subscribe to TECH MAHATO on YouTube                         ║"
    echo "║  👍 Like & Share with your DevOps community                     ║"
    echo "║                                                                  ║"
    echo "║  ┌────────────────────────────────────────────────────────┐     ║"
    echo "║  │  📺 youtube.com/techmahato                             │     ║"
    echo "║  │  📝 medium.com/@techmahato                             │     ║"
    echo "║  │  💼 linkedin.com/in/arbindmahato                       │     ║"
    echo "║  │  🌐 techmahato.com                                     │     ║"
    echo "║  └────────────────────────────────────────────────────────┘     ║"
    echo "║                                                                  ║"
    echo "║       \"Learn DevOps from Zero to Production!\" 🚀              ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ═══════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════
main() {
    clear
    print_banner
    sleep 2

    echo ""
    echo -e "${YELLOW}  ⏳ Starting ArgoCD setup in 3 seconds...${NC}"
    echo -e "${DIM}  Press Ctrl+C to cancel${NC}"
    sleep 3

    check_prerequisites
    create_kind_cluster
    choose_install_method
    install_argocd_cli
    setup_access
    print_final_summary
}

# Run the script
main "$@"
