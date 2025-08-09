# CodeReviewer Pro - Project Structure

```
CodeReviewerAI/
├── app/                          # FastAPI backend application
│   ├── api/                      # API routes and endpoints
│   │   ├── v1/                   # API version 1 routes
│   │   └── deps.py               # API dependencies
│   ├── core/                     # Core application logic
│   │   ├── config.py             # Application configuration
│   │   ├── security.py           # Authentication & authorization
│   │   └── database.py           # Database connection
│   ├── models/                   # SQLAlchemy models
│   │   ├── user.py               # User model
│   │   ├── review.py             # Code review model
│   │   └── subscription.py       # Subscription model
│   ├── services/                 # Business logic services
│   │   ├── code_analyzer.py      # Main code analysis service
│   │   ├── ml_service.py         # ML model inference service
│   │   └── payment_service.py    # Payment processing
│   └── utils/                    # Utility functions
│       ├── logging.py            # Logging configuration
│       └── validators.py         # Input validation
│
├── frontend/                     # React frontend application
│   ├── src/
│   │   ├── components/           # React components
│   │   ├── pages/               # Page components
│   │   ├── services/            # API service calls
│   │   └── utils/               # Frontend utilities
│   └── public/                  # Static assets
│
├── ml/                          # Machine Learning components
│   ├── models/                  # Trained model files
│   │   ├── fine_tuned/          # LoRA fine-tuned models
│   │   └── base/                # Base GPT-OSS-20b model
│   ├── data/                    # Training and validation data
│   │   ├── raw/                 # Raw code samples
│   │   ├── processed/           # Preprocessed datasets
│   │   └── synthetic/           # Generated training data
│   ├── training/                # Training scripts and configs
│   │   ├── fine_tune.py         # LoRA fine-tuning script
│   │   ├── data_preprocessing.py # Data preparation
│   │   └── configs/             # Training configurations
│   └── inference/               # Inference pipeline
│       ├── model_loader.py      # Model loading utilities
│       └── pipeline.py          # Inference pipeline
│
├── config/                      # Configuration files
│   ├── logging.conf            # Logging configuration
│   ├── prometheus.yml          # Monitoring configuration
│   └── nginx.conf              # Reverse proxy config
│
├── scripts/                     # Utility scripts
│   ├── setup.sh               # Environment setup script
│   ├── train.sh               # Training automation script
│   └── deploy.sh              # Deployment automation
│
├── tests/                       # Test suites
│   ├── unit/                   # Unit tests
│   ├── integration/            # Integration tests
│   └── e2e/                    # End-to-end tests
│
├── docs/                        # Documentation
│   ├── api.md                  # API documentation
│   ├── deployment.md           # Deployment guide
│   └── ml_pipeline.md          # ML pipeline documentation
│
├── deployment/                  # Deployment configurations
│   ├── docker/                 # Docker configurations
│   │   ├── Dockerfile          # Main application Dockerfile
│   │   ├── Dockerfile.ml       # ML-specific Dockerfile
│   │   └── Dockerfile.frontend # Frontend Dockerfile
│   └── k8s/                    # Kubernetes manifests (future)
│
├── notebooks/                   # Jupyter notebooks for research
│   ├── data_analysis.ipynb     # Data exploration
│   ├── model_evaluation.ipynb  # Model performance analysis
│   └── experiments/            # ML experiments
│
├── monitoring/                  # Monitoring and observability
│   ├── grafana/               # Grafana dashboards
│   └── alerts/                # Alert configurations
│
├── migrations/                  # Database migrations
│   └── versions/              # Migration versions
│
├── requirements.txt            # Python dependencies
├── pyproject.toml             # Project configuration
├── docker-compose.yml         # Local development environment
├── Dockerfile                 # Production Docker image
├── .env.example              # Environment variables template
├── .gitignore                # Git ignore rules
├── Makefile                  # Development commands
├── README.md                 # Project documentation
└── setup.sh                 # Automated setup script
```

## Key Directory Explanations:

### `/app` - FastAPI Backend
- **api/**: REST API endpoints organized by version
- **core/**: Core application configuration and utilities
- **models/**: SQLAlchemy ORM models for database entities
- **services/**: Business logic layer, separated by domain
- **utils/**: Shared utility functions

### `/ml` - Machine Learning Pipeline
- **models/**: Storage for trained models (LoRA adapters, base models)
- **data/**: All datasets organized by processing stage
- **training/**: Scripts for model fine-tuning with LoRA
- **inference/**: Production inference pipeline optimized for RTX 4070

### `/frontend` - React Application
- Standard React application structure for the web interface
- Components are organized by feature/domain

### `/deployment` - Infrastructure
- Docker configurations for different environments
- Future Kubernetes manifests for scaling

### Hardware Optimization Notes:
- ML inference optimized for RTX 4070 (12GB VRAM)
- CUDA 11.8 compatibility throughout the stack
- Memory-efficient LoRA fine-tuning approach
- Batch processing strategies for optimal GPU utilization