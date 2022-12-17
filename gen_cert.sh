#!/bin/bash

# cleanup
rm -rf pki

# Create certificate authority
mkdir -p pki/{cacerts,certs,private}
chmod 700 pki

## Root key
pki --gen --type rsa --size 4096 --outform pem > pki/private/ca-key.pem

## Root certificate authority
pki --self --ca --lifetime 3650 --in pki/private/ca-key.pem \
    --type rsa --dn "CN=PUPVPN CA" --outform pem > pki/cacerts/ca-cert.pem

# Create certificate for the VPN server

## Private key for the server
pki --gen --type rsa --size 4096 --outform pem > pki/private/server-key.pem

## Server certificate
pki --pub --in pki/private/server-key.pem --type rsa \
    | pki --issue --lifetime 1825 \
        --cacert pki/cacerts/ca-cert.pem \
        --cakey pki/private/ca-key.pem \
        --dn "CN=$1" --san $1 \
        --flag serverAuth --flag ikeIntermediate --outform pem \
    >  pki/certs/server-cert.pem


# Move the files in place
#cp -r ~/pki/* /etc/ipsec.d/

echo Done generating certificates for $1
