#!/usr/bin/env bash

echo -e "\nConnect to server using SSL\n"

mongo localhost/admin --ssl --sslCAFile tls-certs/ca.pem --username admin --password password

