FROM katta/nginx-extras

RUN mkdir -p /var/log/nginx &&  ln -sf /dev/stdout /var/log/nginx/access.log &&  ln -sf /dev/stderr /var/log/nginx/error.log && chown -R www-data:www-data /var/log/nginx
RUN mkdir -p /etc/nginx/ssl && openssl req -new -nodes -x509 -subj "/C=US/ST=Oregon/L=Portland/O=IT/CN=previewdomain.com" -days 3650 -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt -extensions v3_ca
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx/html
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
