DROP TABLE IF EXISTS `guestbook`;
CREATE TABLE `guestbook` (
  `comment_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `comment` varchar(300) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
INSERT INTO `guestbook` VALUES (1,'This is a test comment.','test');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int(6) NOT NULL DEFAULT '0',
  `first_name` varchar(15) DEFAULT NULL,
  `last_name` varchar(15) DEFAULT NULL,
  `user` varchar(15) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `avatar` varchar(70) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
INSERT INTO `users` VALUES (1,'admin','admin','admin','5f4dcc3b5aa765d61d8327deb882cf99','dvwa/hackable/users/admin.jpg'),(2,'Gordon','Brown','gordonb','e99a18c428cb38d5f260853678922e03','dvwa/hackable/users/gordonb.jpg'),(3,'Hack','Me','1337','8d3533d75ae2c3966d7e0d4fcc69216b','dvwa/hackable/users/1337.jpg'),(4,'Pablo','Picasso','pablo','0d107d09f5bbe40cade3de5c71e9e9b7','dvwa/hackable/users/pablo.jpg'),(5,'Bob','Smith','smithy','5f4dcc3b5aa765d61d8327deb882cf99','dvwa/hackable/users/smithy.jpg');
