print("\nLogging in as X.509 client cert user\n");

db.getSiblingDB("$external").auth(
    {
        mechanism: "MONGODB-X509",
        user: "CN=admin,OU=Client,O=MongoDB,L=Austin,ST=Texas,C=US"
    }
);