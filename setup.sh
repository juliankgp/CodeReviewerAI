#!/bin/bash
# CodeReviewer Pro - Automated Setup Script
# Optimized for Windows 11 + WSL2 + RTX 4070

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PYTHON_VERSION="3.11"
PROJECT_NAME="CodeReviewer Pro"
REQUIRED_GPU_MEMORY=8   # GB
CUDA_VERSION="11.8"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================
print_banner() {
    echo -e "${PURPLE}"
    echo "██████╗ ██████╗ ███████╗██╗   ██╗██╗███████╗██╗    ██╗███████╗██████╗ "
    echo "██╔══██╗██╔══██╗██╔════╝██║   ██║██║██╔════╝██║    ██║██╔════╝██╔══██╗"
    echo "██║  ██║██████╔╝█████╗  ██║   ██║██║█████╗  ██║ █╗ ██║█████╗  ██████╔╝"
    echo "██║  ██║██╔══██╗██╔══╝  ╚██╗ ██╔╝██║██╔══╝  ██║███╗██║██╔══╝  ██╔══██╗"
    echo "██████╔╝██║  ██║███████╗ ╚████╔╝ ██║███████╗╚███╔███╔╝███████╗██║  ██║"
    echo "╚═════╝ ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${BLUE}🚀 ${PROJECT_NAME} - Automated Setup${NC}"
    echo -e "${BLUE}Optimized for RTX 4070 (8GB VRAM) + Windows 11 + WSL2${NC}"
    echo ""
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# =============================================================================
# SYSTEM CHECKS
# =============================================================================
check_system_requirements() {
    log_info "🔍 Checking system requirements..."
    
    # Check OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_success "✅ Linux detected"
        if grep -q Microsoft /proc/version; then
            log_success "✅ WSL2 detected"
        fi
    else
        log_warning "⚠️  This script is optimized for Linux/WSL2"
    fi
    
    # Check Python version
    if check_command python3.11; then
        PYTHON_CMD="python3.11"
        log_success "✅ Python 3.11 found"
    elif check_command python3; then
        PYTHON_VERSION_CHECK=$(python3 --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        if [[ "$PYTHON_VERSION_CHECK" == "3.11" ]]; then
            PYTHON_CMD="python3"
            log_success "✅ Python 3.11 found"
        else
            log_error "❌ Python 3.11 required, found $PYTHON_VERSION_CHECK"
            exit 1
        fi
    else
        log_error "❌ Python 3.11 not found. Please install Python 3.11"
        exit 1
    fi
    
    # Check pip
    if ! check_command pip3; then
        log_error "❌ pip3 not found. Please install pip"
        exit 1
    fi
    log_success "✅ pip3 found"
    
    # Check Git
    if ! check_command git; then
        log_error "❌ Git not found. Please install Git"
        exit 1
    fi
    log_success "✅ Git found"
    
    # Check Docker
    if check_command docker; then
        log_success "✅ Docker found"
        # Check if Docker daemon is running
        if docker info &> /dev/null; then
            log_success "✅ Docker daemon is running"
        else
            log_warning "⚠️  Docker daemon not running. Please start Docker"
        fi
    else
        log_warning "⚠️  Docker not found. Install Docker for containerized development"
    fi
    
    # Check Docker Compose
    if check_command docker-compose || docker compose version &> /dev/null; then
        log_success "✅ Docker Compose found"
    else
        log_warning "⚠️  Docker Compose not found. Install for containerized development"
    fi
}

check_gpu_requirements() {
    log_info "🎮 Checking GPU requirements..."
    
    # Check nvidia-smi
    if check_command nvidia-smi; then
        log_success "✅ nvidia-smi found"
        
        # Get GPU memory
        GPU_MEMORY=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1)
        GPU_MEMORY_GB=$((GPU_MEMORY / 1024))
        
        log_info "🔍 Detected GPU memory: ${GPU_MEMORY_GB}GB"
        
        if [ "$GPU_MEMORY_GB" -ge "$REQUIRED_GPU_MEMORY" ]; then
            log_success "✅ Sufficient GPU memory for RTX 4070 (8GB) optimization"
        elif [ "$GPU_MEMORY_GB" -ge 6 ]; then
            log_warning "⚠️  GPU has ${GPU_MEMORY_GB}GB, will use smaller models (7B parameters max)"
            log_warning "⚠️  Consider 4-bit quantization and CPU offloading for larger models"
        else
            log_warning "⚠️  GPU has ${GPU_MEMORY_GB}GB, RTX 4070 (8GB) recommended"
            log_warning "⚠️  Performance will be limited. CPU-only mode may be necessary"
        fi
        
        # Check CUDA version
        CUDA_VERSION_INSTALLED=$(nvidia-smi | grep "CUDA Version" | sed 's/.*CUDA Version: \([0-9.]*\).*/\1/')
        log_info "🔍 CUDA Version: $CUDA_VERSION_INSTALLED"
        
    else
        log_warning "⚠️  nvidia-smi not found. GPU acceleration may not be available"
        log_warning "⚠️  Install NVIDIA drivers and CUDA $CUDA_VERSION for optimal performance"
    fi
}

# =============================================================================
# ENVIRONMENT SETUP
# =============================================================================
setup_python_environment() {
    log_info "🐍 Setting up Python environment..."
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        log_info "Creating virtual environment..."
        $PYTHON_CMD -m venv venv
        log_success "✅ Virtual environment created"
    else
        log_success "✅ Virtual environment already exists"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    log_success "✅ Virtual environment activated"
    
    # Upgrade pip
    log_info "Upgrading pip..."
    python -m pip install --upgrade pip setuptools wheel
    log_success "✅ pip upgraded"
}

install_dependencies() {
    log_info "📦 Installing dependencies..."
    
    # Install PyTorch with CUDA support first
    log_info "Installing PyTorch with CUDA 11.8 support..."
    pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2+cu118 \
        --extra-index-url https://download.pytorch.org/whl/cu118
    log_success "✅ PyTorch with CUDA support installed"
    
    # Install main requirements
    log_info "Installing project dependencies..."
    pip install -r requirements.txt
    log_success "✅ Dependencies installed"
    
    # Install development dependencies
    log_info "Installing development dependencies..."
    pip install -e ".[dev,ml,monitoring]"
    log_success "✅ Development dependencies installed"
}

# =============================================================================
# PROJECT CONFIGURATION
# =============================================================================
setup_configuration() {
    log_info "⚙️  Setting up configuration files..."
    
    # Copy environment file
    if [ ! -f ".env" ]; then
        cp .env.example .env
        log_success "✅ Environment file created (.env)"
        log_warning "⚠️  Please edit .env file with your configuration"
    else
        log_success "✅ Environment file already exists"
    fi
    
    # Setup pre-commit hooks
    if check_command pre-commit; then
        log_info "Installing pre-commit hooks..."
        pre-commit install
        log_success "✅ Pre-commit hooks installed"
    fi
}

setup_directories() {
    log_info "📁 Setting up project directories..."
    
    # Create necessary directories
    mkdir -p {ml/{models/{base,fine_tuned,cache},data/{raw,processed,synthetic},training/configs},logs,uploads,backups}
    
    # Create .gitkeep files for empty directories
    touch ml/models/base/.gitkeep
    touch ml/models/fine_tuned/.gitkeep
    touch ml/data/raw/.gitkeep
    touch ml/data/processed/.gitkeep
    touch logs/.gitkeep
    touch uploads/.gitkeep
    
    log_success "✅ Project directories created"
}

# =============================================================================
# DOCKER SETUP
# =============================================================================
setup_docker() {
    if check_command docker && docker info &> /dev/null; then
        log_info "🐳 Setting up Docker environment..."
        
        # Check if NVIDIA Docker runtime is available
        if docker info 2>/dev/null | grep -q nvidia; then
            log_success "✅ NVIDIA Docker runtime detected"
        else
            log_warning "⚠️  NVIDIA Docker runtime not detected"
            log_warning "⚠️  Install nvidia-container-toolkit for GPU support in containers"
        fi
        
        # Build development image
        log_info "Building development Docker image..."
        if docker build -f Dockerfile.dev -t codereviewer-pro-dev:latest .; then
            log_success "✅ Development Docker image built"
        else
            log_warning "⚠️  Failed to build Docker image"
        fi
        
    else
        log_warning "⚠️  Docker not available. Skipping Docker setup"
    fi
}

# =============================================================================
# GPU OPTIMIZATION
# =============================================================================
setup_gpu_optimization() {
    log_info "🚀 Setting up GPU optimizations..."
    
    # Test CUDA availability
    python -c "
import torch
print('🔍 Testing CUDA availability...')
if torch.cuda.is_available():
    print('✅ CUDA is available')
    print(f'🎮 GPU: {torch.cuda.get_device_name()}')
    print(f'💾 VRAM: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB')
    print('✅ GPU optimization ready')
else:
    print('⚠️  CUDA not available. CPU-only mode')
" 2>/dev/null || log_warning "⚠️  Could not test CUDA availability"
}

# =============================================================================
# VALIDATION
# =============================================================================
validate_installation() {
    log_info "🔍 Validating installation..."
    
    # Test imports
    python -c "
import sys
import torch
import transformers
import fastapi
import peft
import accelerate

print('✅ All critical packages imported successfully')
print(f'🐍 Python: {sys.version.split()[0]}')
print(f'🔥 PyTorch: {torch.__version__}')
print(f'🤗 Transformers: {transformers.__version__}')
print(f'🚀 FastAPI: {fastapi.__version__}')
print(f'🎯 PEFT: {peft.__version__}')
print(f'⚡ Accelerate: {accelerate.__version__}')

if torch.cuda.is_available():
    print(f'🎮 CUDA: {torch.version.cuda}')
    print('🚀 Ready for RTX 4070 (8GB VRAM) optimization!')
else:
    print('💻 CPU-only mode enabled')
" 2>/dev/null && log_success "✅ Installation validated" || log_error "❌ Validation failed"
}

# =============================================================================
# MAIN SETUP ROUTINE
# =============================================================================
main() {
    print_banner
    
    log_info "🚀 Starting automated setup for $PROJECT_NAME"
    
    # System checks
    check_system_requirements
    check_gpu_requirements
    
    # Setup Python environment
    setup_python_environment
    
    # Install dependencies
    install_dependencies
    
    # Project configuration
    setup_configuration
    setup_directories
    
    # Docker setup (optional)
    setup_docker
    
    # GPU optimization
    setup_gpu_optimization
    
    # Validation
    validate_installation
    
    # Final instructions
    echo ""
    echo -e "${PURPLE}🎉 Setup Complete! 🎉${NC}"
    echo ""
    echo -e "${GREEN}✅ $PROJECT_NAME is ready for development!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. ${CYAN}Edit .env file with your configuration${NC}"
    echo -e "  2. ${CYAN}Start development environment: make docker-dev${NC}"
    echo -e "  3. ${CYAN}Or start manually: make dev${NC}"
    echo -e "  4. ${CYAN}Visit http://localhost:8000/docs for API documentation${NC}"
    echo ""
    echo -e "${BLUE}Useful commands:${NC}"
    echo -e "  • ${CYAN}make help${NC}           - Show all available commands"
    echo -e "  • ${CYAN}make gpu-info${NC}       - Check GPU status"
    echo -e "  • ${CYAN}make test${NC}           - Run test suite"
    echo -e "  • ${CYAN}make ml-download${NC}    - Download base ML models"
    echo ""
    echo -e "${YELLOW}⚠️  Don't forget to:${NC}"
    echo -e "  • Configure your .env file with API keys and settings"
    echo -e "  • Ensure NVIDIA drivers and CUDA $CUDA_VERSION are installed"
    echo -e "  • Install Docker if you want containerized development"
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}"
}

# =============================================================================
# ERROR HANDLING
# =============================================================================
trap 'log_error "Setup failed! Check the output above for errors."; exit 1' ERR

# Run main function
main "$@"