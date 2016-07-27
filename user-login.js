print("\nLogging in as MongoDB defined user\n");

db.getSiblingDB("admin").auth(
    {
        user: "admin",
        pwd: "password"
    }
);