#!/usr/bin/env bash

echo -e "\nConnect to server using SSL and login as X.509 client cert defined user\n"

#mongo localhost/admin --ssl --sslCAFile tls-certs/ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem --username admin --password password
mongo --ssl --host localhost --sslCAFile tls-certs/ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem --shell x509-login.js
