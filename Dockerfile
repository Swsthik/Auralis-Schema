FROM python:3.10-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port for Cloud Run
EXPOSE 8080

# Run Streamlit on Cloud Run's expected port
CMD ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]