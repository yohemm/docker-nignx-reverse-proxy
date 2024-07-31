#!/bin/sh
delimiter=' '
domain=''

echo $DOMAINS

date=$(date  +"%Y%m%d")

set -f
IFS="$delimiter"
set -- $DOMAINS
for i in "$@";
do
    
    # printenv "$i"
    domain=`printenv $i`
    echo "=============== Certification of $domain ==============="
    expiration=`openssl s_client -connect ${domain}:443 2>/dev/null | openssl x509 -enddate -noout`
    enddate=`date -d "${expiration:9:-4}" +"%Y%m%d"`
    echo $expiration
    echo $enddate
    if [[ -d "/etc/letsencrypt/live/$domain" ]] && [[ "${#expiration}" -ne 0 ]]
    then
        if [ $date -lt $enddate ];then
            echo "$domain is already cert; noting to do"
        else
            echo "$domain need to be renew"
            certbot renew --cert-name $domain --force-renewal
        fi
    else
        echo "create new certification for $domain"
        certbot certonly -v --webroot --agree-tos --renew-by-default --preferred-challenges http-01 --email vaxelaire.yohem@gmail.com --webroot-path /var/www/certbot -d $domain -n
    fi
    # echo "$domain"
    # domains_declare="$domains_declare -d $domain"
done
# echo "$domains_declare"