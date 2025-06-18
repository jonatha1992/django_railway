# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV POETRY_NO_INTERACTION=1

# Install Poetry
RUN pip install --no-cache-dir poetry

# Set working directory
WORKDIR /app

# Copy poetry files and install dependencies
COPY pyproject.toml poetry.lock* /app/
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-root

# Copy project source
COPY . /app/

# Expose port
EXPOSE 8000

# Run migrations and start the app with Gunicorn
CMD ["sh", "-c", "python manage.py migrate && gunicorn myproject.wsgi:application --bind 0.0.0.0:8000"]
