# CodeReviewer Pro - Development Makefile
# Optimized for RTX 4070 development environment

.PHONY: help install install-dev setup clean lint format test test-cov type-check \
        docker-build docker-run docker-dev docker-stop docker-clean \
        db-init db-migrate db-upgrade db-downgrade db-reset \
        ml-download ml-train ml-eval ml-deploy \
        jupyter tensorboard monitor \
        deploy deploy-staging deploy-prod \
        backup restore security-check

# =============================================================================
# VARIABLES
# =============================================================================
PYTHON := python3.11
PIP := $(PYTHON) -m pip
PROJECT_NAME := codereviewer-pro
DOCKER_IMAGE := $(PROJECT_NAME)
DOCKER_DEV_IMAGE := $(PROJECT_NAME)-dev
COMPOSE_FILE := docker-compose.yml
COMPOSE_DEV := docker-compose.override.yml

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# =============================================================================
# HELP
# =============================================================================
help: ## Show this help message
	@echo "$(GREEN)CodeReviewer Pro - Development Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Setup & Installation:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '(install|setup|clean)' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Development:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '(lint|format|test|type)' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Docker:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E 'docker' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Database:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E 'db-' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Machine Learning:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E 'ml-' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Services:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '(jupyter|tensorboard|monitor)' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Deployment:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '(deploy|backup|security)' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE)  %-20s$(NC) %s\n", $$1, $$2}'

# =============================================================================
# SETUP & INSTALLATION
# =============================================================================
install: ## Install production dependencies
	@echo "$(YELLOW)Installing production dependencies...$(NC)"
	$(PIP) install --upgrade pip setuptools wheel
	$(PIP) install -e .

install-dev: ## Install development dependencies
	@echo "$(YELLOW)Installing development dependencies...$(NC)"
	$(PIP) install --upgrade pip setuptools wheel
	$(PIP) install -e ".[dev,ml,monitoring]"
	pre-commit install

setup: ## Complete development environment setup
	@echo "$(GREEN)Setting up CodeReviewer Pro development environment...$(NC)"
	@chmod +x scripts/setup.sh
	@./scripts/setup.sh
	@echo "$(GREEN)✅ Setup complete!$(NC)"

clean: ## Clean up temporary files and caches
	@echo "$(YELLOW)Cleaning up...$(NC)"
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type f -name "*.log" -delete
	rm -rf build/
	rm -rf dist/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf .tox/
	@echo "$(GREEN)✅ Cleanup complete!$(NC)"

# =============================================================================
# DEVELOPMENT TOOLS
# =============================================================================
lint: ## Run linting (flake8)
	@echo "$(YELLOW)Running linting...$(NC)"
	flake8 app tests

format: ## Format code (black + isort)
	@echo "$(YELLOW)Formatting code...$(NC)"
	black app tests
	isort app tests
	@echo "$(GREEN)✅ Code formatted!$(NC)"

type-check: ## Run type checking (mypy)
	@echo "$(YELLOW)Running type checking...$(NC)"
	mypy app

test: ## Run tests
	@echo "$(YELLOW)Running tests...$(NC)"
	pytest -v

test-cov: ## Run tests with coverage
	@echo "$(YELLOW)Running tests with coverage...$(NC)"
	pytest --cov=app --cov-report=html --cov-report=term-missing

test-gpu: ## Run GPU-specific tests
	@echo "$(YELLOW)Running GPU tests...$(NC)"
	pytest -v -m gpu

pre-commit: ## Run all pre-commit checks
	@echo "$(YELLOW)Running pre-commit checks...$(NC)"
	pre-commit run --all-files

# =============================================================================
# DOCKER COMMANDS
# =============================================================================
docker-build: ## Build Docker image
	@echo "$(YELLOW)Building Docker image...$(NC)"
	docker build -t $(DOCKER_IMAGE):latest .

docker-build-dev: ## Build development Docker image
	@echo "$(YELLOW)Building development Docker image...$(NC)"
	docker build -f Dockerfile.dev -t $(DOCKER_DEV_IMAGE):latest .

docker-run: ## Run Docker container
	@echo "$(YELLOW)Starting Docker container...$(NC)"
	docker run -d --name $(PROJECT_NAME) -p 8000:8000 $(DOCKER_IMAGE):latest

docker-dev: ## Start development environment with Docker Compose
	@echo "$(YELLOW)Starting development environment...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✅ Development environment started!$(NC)"
	@echo "$(BLUE)FastAPI:$(NC) http://localhost:8000"
	@echo "$(BLUE)Jupyter Lab:$(NC) http://localhost:8888"
	@echo "$(BLUE)Grafana:$(NC) http://localhost:3000 (admin/admin123)"

docker-stop: ## Stop Docker containers
	@echo "$(YELLOW)Stopping Docker containers...$(NC)"
	docker-compose down

docker-clean: ## Remove Docker containers and images
	@echo "$(YELLOW)Cleaning Docker resources...$(NC)"
	docker-compose down --volumes --rmi all
	docker system prune -f

docker-logs: ## Show Docker logs
	docker-compose logs -f app

# =============================================================================
# DATABASE COMMANDS
# =============================================================================
db-init: ## Initialize database
	@echo "$(YELLOW)Initializing database...$(NC)"
	alembic init alembic
	@echo "$(GREEN)✅ Database initialized!$(NC)"

db-migrate: ## Create new migration
	@echo "$(YELLOW)Creating database migration...$(NC)"
	@read -p "Migration name: " name; \
	alembic revision --autogenerate -m "$$name"

db-upgrade: ## Apply database migrations
	@echo "$(YELLOW)Applying database migrations...$(NC)"
	alembic upgrade head
	@echo "$(GREEN)✅ Database updated!$(NC)"

db-downgrade: ## Rollback last migration
	@echo "$(YELLOW)Rolling back last migration...$(NC)"
	alembic downgrade -1

db-reset: ## Reset database (WARNING: Destroys all data)
	@echo "$(RED)⚠️  This will destroy all database data!$(NC)"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		alembic downgrade base; \
		alembic upgrade head; \
		echo "$(GREEN)✅ Database reset complete!$(NC)"; \
	else \
		echo "$(YELLOW)Database reset cancelled.$(NC)"; \
	fi

# =============================================================================
# MACHINE LEARNING COMMANDS
# =============================================================================
ml-download: ## Download base ML models (8GB VRAM optimized)
	@echo "$(YELLOW)Downloading 8GB VRAM optimized models...$(NC)"
	$(PYTHON) -c "from transformers import AutoModelForCausalLM, AutoTokenizer; \
	model_name='microsoft/CodeGPT-small-py'; \
	print('📥 Downloading CodeGPT-small for 8GB VRAM...'); \
	model = AutoModelForCausalLM.from_pretrained(model_name, cache_dir='./ml/models/.cache'); \
	tokenizer = AutoTokenizer.from_pretrained(model_name, cache_dir='./ml/models/.cache'); \
	print('✅ 8GB VRAM optimized models downloaded successfully!')"

ml-train: ## Start LoRA fine-tuning (8GB VRAM optimized)
	@echo "$(YELLOW)Starting LoRA fine-tuning...$(NC)"
	@echo "$(BLUE)Using RTX 4070 (8GB VRAM) optimized settings$(NC)"
	@echo "$(BLUE)LoRA rank=8, alpha=16, batch_size=1$(NC)"
	$(PYTHON) ml/training/fine_tune.py --config ml/training/configs/lora_config_8gb.yaml

ml-eval: ## Evaluate model performance
	@echo "$(YELLOW)Evaluating model performance...$(NC)"
	$(PYTHON) ml/training/evaluate.py

ml-deploy: ## Deploy fine-tuned model
	@echo "$(YELLOW)Deploying model to production...$(NC)"
	$(PYTHON) scripts/deploy_model.py

ml-benchmark: ## Run performance benchmarks on RTX 4070 (8GB)
	@echo "$(YELLOW)Running RTX 4070 (8GB VRAM) performance benchmarks...$(NC)"
	@echo "$(BLUE)Testing 4-bit quantization and CPU offloading...$(NC)"
	$(PYTHON) scripts/benchmark_gpu.py --vram_limit=8

# =============================================================================
# SERVICES
# =============================================================================
jupyter: ## Start Jupyter Lab
	@echo "$(YELLOW)Starting Jupyter Lab...$(NC)"
	jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
	@echo "$(BLUE)Jupyter Lab available at: http://localhost:8888$(NC)"

tensorboard: ## Start TensorBoard
	@echo "$(YELLOW)Starting TensorBoard...$(NC)"
	tensorboard --logdir=./logs --host=0.0.0.0 --port=6006
	@echo "$(BLUE)TensorBoard available at: http://localhost:6006$(NC)"

monitor: ## Start monitoring stack
	@echo "$(YELLOW)Starting monitoring services...$(NC)"
	docker-compose up -d prometheus grafana
	@echo "$(BLUE)Prometheus:$(NC) http://localhost:9090"
	@echo "$(BLUE)Grafana:$(NC) http://localhost:3000"

# =============================================================================
# DEVELOPMENT SERVER
# =============================================================================
dev: ## Start development server
	@echo "$(YELLOW)Starting development server...$(NC)"
	uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

dev-debug: ## Start development server with debugging
	@echo "$(YELLOW)Starting development server with debugging...$(NC)"
	$(PYTHON) -m debugpy --listen 0.0.0.0:5678 --wait-for-client -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

prod: ## Start production server
	@echo "$(YELLOW)Starting production server...$(NC)"
	gunicorn app.main:app --worker-class uvicorn.workers.UvicornWorker --workers 4 --bind 0.0.0.0:8000

# =============================================================================
# DEPLOYMENT
# =============================================================================
deploy-staging: ## Deploy to staging
	@echo "$(YELLOW)Deploying to staging...$(NC)"
	@./scripts/deploy.sh staging

deploy-prod: ## Deploy to production
	@echo "$(YELLOW)Deploying to production...$(NC)"
	@./scripts/deploy.sh production

# =============================================================================
# BACKUP & MAINTENANCE
# =============================================================================
backup: ## Create database backup
	@echo "$(YELLOW)Creating database backup...$(NC)"
	@mkdir -p backups
	@timestamp=$$(date +"%Y%m%d_%H%M%S"); \
	docker-compose exec postgres pg_dump -U codereviewer codereviewer > backups/backup_$$timestamp.sql; \
	echo "$(GREEN)✅ Backup created: backups/backup_$$timestamp.sql$(NC)"

restore: ## Restore database from backup
	@echo "$(YELLOW)Available backups:$(NC)"
	@ls -la backups/
	@read -p "Backup file name: " backup; \
	if [ -f "backups/$$backup" ]; then \
		docker-compose exec -T postgres psql -U codereviewer -d codereviewer < backups/$$backup; \
		echo "$(GREEN)✅ Database restored from $$backup$(NC)"; \
	else \
		echo "$(RED)❌ Backup file not found!$(NC)"; \
	fi

security-check: ## Run security checks
	@echo "$(YELLOW)Running security checks...$(NC)"
	bandit -r app/
	safety check
	@echo "$(GREEN)✅ Security check complete!$(NC)"

# =============================================================================
# GPU & SYSTEM INFO
# =============================================================================
gpu-info: ## Show GPU information (8GB VRAM check)
	@echo "$(YELLOW)RTX 4070 (8GB VRAM) GPU Information:$(NC)"
	@$(PYTHON) -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'GPU count: {torch.cuda.device_count()}'); print(f'GPU name: {torch.cuda.get_device_name() if torch.cuda.is_available() else \"N/A\"}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}'); \
	if torch.cuda.is_available(): \
		memory_gb = torch.cuda.get_device_properties(0).total_memory / 1024**3; \
		print(f'VRAM: {memory_gb:.1f} GB'); \
		print(f'8GB VRAM: {\"✅ Compatible\" if memory_gb >= 8 else \"⚠️ Limited (consider smaller models)\"}');"
	@nvidia-smi || echo "$(YELLOW)nvidia-smi not available$(NC)"

system-info: ## Show system information
	@echo "$(YELLOW)System Information:$(NC)"
	@$(PYTHON) -c "import sys, platform, psutil; print(f'Python: {sys.version}'); print(f'Platform: {platform.platform()}'); print(f'CPU: {platform.processor()}'); print(f'RAM: {psutil.virtual_memory().total // (1024**3)} GB'); print(f'Disk: {psutil.disk_usage(\"/\").total // (1024**3)} GB')"

# =============================================================================
# CI/CD
# =============================================================================
ci: lint type-check test ## Run CI pipeline locally
	@echo "$(GREEN)✅ CI pipeline completed successfully!$(NC)"

ci-full: clean install-dev lint type-check test-cov security-check ## Run full CI pipeline
	@echo "$(GREEN)✅ Full CI pipeline completed successfully!$(NC)"

# =============================================================================
# QUICK COMMANDS
# =============================================================================
quick-start: docker-dev ## Quick start development environment
	@echo "$(GREEN)🚀 Development environment is ready!$(NC)"
	@echo "$(BLUE)FastAPI docs:$(NC) http://localhost:8000/docs"

quick-test: format lint test ## Quick test suite
	@echo "$(GREEN)✅ Quick test completed!$(NC)"