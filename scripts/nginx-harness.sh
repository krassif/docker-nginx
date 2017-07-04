#!/usr/bin/env bash

set -eo pipefail

# Get running container's IP
HOST=`hostname --ip-address`

# Setup site name for logging
if [ -z "$SITE" ]; then
        echo "No site name specified, preserving default one ('nginx-site')"
else
        sed -i -e "s/nginx-site/$SITE/" /etc/nginx/sites-available/website.nginx
fi;

# Setup site name for logging
if [ -z "$PORT" ]; then
        echo "No port specified, preserving default one (80)."
else
        sed -i -e "s/PORT/$PORT/" /etc/nginx/sites-available/website.nginx
fi;

# start engine X
( service nginx start ) || exit 1

# return normal exit
exit 0
