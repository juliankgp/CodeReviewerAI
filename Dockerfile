# CodeReviewer Pro - Production Dockerfile
# Optimized for RTX 4070 (8GB VRAM) deployment with CUDA 11.8 support

# Multi-stage build for production optimization
FROM nvidia/cuda:11.8-devel-ubuntu22.04 as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    CUDA_VISIBLE_DEVICES=0 \
    TORCH_CUDA_ARCH_LIST="8.6" \
    FORCE_CUDA="1"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    git \
    curl \
    wget \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python3.11
RUN ln -s /usr/bin/python3.11 /usr/bin/python && \
    ln -s /usr/bin/python3.11 /usr/bin/python3

# Upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel

# Development stage
FROM base as development

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies with CUDA support
RUN pip install --no-cache-dir -r requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Copy application code
COPY . .

# Create directories for ML models and data
RUN mkdir -p /app/ml/models/base /app/ml/models/fine_tuned /app/ml/data

# Install development tools
RUN pip install --no-cache-dir \
    jupyter \
    ipykernel \
    notebook

# Expose ports
EXPOSE 8000 8888

# Development command
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# Production stage
FROM base as production

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Copy application code
COPY --chown=app:app . .

# Create necessary directories
RUN mkdir -p /app/ml/models/base /app/ml/models/fine_tuned /app/ml/data /app/logs && \
    chown -R app:app /app

# Switch to non-root user
USER app

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Production command with optimized settings
CMD ["gunicorn", "app.main:app", \
     "--worker-class", "uvicorn.workers.UvicornWorker", \
     "--workers", "1", \
     "--worker-connections", "1000", \
     "--max-requests", "1000", \
     "--max-requests-jitter", "100", \
     "--bind", "0.0.0.0:8000", \
     "--access-logfile", "-", \
     "--error-logfile", "-", \
     "--log-level", "info"]