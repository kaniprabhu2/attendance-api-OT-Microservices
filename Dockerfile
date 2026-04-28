FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install poetry
RUN pip install poetry

# Copy dependency files
COPY pyproject.toml poetry.lock* /app/

# Install dependencies ONLY (not project itself)
RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-root

# Copy project files
COPY . .

# Expose port
EXPOSE 8000

# Run app
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
