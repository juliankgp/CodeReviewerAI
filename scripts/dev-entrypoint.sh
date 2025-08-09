#!/bin/bash
# Development entrypoint script for CodeReviewer Pro

set -e

echo "🚀 Starting CodeReviewer Pro Development Environment"

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
python -c "
import time
import sys
from sqlalchemy import create_engine
from app.core.config import get_settings

settings = get_settings()
retries = 30
while retries > 0:
    try:
        engine = create_engine(settings.database_url)
        connection = engine.connect()
        connection.close()
        print('✅ Database connected successfully')
        break
    except Exception as e:
        print(f'❌ Database not ready: {e}')
        retries -= 1
        time.sleep(1)
else:
    print('💥 Could not connect to database')
    sys.exit(1)
"

# Run database migrations
echo "🗄️ Running database migrations..."
alembic upgrade head

# Check CUDA availability
echo "🎮 Checking CUDA availability..."
python -c "
import torch
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA devices: {torch.cuda.device_count()}')
    print(f'Current device: {torch.cuda.current_device()}')
    print(f'Device name: {torch.cuda.get_device_name()}')
    print(f'Memory allocated: {torch.cuda.memory_allocated() / 1024**3:.2f} GB')
    print(f'Memory reserved: {torch.cuda.memory_reserved() / 1024**3:.2f} GB')
"

# Start Jupyter Lab in background if requested
if [ "$ENABLE_JUPYTER" = "true" ]; then
    echo "📓 Starting Jupyter Lab..."
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' &
fi

# Start TensorBoard in background if requested
if [ "$ENABLE_TENSORBOARD" = "true" ]; then
    echo "📊 Starting TensorBoard..."
    tensorboard --logdir=./logs --host=0.0.0.0 --port=6006 &
fi

echo "✅ Development environment ready!"

# Execute the main command
exec "$@"