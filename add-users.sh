#!/usr/bin/env bash

echo -e "\nCreate users on the server\n"

mongo localhost/admin addusers.js
