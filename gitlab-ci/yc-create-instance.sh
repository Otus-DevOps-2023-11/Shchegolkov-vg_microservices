yc compute instance create \
  --name gtilab-ci-vm \
  --zone ru-central1-a \
  --cores=2 \
  --memory=4 \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=50 \
  --ssh-key ~/.ssh/ubuntu.pub
