#!/usr/bin/env bash

DO_IT=$1
if [ "$DO_IT" != "yes" ]; then
    echo "Creates a certificate authority and server certificate for security testing for MongoDB"
    echo "Only run this when creating a new set of certs."
    echo "./make-tls-certs yes"
    exit 1
fi


if [ -e "tls-certs" ]; then
    echo "Certs already exist"
    exit 2
fi

mkdir tls-certs
cd tls-certs

# generate CA cert and key

cfssl gencert -initca ../ca-csr.json | cfssljson -bare ca

# generate TLS server cert, cert bundle, and key

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../ca-config.json -profile=server ../server-csr.json | cfssljson -bare server
cfssl bundle -ca-bundle=ca.pem -cert=server.pem | cfssljson -bare server
cat server-key.pem server.pem > server-key-cert.pem
