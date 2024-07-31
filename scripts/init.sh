#!/bin/sh
echo "load nginx"
nginx -g "daemon off;" &
NGINX_PID=$!
# apelle des addcert pour ajouter les domaines 1 par 1

echo "=============== BEGIN reverse proxy ==============="
echo "search all domains"
# domains=`sh /scripts/domains_declare.sh`

echo "=============== CERTIFICATION ==============="
# echo "certbot certonly -v --webroot --agree-tos --renew-by-default --preferred-challenges http-01 --email vaxelaire.yohem@gmail.com --webroot-path /var/www/certbot$domains -n"
# certbot certonly -v --webroot --agree-tos --renew-by-default --preferred-challenges http-01 --email vaxelaire.yohem@gmail.com --webroot-path /var/www/certbot$domains -n
# kill $NGINX_PID
/scripts/domains_declare.sh

echo "=============== CRON TASK ==============="
echo "create renew cron"
echo "43 6 * * * certbot renew --post-hook \"nginx -s reload\"" >> /etc/crontabs/root

echo "=============== reload nginx ==============="
# nginx -s stop

while [ true ]; do
    # if ! ps aux | grep --quiet [n]ginx ; then
    #     exit 1
    # fi
    kill -HUP $NGINX_PID

    # Sleep for 1 week
    sleep 10 &
    SLEEP_PID=$!

    # Wait for 1 week sleep or nginx
    wait -n "$SLEEP_PID" "$NGINX_PID"
done