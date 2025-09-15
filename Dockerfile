# Multi-stage build to reduce image size
FROM python:3.10 as builder

WORKDIR /app

# Install dependencies in builder
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-cache the embeddings model and RoBERTa base model
RUN python -c "from langchain_huggingface import HuggingFaceEmbeddings; HuggingFaceEmbeddings(model_name='sentence-transformers/paraphrase-MiniLM-L3-v2')"
RUN python -c "from transformers import AutoTokenizer, AutoModel; AutoTokenizer.from_pretrained('roberta-base'); AutoModel.from_pretrained('roberta-base')"

# Runtime stage
FROM python:3.10-slim

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /root/.cache /root/.cache

WORKDIR /app

# Copy source code
COPY . .

# .env is not copied for security; env vars passed via compose

# Expose Streamlit port
EXPOSE 8501

# Run Streamlit app
CMD ["streamlit", "run", "app.py"]
