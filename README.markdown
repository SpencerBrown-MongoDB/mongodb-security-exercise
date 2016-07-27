# MongoDB security exercise

In this exercise, designed to run on OS X, we will:
* create a mongod local server
* create an admin user with superuser (root) authorization
* create a TLS Certificate Authority, and a TLS CA certificate and key
* create a TLS server certificate and key
* restart the mongod server with authentication and TLS options
* connect to the server using the mongo shell with TLS

## Prereqs

1. Install the wonderful Homebrew, if you haven't already. [See Here](http://brew.sh)
2. `brew install cfssl` -- Install the cfssl tool from CloudFlare, which acts as a Certificate Authority.
3. `brew install mongodb` -- install MongoDB
4. Clone this repo and change to its root directory.

## Create local mongod and admin user

This will start a local mongod in non-secure mode, then we add an admin user, and shut down the server.

```bash
./mkserver.sh
mongo --shell setupuser.js
use admin
db.shutdownServer()
exit
```

Take a look at the two scripts to see what they are doing!

In particular look at `setupuser.js`. 
It creates the initial admin user (username "admin", password "password") and gives it the `root` role in the admin database.
This allows the `admin` user to do *anything* on this server.

## Create the CA and the TLS server certificate and key

```bash
./make-tls-certs yes
```

1. Creates the directory `tls-certs`. Following files are placed in that directory.
2. Creates the Certificate Authority. Private key is `ca-key.pem`, CA certificate is `ca.pem`
3. Creates a TLS Server Certificate and Key. Certificate is `server.pem`, key is `server-key.pem`. 
4. Creates a Server Certificate Bundle containing the server certificate and the CA certificate. `server-bundle.pem`
5. Creates a bundle of the Server Key and Certificate, `server-key-cert.pem`.

Take a look at `ca-csr.json` to see the config for the CA, and `server-csr.json` for the config for the server certificate.

## Restart the mongod with security configured

```bash
./startserver-auth.sh
```

Read this script and see what it is doing. It turns on security with the `--auth` option, and specifies the SSL server certificate/key and the CA certificate.
It further allows clients to connect without certificates.

## Connect to the mongod with TLS and authentication

This connects to the mongod using TLS, and logs into the admin database with the superuser admin and its password.

```bash
./ssl-mongo.sh
```
Take a look at this script and the options used there!

## About TLS, PKI, certificates, and keys

A PKI (public key infrastructure) uses public key encryption technologies to provide secure (encrypted) TLS communications between client and server,
to authenticate servers to clients, and also optionally authenticate clients to servers.

Trust is established through the Certificate Authority, which issues signed certificates and their corresponding keys.
Clients and servers declare that they trust a CA by using the CA's root certificate in their configuration.
This trust means that the client trusts that the CA issued the certificate/key to the server -- and vice versa, if the client has a TLS certificate.
This trust is established without connecting to an outside authority; public key technologies are used to verify unforgeable signatures.

Certificates include a name, which cannot be spoofed. For server certificates, the name is the server's domain name or hostname.
For client certificates, the name is the user's username.

Authentication is accomplished by a carefully crafted set of messages flowing between the two parties,
with cryptographic verification on both sides. The protocol is known as TLS (Transport Layer Security).
An older version is called SSL (Secure Sockets Layer), but is deprecated.

When client Alice successfully connects to server Bob at hostname Bob.example.com using TLS, Alice knows:

* Bob's server certificate was signed by the CA that Alice trusts
* Bob's server certificate is currently valid
* Bob's server certificate is valid for the domain name `Bob.example.com`
* Bob has possession of the private key that goes with Bob's certificate
* The connection is to Bob's server and only Bob's server
* Further communications with Bob over this TLS session are encrypted

If Bob authenticates Alice's client certificate, Bob also knows:

* Alice's client certificate was signed by the CA and is currently valid
* Alice has possession of the private key that goes with Alice's client certificate
* Alice's user name is "Alice" and the CA has authorized that name

## Commercial CAs vs. rolling your own certificates

Commercial CAs charge to issue server certificates, and work with software vendors and distributors to embed their CA certificates in sofware such as Web browsers and operating systems.
Users of that software, by default, trust those CAs. Users can securely connect to servers that use commercial server certificates, without any client configuration needed.

It is straightforward to create your own CA, and sign server certificates and keys, for free using open source software, such as `cfssl` or `openssl`.
However, users need to configure your RYO CA certificate in their browser or operating system.
And they need to trust that you are legitimate. This does not work for public web sites.

However, for deployments where you control both the client and server, or for test situations, creating your own CA and signing your own server certs is fine.