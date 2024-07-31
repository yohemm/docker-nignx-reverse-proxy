FROM nginx:1.27.0-alpine3.19-perl
# RUN apk update
RUN apk add -i --no-cache certbot
RUN mkdir /var/www/ && mkdir /var/www/certbot
# RUN echo "43 6 * * * certbot renew --post-hook \"systemctl reload nginx\"" >> /etc/crontabs/root
COPY --chmod=771 ./scripts /scripts
# RUN certbot certonly -v --webroot --agree-tos --renew-by-default --preferred-challenges http-01 --email vaxelaire.yohem@gmail.com --webroot-path /var/www/certbot -d minepiece.fr
# RUN certbot --nginx -d example.com
# RUN apk add --update python3 py3-pip
# RUN certbot --nginx -m vaxelaire.yohem@gmail.com --debug-challenges --agree-tos -d  test.gites-hautes-vosges.fr
# -d DOMAIN, --domains DOMAIN, --domain DOMAIN
# RUN echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && sudo certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
ENTRYPOINT [ "/scripts/init.sh" ]
EXPOSE 80
EXPOSE 443