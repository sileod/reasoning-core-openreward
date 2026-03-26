FROM python:3.11-slim AS builder
RUN apt update && apt install -y gcc build-essential git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-slim
RUN apt update && apt upgrade -y && apt install -y curl git && rm -rf /var/lib/apt/lists/*
COPY --from=builder /install /usr/local
WORKDIR /app
COPY server.py .
EXPOSE 8000
CMD ["python", "server.py"]
