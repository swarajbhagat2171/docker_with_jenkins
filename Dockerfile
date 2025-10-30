# Use official Nginx image
FROM nginx:alpine

# Copy my HTML page into Nginx default web directory
COPY index.html /usr/share/nginx/html/index.html
