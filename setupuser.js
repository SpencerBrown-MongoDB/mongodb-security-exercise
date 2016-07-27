print("\nSetting up admin user\n");
adb = Mongo().getDB('admin');
adb.createUser(
    {
        user: "admin",
        pwd: "password",
        roles: [
//            "userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"
            "root"
        ]
    }
);