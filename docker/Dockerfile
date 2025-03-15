FROM python:3.11-alpine
RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    make \
    && pip install --upgrade pip \
    && pip install requests pytest

COPY index.html /usr/share/nginx/html/
CMD ["python3", "--version"]
