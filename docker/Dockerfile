FROM nginx:alpine
RUN apk add --no-cache python3 py3-pip && pip install requests pytest
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]