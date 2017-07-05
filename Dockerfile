FROM armv7/ubuntu:14.04.3
MAINTAINER Dimitar Damyanov <dimitar.damyanov@tumba.solutions>

#Install required packages
RUN     apt-get update && \
        apt-get install -y nginx && \
        apt-get install -y xz-utils curl jq lsof

RUN     service nginx stop && \
        rm /etc/nginx/sites-enabled/default

#Copy portal directory onto the container. Configure Nginx. 
RUN     mkdir -p /usr/share/node/var/config && \
        ln -snf /usr/share/node/var/config /usr/share/node/config
ADD     website.nginx /usr/share/node/config/website.nginx
RUN     ln -snf /usr/share/node/config/website.nginx /etc/nginx/sites-available/website.nginx && \
        ln -snf /etc/nginx/sites-available/website.nginx /etc/nginx/sites-enabled/website.nginx && \
        echo "daemon off;" >> /etc/nginx/nginx.conf

#Set the default working directory
WORKDIR /usr/share/node
RUN set -ex && for esdirs in logs; do \
        mkdir -p "var/$esdirs"; \
        chmod -R 666 "var/$esdirs"; \
        ln -snf "var/$esdirs" "$esdirs"; \
        chmod -R 666 "$esdirs"; \
    done

RUN set -ex && for esdirs in bin health config; do \
        mkdir -p "var/$esdirs"; \
        chmod -R 444 "var/$esdirs"; \
        ln -snf "var/$esdirs" "$esdirs"; \
        chmod -R 444 "$esdirs"; \
    done

# Add extensible healthcheck
ADD     scripts/node-healthcheck.sh /usr/local/bin/node-healthcheck
HEALTHCHECK --interval=60s --timeout=15s --retries=5 CMD [ "node-healthcheck" ]

#Start the app
ADD     scripts/nginx-harness.sh /usr/local/bin/nginx-harness
CMD     [ "nginx-harness" ]
