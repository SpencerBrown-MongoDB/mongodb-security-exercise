#!/usr/bin/env bash

echo -e "\nStart server in auth mode for security testing\n"

mkdir -p data/md1

#mongod --fork --dbpath data/md1 --logpath data/md1.log --port=27017 --auth --sslMode requireSSL --sslPEMKeyFile tls-certs/server-key-cert.pem --sslCAFile tls-certs/ca.pem --sslAllowConnectionsWithoutCertificates
mongod --fork --dbpath data/md1 --logpath data/md1.log --port=27017 --auth --sslMode requireSSL --sslPEMKeyFile tls-certs/server-key-cert.pem --sslCAFile tls-certs/ca.pem

