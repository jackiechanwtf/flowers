-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (arm64)
--
-- Host: 127.0.0.1    Database: userdb
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `delivery_id` int NOT NULL AUTO_INCREMENT,
  `cour_id` int DEFAULT NULL,
  `del_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_place` text,
  PRIMARY KEY (`delivery_id`),
  KEY `delivery_ibfk_2` (`cour_id`),
  CONSTRAINT `delivery_ibfk_2` FOREIGN KEY (`cour_id`) REFERENCES `couriers` (`cour_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
INSERT INTO `delivery` VALUES (1,1,'2005-05-05','10:10:00','Басманная'),(2,2,'2005-05-05','05:50:00','Басманная'),(3,1,'2004-07-05','12:12:00','Бауманская'),(4,3,'2004-07-05','12:12:00','sdasd'),(5,2,'2004-02-05','12:12:00','Басманная'),(6,12,'2004-07-05','12:12:00','12'),(7,5,'2004-12-12','12:12:00','basm'),(8,1,'2004-12-12','12:12:00','wasd'),(9,1,'2004-12-12','12:12:00','wasd'),(10,4,'2004-12-12','12:12:00','wasd'),(11,15,'2004-12-12','12:12:00','wasd'),(12,1,'2004-12-12','12:12:00','wasd'),(13,2,'2004-12-12','12:12:00','wasd'),(14,NULL,'2004-02-02','12:12:00','wasd'),(15,NULL,'2004-12-12','12:12:00','wasd'),(16,NULL,'2004-12-12','12:12:00','wasd'),(17,NULL,'2024-12-08','14:00:00','Басманная'),(18,NULL,'2001-01-01','10:10:00','test'),(19,13,'2024-12-12','12:12:00','Басманная'),(20,11,'2012-12-12','12:12:00','Басманная'),(21,14,'2001-12-12','12:12:00','Басманная'),(22,NULL,'2004-12-12','12:12:00','Баума'),(23,NULL,'2004-12-17','15:00:00','Бауманская'),(24,NULL,'2024-12-19','20:20:00','Басманная'),(25,NULL,'2001-01-01','22:22:00','test'),(26,NULL,'2023-02-20','12:12:00','Басманная'),(27,14,'2024-12-27','20:00:00','Большая Почтовая');
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-29 11:29:10
