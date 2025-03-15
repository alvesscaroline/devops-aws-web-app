FROM nginx:alpine

RUN apk add --no-cache \
    python3 \
    py3-pip \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    make \
    && pip install --upgrade pip \
    && pip install requests pytest

COPY index.html /usr/share/nginx/html/
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]