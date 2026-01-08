FROM nginx:alpine

# Copy your custom index.html file into the default NGINX web root directory
COPY index.html /usr/share/nginx/html/index.html
