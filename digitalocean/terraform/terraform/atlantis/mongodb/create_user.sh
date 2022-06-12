mongo
use admin;
db.createUser(
  {
    user: "admin",
    pwd: "Jsdhdshu43455433443",
    roles: [
      "userAdminAnyDatabase",
      "dbAdminAnyDatabase",
      "readWriteAnyDatabase"
    ]
  }
);
