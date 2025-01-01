#!/bin/bash

echo "Please make up a username for new user."
read -p "Enter the username: " username

if [ -d $username ]; then
  echo "User already exists"
  exit 1
fi

mkdir $username
cd ./$username

echo "The list of available roles"
echo "1) Secrets"
echo "2) Cluster Reader"
echo "3) Cluster Writer"
read -p "Enter the number of needed role: " user_role

case $user_role in
  1)
    $user_role='secret'
    ;;
  2)
    $user_role='cluster-reader'
    ;;
  3)
    $user_role='cluster-writer'
    ;;
  *)
    echo "Incorrect role"
    ;;
esac

openssl genrsa -out $username.key 2048
openssl req -new -key $username.key -out $username.csr -subj "/CN=$username/O=$user_role"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $username-csr
spec:
  request: $(cat $username.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
    - client auth
EOF

kubectl certificate approve $username-csr
kubectl get csr $username-csr -o jsonpath='{.status.certificate}'| base64 -d > $username.crt

kubectl config set-credentials $username --cluster=docker-desktop --client-key=$username.key --client-certificate=$username.crt --embed-certs=true
kubectl config set-context $username-context --user=$username --cluster=docker-desktop
