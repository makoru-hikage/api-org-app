-- MySQL dump 10.13  Distrib 5.7.12, for Win32 (AMD64)
--
-- Host: 127.0.0.1    Database: yoyonotes
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.13-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `title` varchar(50) NOT NULL,
  `content` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `note_owner_idx` (`user_id`),
  CONSTRAINT `note_owner` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` VALUES (1,1,'Testing Note Creation3','Lorem ipsum dolor sit amet... PUT NOTE','2017-04-18 22:04:10','2017-04-18 22:04:10',0),(2,5,'Data Structures','I must study the data structures. I must choose the language of my choice. I\'ll start with Perl','2017-04-25 17:40:23','2017-04-25 17:40:23',0),(3,1,'Student Registration 1st 2017-2018 ','I have to enroll early. I hate the long queues.','2017-04-25 17:41:21','2017-04-25 17:41:21',0),(4,1,'Mentally Challenged Man along Buendia Road','It seems that his last bath was like 10 years ago. As a clinically insane man, he grabs everyone\'s junks regardless of gender. He also randomly calls out random names. And sometimes, he talks like your polite average Japanese businessman, although he\'s a Filipino. And he does it fluently. ','2017-04-25 17:45:33','2017-04-25 17:45:33',0),(5,1,'Transforming Furikake Gohan','I recently watched this show titled \"Shokugeki no Souma\". He made such delicious. And looked it up on Google, the ingredients and utensils are within my means. I shall cook one.','2017-04-25 17:49:48','2017-04-25 17:49:48',0),(6,1,'Japanese \"Fu\" sounds like \"Who\"','There is no \"f\" in Japanese. They even pronounce \"coffee\" as \"co-hee\".','2017-04-25 17:49:48','2017-04-25 17:49:48',0),(7,1,'I am a NOTE to be DELETED','Test Deletion','2017-05-13 11:33:30','2017-05-13 11:33:30',0),(8,1,'I shall be converted to Todo','This content shall be changed','2017-05-13 17:39:59','2017-05-13 17:39:59',0),(9,1,'I am a TODO to be DELETED','This content shall be changed','2017-05-15 18:54:33','2017-05-15 18:54:33',0),(10,1,'Testing Note Creation2 ','Lorem ipsum dolor sit amet... POST NOTE','2017-05-15 20:37:07','2017-05-15 20:37:07',0);
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `todos`
--

DROP TABLE IF EXISTS `todos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `task` varchar(50) NOT NULL,
  `note_id` int(10) unsigned NOT NULL,
  `target_datetime` datetime DEFAULT NULL,
  `is_done` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `note_id_UNIQUE` (`note_id`),
  CONSTRAINT `note_origin` FOREIGN KEY (`note_id`) REFERENCES `notes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `todos`
--

LOCK TABLES `todos` WRITE;
/*!40000 ALTER TABLE `todos` DISABLE KEYS */;
INSERT INTO `todos` VALUES (1,'Test the creation',1,'2017-05-12 12:00:00',0,'2017-04-18 22:04:43','2017-04-18 22:04:43',0),(2,'YAY Conversion!',8,'2017-05-16 12:00:00',1,'2017-05-13 22:51:27','2017-05-13 22:51:27',0),(3,'Delete this!',9,NULL,0,'2017-05-15 18:55:00','2017-05-15 18:55:00',0);
/*!40000 ALTER TABLE `todos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `first_name` varchar(35) DEFAULT NULL,
  `last_name` varchar(35) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'cmoran','{CRYPT}$2a$04$89SbRGfDOq0SWtHz8Zdpe.RMT8VSwLxB1w62/jEKq9.PcU3IQpdyO','cmoran@gmail.com','Christina','Moran','2017-04-15 12:06:48','2017-04-15 12:06:48',0),(2,'mlitoris','','mlitoris@gmail.com','Mike','Litoris','2017-04-25 17:38:18','2017-04-25 17:38:18',0),(3,'mlester','','mlester@gmail.com','Moe','Lester','2017-04-25 17:38:18','2017-04-25 17:38:18',0),(4,'lmgardevoir','','mgardevoir@gmail.com','Lady Maine','Gardevoir','2017-04-25 17:38:18','2017-04-25 17:38:18',0),(5,'kmayford','','kmayford@gmail.com','Kirlia','Mayford','2017-04-25 17:38:18','2017-04-25 17:38:18',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-15 21:54:10
