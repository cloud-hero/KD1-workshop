#!/bin/bash

apt update
apt install nginx -y

cat <<EOF | sudo tee -a /etc/nginx/nginx.conf
stream {
    upstream k8s_masters {
        server 10.0.0.2:6443;
        server 10.1.0.2:6443;
        server 10.2.0.2:6443;
    }

    server {
        listen     6443;
        proxy_pass k8s_masters;
    }
}
EOF

nginx -s reload