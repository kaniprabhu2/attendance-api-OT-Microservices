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

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev

# Copy app code
COPY . .

# Expose port
EXPOSE 8000

# Run using gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
