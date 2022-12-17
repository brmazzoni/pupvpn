# pupvpn

Pop up VPN server, set up for DigitalOcean

Deps:
- make
- terraform
- ansible
- digitalocean account (with an access token)
- ssh key pair (pub key uploaded to digialocean account)

How to use:
- change user and password in ipsec.secret
- setup terraform.tfvars with the following variables:
  - region: DO region (sgp1, sfo3, blr1, ...)
  - pubkey: name of the public key registered in DO
  - domain: domain name (or subdomain, such as "vpn.example.com")
  - not necessary, but could specify a droplet_size if need more traffic
- export do access token as `TF_VAR_do_token` (other variables could also be exported)
- run `make spawn`
- after droplet is created, while the server config is running, check connectivity from your local machine (if different from control node)
- when config is completed successfully, retreive the certificate (sftp or `make showcert`) as ca_cert.pem
- install certificate on your machine (OS dependent)
- setup VPN IKEv2 configuration with domain as server address and remote ID
- check your ns registered the IP (nslookup)
- connect!

Makefile targets:
- plan: runs terraform plan
- apply: creates server and domain ressources on provider (no confirmation)
- destroy: destroys server and domain (no confirmation)
- configure: runs server configuration (ansible, needs terraform output)
- spawn: creates server and domain, then runs configuration
- respawn: destroys and recreate and configure server
- showip: display server IP
- showcert: display ca-cert.pem
