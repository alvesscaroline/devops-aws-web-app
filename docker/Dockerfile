FROM python:3.11-alpine

WORKDIR /app

COPY docker/tests /tests
COPY docker/requirements.txt /app/

RUN pip install --no-cache-dir -r /app/requirements.txt

CMD ["pytest", "/tests"]