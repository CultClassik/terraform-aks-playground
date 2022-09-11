#!/bin/bash

cert_dir=../certs

mkdir "$cert_dir"

openssl req -x509 -sha256 -nodes -days 730 -newkey rsa:2048 -keyout "${cert_dir}/privateKey.key" -out "${cert_dir}/certificate.crt"

openssl pkcs12 -export -keypbe NONE -certpbe NONE -inkey "${cert_dir}/privateKey.key" -in "${cert_dir}/certificate.crt" -out "${cert_dir}/certificate.pfx"

