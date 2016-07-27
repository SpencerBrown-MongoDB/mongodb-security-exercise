print("\nSetting up admin users...\n");

adb = Mongo().getDB('admin');
adb.createUser(
    {
        user: "admin",
        pwd: "password",
        roles: [
//            "userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"
            {role: "root", db: "admin"}
        ]
    }
);

xdb = Mongo().getDB('$external');
xdb.createUser(
    {
        user: "CN=admin,OU=Client,O=MongoDB,L=Austin,ST=Texas,C=US",
        roles: [
//            "userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"
            {role: "root", db: "admin"}
        ]
    }
);

adb.shutdownServer();
