# Configuring TLS usage for `mongod`, `mongos`, and `mongo`

The configurations in this note have been tested with MongoDB release 3.2.9. Earlier releases may vary somewhat, please consult the documentation for release changes. 

This note describes the configuration options that enable `mongod`, `mongos`, and the `mongo` shell to use TLS to encrypt their communications. We do not cover authentication or authorization. 

## `mongod` and `mongos`

This section details how to configure a `mongod` or `mongos` instance for TLS.

#### `--sslMode` option

The `--sslMode <value>` option controls whether and how `mongod`/`mongos` use TLS.  The default is `--sslMode disabled`. The following table describes how the `--sslMode` option affects incoming and outgoing connections:

|--sslMode option|accept incoming non-TLS?|accept incoming TLS?|use TLS for outgoing?|
|-------------|------------------------|--------------------|---------------------|
|disabled|yes|no|no|
|allowSSL|yes|yes|no|
|preferSSL|yes|yes|yes|
|requireSSL|no|yes|yes|

#### `--sslPEMKeyFile` option

The `--sslPEMKeyFile <filepath/name>` option is *required* whenever TLS is enabled; in other words, whenever the `--sslMode` option is *not* `disabled`.

The specified file *must* be an X.509 certificate and corresponding private key in PEM format. The private key *must* be first, followed by the server certificate. 

You can create the file by concatenating the private key file followed by the certificate file. An example command to do this is similar to:

```bash
cat mongodb-cert.key mongodb-cert.crt > mongodb.pem
```

When `mongod`/`mongos` acts as a server for an incoming connection, the certificate is a server certificate, and should include the server's hostname as the CN component of the subject DN, *or* as one of the SAN entries. The client connecting to the mongod server can choose to check the hostname it knows against the hostname in the server's certificate.

When `mongod`/`mongos` acts as a client, connecting to other `mongod` servers, the certificate is a client certificate.

#### `--sslCAFile` and `--sslAllowConnectionsWithoutCertificates` options

The `--sslCAFile <filepath/name>` option specifies the file containing a CA certificate chain. When `mongod`/`mongos` acts as a server for an incoming connection, the client's certificate is validated using this certificate chain.

The `--sslAllowConnectionsWithoutCertificates` allows clients to connect using TLS, but without a client certificate.

The following table details how these options affect incoming TLS connections:

| `--sslCAFile` specified? | `--sslAllowConnectionsWithoutCertificates` specified? | Client Certificate required? | Client Certificate validated? |
|--------------------------|-------------------------------------------------------|------------------------------|-------------------------------|
| No | No | No | No |
| No | Yes | No | No |
| Yes | No | Yes | Yes |
| Yes | Yes | No | Yes |

#### `--sslAllowInvalidHostnames` and `--sslAllowInvalidCertificates` options

When `mongod`/`mongos` acts as a client, connecting to other `mongod` servers, these options control how carefully the server's certificate is validated. The following table details this:

| `sslAllowInvalidHostnames` specified? | `--sslAllowInvalidCertificates` specified? | Server certificate validated | Server hostname checked |
|---------------------------------------|--------------------------------------------|------------------------------|-------------------------|
| No | No | Yes | Yes |
| No | Yes | No | No |
| Yes | No | Yes | No |
| Yes | Yes | No | No |

## `mongo`

This section details how to configure the `mongo` shell for TLS.

#### `--ssl` option

The `--ssl` option tells the `mongo` shell to use TLS to connect to `mongod`/`mongos` servers. `--ssl` is required if any of the following `mongo` shell options are specified.

#### `--sslAllowInvalidCertificates` option

This option bypasses validating the server's certificate.

#### `--sslCAFile` option

The `--sslCAFile <filepath/name>` option specifies the file containing the CA certificate chain. The server's certificate is validated using this certificate chain.

#### `--sslAllowInvalidHostnames` option

When this option is specified, the server's hostname is *not* checked against the server's certificate.