docker-machine create \
    --driver generic \
    --generic-ip-address=62.84.115.43 \
    --generic-ssh-user yc-user \
    --generic-ssh-key ~/.ssh/ubuntu \
    docker-gitlab
