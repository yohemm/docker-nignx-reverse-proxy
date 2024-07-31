#!/bin/sh
delimiter=' '
domains_declare=''
domain=''

set -f
IFS="$delimiter"
set -- $DOMAINS
for i in "$@";

do
    # printenv "$i"
    domain=`printenv $i`
    echo "Certification of $domain"
    # echo "$domain"
    certbot certonly -v --webroot --agree-tos --renew-by-default --preferred-challenges http-01 --email vaxelaire.yohem@gmail.com --webroot-path /var/www/certbot -d $domain -n
    # domains_declare="$domains_declare -d $domain"
done
# echo "$domains_declare"