# 🚀 CodeReviewer Pro

> AI-powered code review and analysis platform using LoRA fine-tuning, optimized for RTX 4070 (8GB VRAM)

[![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.103+-green.svg)](https://fastapi.tiangolo.com/)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.0+-red.svg)](https://pytorch.org/)
[![CUDA 11.8](https://img.shields.io/badge/CUDA-11.8-green.svg)](https://developer.nvidia.com/cuda-toolkit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 Overview

CodeReviewer Pro is an intelligent SaaS platform that provides AI-powered code reviews and analysis. Built with cutting-edge ML technology, it uses code-specific models fine-tuned with LoRA for efficient, accurate code analysis optimized for RTX 4070 (8GB VRAM).

### ✨ Key Features

- 🧠 **AI-Powered Reviews**: Advanced code analysis using fine-tuned LLMs
- ⚡ **8GB VRAM Optimized**: Memory-efficient inference with 4-bit quantization and CPU offloading
- 🔄 **Real-time Analysis**: Sub-30 second review generation
- 📊 **Comprehensive Metrics**: Code quality, security, and performance insights
- 🚀 **FastAPI Backend**: High-performance async API
- ⚛️ **React Frontend**: Modern, responsive user interface
- 🐳 **Docker Ready**: Complete containerized development environment
- 📈 **Monitoring Built-in**: Prometheus, Grafana, and structured logging

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React Frontend │────│  FastAPI Backend │────│   ML Pipeline   │
│   (Port 3000)   │    │   (Port 8000)    │    │ (RTX 4070 8GB)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         └──────────────│   PostgreSQL    │──────────────┘
                        │   (Port 5432)   │
                        └─────────────────┘
                                 │
                        ┌─────────────────┐
                        │      Redis      │
                        │   (Port 6379)   │
                        └─────────────────┘
```

## 🔧 Tech Stack

### Backend
- **FastAPI** - Modern async web framework
- **PostgreSQL** - Primary database
- **Redis** - Caching and task queue
- **SQLAlchemy** - ORM with async support
- **Alembic** - Database migrations

### Machine Learning
- **PyTorch 2.0+** - Deep learning framework
- **Transformers** - HuggingFace library
- **PEFT** - Parameter-Efficient Fine-Tuning (LoRA)
- **Accelerate** - Multi-GPU and mixed precision
- **BitsAndBytes** - 4-bit/8-bit quantization

### Development & Deployment
- **Docker** - Containerization
- **Docker Compose** - Multi-service orchestration
- **Prometheus** - Metrics collection
- **Grafana** - Metrics visualization
- **Pre-commit** - Code quality hooks

## 🚀 Quick Start

### Prerequisites

- **Hardware**: NVIDIA RTX 4070 (8GB VRAM) or equivalent
- **OS**: Windows 11 with WSL2 or Linux
- **Software**: Docker, Docker Compose, Python 3.11+
- **CUDA**: Version 11.8 or compatible

### 1. Clone & Setup

```bash
git clone https://github.com/yourusername/codereviewer-pro.git
cd codereviewer-pro

# Run automated setup
chmod +x setup.sh
./setup.sh
```

### 2. Quick Start with Docker

```bash
# Start the complete development environment
make docker-dev

# Or manually with Docker Compose
docker-compose up -d
```

### 3. Manual Installation

```bash
# Create virtual environment
python3.11 -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate

# Install dependencies
make install-dev

# Set up environment
cp .env.example .env
# Edit .env with your configuration

# Initialize database
make db-upgrade

# Start development server
make dev
```

## 📋 Available Services

After running `make docker-dev`, the following services will be available:

| Service | URL | Description |
|---------|-----|-------------|
| **FastAPI API** | http://localhost:8000 | Main application API |
| **API Docs** | http://localhost:8000/docs | Interactive API documentation |
| **Jupyter Lab** | http://localhost:8888 | ML experimentation notebook |
| **TensorBoard** | http://localhost:6006 | Training metrics visualization |
| **Grafana** | http://localhost:3000 | Monitoring dashboard (admin/admin123) |
| **Prometheus** | http://localhost:9090 | Metrics collection |

## 🛠️ Development Workflow

### Common Commands

```bash
# Development
make dev                 # Start development server
make test               # Run test suite  
make lint               # Run code linting
make format             # Format code (black + isort)
make type-check         # Run type checking

# Docker
make docker-dev         # Start development environment
make docker-logs        # View application logs
make docker-stop        # Stop all containers

# Database
make db-migrate         # Create new migration
make db-upgrade         # Apply migrations
make db-reset          # Reset database (⚠️ destructive)

# Machine Learning
make ml-download        # Download base models
make ml-train          # Start LoRA fine-tuning
make gpu-info          # Check GPU status
```

### Project Structure

```
CodeReviewerAI/
├── app/                    # FastAPI application
│   ├── api/               # API routes
│   ├── core/              # Core configuration
│   ├── models/            # Database models  
│   ├── services/          # Business logic
│   └── utils/             # Utilities
├── ml/                    # Machine learning pipeline
│   ├── models/            # Model storage
│   ├── training/          # Training scripts
│   └── inference/         # Inference pipeline
├── frontend/              # React application
├── tests/                 # Test suites
├── config/               # Configuration files
├── scripts/              # Utility scripts
└── deployment/           # Deployment configs
```

## 🤖 Machine Learning Pipeline

### Model Configuration

The system uses smaller code-specific models with LoRA fine-tuning optimized for 8GB VRAM:

- **Recommended Model**: CodeLlama-7B or CodeGPT-small (quantized to 4-bit)
- **Alternative**: GPT-OSS-7B (4-bit quantized)
- **Fine-tuning**: LoRA with r=8, α=16 (reduced for memory)
- **Memory Usage**: ~3.5GB VRAM (fits comfortably in 8GB)
- **Inference Time**: <30 seconds per review
- **Batch Size**: 1 sample optimal for 8GB VRAM
- **CPU Offloading**: Available for larger models

### Training Your Own Model

```bash
# Download base model
make ml-download

# Prepare your training data in ml/data/raw/
# Run fine-tuning with RTX 4070 optimized settings
make ml-train

# Evaluate model performance
make ml-eval

# Deploy to production
make ml-deploy
```

### Hardware Optimization

The project is specifically optimized for RTX 4070 (8GB VRAM):

```python
# Optimized model loading for 8GB VRAM
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    load_in_4bit=True,           # 4-bit quantization mandatory
    device_map="auto",           # Auto device mapping
    torch_dtype=torch.float16,   # Half precision
    max_memory={0: "6GB"},       # Reserve 2GB for system processes
    offload_folder="cpu_offload", # CPU offloading for memory management
    low_cpu_mem_usage=True,      # Reduce CPU memory usage
)
```

## 🔒 Security & Authentication

### API Security
- JWT-based authentication
- Rate limiting with Redis
- Input validation with Pydantic
- SQL injection protection with SQLAlchemy

### Environment Security
```bash
# Check for security vulnerabilities
make security-check

# Run comprehensive security audit
bandit -r app/
safety check requirements.txt
```

## 📊 Monitoring & Observability

### Built-in Monitoring

- **Metrics**: Prometheus metrics collection
- **Logging**: Structured JSON logging with rotation  
- **Tracing**: OpenTelemetry support (optional)
- **Health Checks**: Automatic service health monitoring

### Key Metrics Tracked

- API response times and error rates
- GPU memory usage and utilization
- Model inference latency
- Database query performance
- Queue processing times

## 🧪 Testing

### Running Tests

```bash
# Run all tests
make test

# Run with coverage
make test-cov

# Run GPU-specific tests
make test-gpu

# Run integration tests
pytest tests/integration/ -v

# Run specific test file
pytest tests/test_ml_pipeline.py -v
```

### Test Structure

```
tests/
├── unit/                  # Unit tests
├── integration/           # Integration tests
├── e2e/                   # End-to-end tests
└── fixtures/             # Test data and fixtures
```

## 🚀 Deployment

### Local Development
```bash
make docker-dev            # Complete dev environment
```

### Staging Deployment
```bash
make deploy-staging        # Deploy to staging
```

### Production Deployment
```bash
# Build production image
docker build -t codereviewer-pro:latest .

# Deploy with proper configuration
make deploy-prod
```

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
# Core settings
SECRET_KEY=your-secret-key
DATABASE_URL=postgresql+asyncpg://user:pass@localhost/db
REDIS_URL=redis://localhost:6379/0

# ML settings
MODEL_CACHE_DIR=./ml/models
USE_QUANTIZATION=true
CUDA_VISIBLE_DEVICES=0

# Optional integrations
HUGGINGFACE_TOKEN=your-token
STRIPE_SECRET_KEY=your-stripe-key
```

## 🐛 Troubleshooting

### Common Issues

#### CUDA Out of Memory
```bash
# Check GPU memory
make gpu-info

# Reduce batch size in .env
MODEL_BATCH_SIZE=1

# Enable gradient checkpointing
GRADIENT_CHECKPOINTING=true
```

#### Database Connection Issues
```bash
# Check database status
docker-compose logs postgres

# Reset database
make db-reset
```

#### Model Loading Issues
```bash
# Clear model cache
rm -rf ml/models/.cache

# Re-download models
make ml-download
```

### Performance Optimization

#### RTX 4070 (8GB) Specific
- Mandatory 4-bit quantization for inference
- CPU offloading for larger models
- Single batch size (batch_size=1)
- Gradient checkpointing for training
- Mixed precision training essential
- Sequential CPU offloading available

#### System Requirements
- **Minimum**: 16GB RAM, RTX 3060 (8GB)
- **Recommended**: 32GB+ RAM, RTX 4070 (8GB) ✅
- **Optimal**: 64GB+ RAM, RTX 4070 (8GB) with fast NVMe SSD

## 📚 Documentation

- **API Documentation**: http://localhost:8000/docs (when running)
- **Code Documentation**: Generated with Sphinx
- **ML Pipeline**: See `docs/ml_pipeline.md`
- **Deployment Guide**: See `docs/deployment.md`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`make ci`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guide
- Write tests for new features
- Update documentation
- Use pre-commit hooks
- Ensure GPU compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- HuggingFace for the Transformers library
- Microsoft for LoRA research
- FastAPI team for the excellent framework
- PyTorch team for the ML framework

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/codereviewer-pro/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/codereviewer-pro/discussions)
- **Email**: support@codereviewerpro.com

---

**Made with ❤️ for developers who care about code quality**

🚀 **Ready to revolutionize your code reviews with AI?** Get started with `make quick-start`!