FROM nginx:latest
RUN apt-get update && apt-get install -y python3 python3-pip && pip install requests pytest
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]