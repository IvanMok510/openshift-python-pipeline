FROM nginx:mainline-alpine

# Install Python and dependencies
RUN apk add --no-cache python3 py3-pip && \
    python3 -m venv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir --upgrade pip setuptools

# Set working directory
WORKDIR /app

# Copy application code and requirements
COPY app/requirements.pip .
COPY app .

# Install Python dependencies in virtual environment
RUN /app/venv/bin/pip install --no-cache-dir -r requirements.pip

# Copy NGINX configuration
COPY config /etc/nginx

# Expose port
EXPOSE 8080

# Start NGINX and Gunicorn
CMD ["sh", "-c", "nginx && /app/venv/bin/gunicorn -b 0.0.0.0:8080 main:app"]
