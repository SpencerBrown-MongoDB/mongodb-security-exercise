#!/usr/bin/env bash

echo -e "\nCreate server for security testing\n"

mkdir -p data/md1

mongod --fork --dbpath data/md1 --logpath data/md1.log --port=27017

