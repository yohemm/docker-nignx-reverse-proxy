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
    change=0

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
            change=1
        fi
    else
        echo "create new certification for $domain"
        certbot certonly -v --webroot --agree-tos --renew-by-default --preferred-challenges http-01 --email vaxelaire.yohem@gmail.com --webroot-path /var/www/certbot -d $domain -n
        change=1
    fi

    if [ change -eq 1 ] =; then
        echo "changement de certificat effectuer correctement"
        if [ $domain == "plugins.minepiece.fr" ]; then
            if [ ! -d "/etc/letsencrypt/live/$domain/mongo/" ]; then
                mkdir "/etc/letsencrypt/live/$domain/mongo/"
            fi

            cat /etc/letsencrypt/live/$domain/privkey.pem /etc/letsencrypt/live/$domain/fullchain.pem > /etc/letsencrypt/live/$domain/mongo/mongod.pem
            cat /etc/letsencrypt/live/$domain/chain.pem > /etc/letsencrypt/live/$domain/mongo/ca.crt

            echo "MAJ mongo files effectué"
        fi
    fi
    # echo "$domain"
    # domains_declare="$domains_declare -d $domain"
done
# echo "$domains_declare"