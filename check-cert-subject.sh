#!/usr/bin/env bash

echo -e "\nDisplay subject field of client certificate\n"

openssl x509 -in tls-certs/client.pem -inform PEM -subject -nameopt RFC2253