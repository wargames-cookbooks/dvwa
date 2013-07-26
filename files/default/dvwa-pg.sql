DROP TABLE IF EXISTS users;
CREATE TABLE users (
user_id integer UNIQUE,
first_name text,
last_name text,
username text,
password text,
avatar text,
PRIMARY KEY (user_id)
);
INSERT INTO users VALUES (1,'admin','admin','admin','5f4dcc3b5aa765d61d8327deb882cf99','dvwa/hackable/users/admin.jpg'),(2,'Gordon','Brown','gordonb','e99a18c428cb38d5f260853678922e03','dvwa/hackable/users/gordonb.jpg'),(3,'Hack','Me','1337','8d3533d75ae2c3966d7e0d4fcc69216b','dvwa/hackable/users/1337.jpg'),(4,'Pablo','Picasso','pablo','0d107d09f5bbe40cade3de5c71e9e9b7','dvwa/hackable/users/pablo.jpg'),(5,'Bob','Smith','smithy','5f4dcc3b5aa765d61d8327deb882cf99','dvwa/hackable/users/smithy.jpg');

DROP TABLE IF EXISTS guestbook;
CREATE TABLE guestbook (
  comment text,
  name text,
  comment_id SERIAL PRIMARY KEY
);
INSERT INTO guestbook VALUES (1,'This is a test comment.',1);
