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
-- Table structure for table `bouqets`
--

DROP TABLE IF EXISTS `bouqets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bouqets` (
  `bouq_id` int NOT NULL AUTO_INCREMENT,
  `bouq_num` int DEFAULT NULL,
  `bouq_name` varchar(50) DEFAULT NULL,
  `bouq_price` int DEFAULT NULL,
  PRIMARY KEY (`bouq_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bouqets`
--

LOCK TABLES `bouqets` WRITE;
/*!40000 ALTER TABLE `bouqets` DISABLE KEYS */;
INSERT INTO `bouqets` VALUES (1,3,'One',1100),(2,4,'Two',1200),(3,3,'Three',1300),(4,3,'Four',1400),(5,3,'Five',1500),(6,3,'Six',1600),(7,123,'Seven',1700);
/*!40000 ALTER TABLE `bouqets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `cl_id` int NOT NULL,
  `cl_name` varchar(50) DEFAULT NULL,
  `cl_adress` text,
  `cl_phone` int DEFAULT NULL,
  `cl_regist` date DEFAULT NULL,
  PRIMARY KEY (`cl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'Alex','adr1',8129191,'2024-03-20'),(2,'Tim','adr2',8919191,'2013-07-01'),(3,'Joe','adr3',8120123,'2013-06-12'),(4,'Mark','adr4',847128,'2017-05-05');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compos`
--

DROP TABLE IF EXISTS `compos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compos` (
  `compos_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `bouq_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`compos_id`),
  KEY `order_id` (`order_id`),
  KEY `bouq_id` (`bouq_id`),
  CONSTRAINT `compos_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `compos_ibfk_2` FOREIGN KEY (`bouq_id`) REFERENCES `bouqets` (`bouq_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compos`
--

LOCK TABLES `compos` WRITE;
/*!40000 ALTER TABLE `compos` DISABLE KEYS */;
INSERT INTO `compos` VALUES (1,1,1,3),(2,2,2,2),(3,3,3,2),(4,3,2,1),(5,3,4,1),(6,5,4,2),(7,7,5,1),(8,8,3,2),(9,9,4,2),(10,1,5,1),(11,1,1,4),(12,6,2,3),(13,7,5,1),(14,7,5,2),(15,2,2,2),(16,2,2,2),(17,10,3,3),(18,27,1,1),(19,28,1,1),(20,28,2,1),(21,29,2,1),(22,29,3,2),(23,29,4,3),(24,30,1,1),(25,30,2,1),(26,31,4,1),(27,31,5,1),(28,32,1,1),(29,32,2,1),(30,33,1,2),(31,33,3,1),(32,34,1,1),(33,34,2,1),(34,35,1,1),(35,35,2,1),(36,36,6,1),(37,37,1,1),(38,38,2,1),(39,39,3,1),(40,39,7,1);
/*!40000 ALTER TABLE `compos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_report` AFTER INSERT ON `compos` FOR EACH ROW BEGIN
DECLARE bou_id, bou_price, kolichestvo INT;
DECLARE order_month, order_year INT;

SELECT YEAR(orders.creation_date), MONTH(orders.creation_date)
INTO order_year, order_month
FROM orders
WHERE order_id = NEW.order_id;

select distinct new.bouq_id, bouq_price into bou_id, bou_price
from compos JOIN bouqets using(bouq_id)
where bouq_id = NEW.bouq_id;

insert into report values(bou_id, new.quantity, bou_price*NEW.quantity, order_month, order_year)
on duplicate key update
kolvo = kolvo + new.quantity,
total_price = total_price + bou_price*NEW.quantity;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `courier_report`
--

DROP TABLE IF EXISTS `courier_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courier_report` (
  `cour_id` int NOT NULL,
  `cour_name` varchar(60) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `rep_month` int NOT NULL,
  `rep_year` int NOT NULL,
  PRIMARY KEY (`cour_id`,`rep_month`,`rep_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courier_report`
--

LOCK TABLES `courier_report` WRITE;
/*!40000 ALTER TABLE `courier_report` DISABLE KEYS */;
INSERT INTO `courier_report` VALUES (13,'Крона',1,'2021-08-10',12,2024),(14,'Тим',1,'2020-03-20',12,2024);
/*!40000 ALTER TABLE `courier_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `couriers`
--

DROP TABLE IF EXISTS `couriers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `couriers` (
  `cour_id` int NOT NULL AUTO_INCREMENT,
  `cour_birth` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `cour_phone` text,
  `cour_adress` text,
  `cour_status` enum('free','busy') DEFAULT 'free',
  `cour_name` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`cour_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `couriers`
--

LOCK TABLES `couriers` WRITE;
/*!40000 ALTER TABLE `couriers` DISABLE KEYS */;
INSERT INTO `couriers` VALUES (1,'1977-01-01','2011-01-01',NULL,'8191921','adr1','busy','Виктор'),(2,'2013-02-02','2019-02-02',NULL,'9891283','adr2','busy','Цой'),(3,'2004-07-07','2014-05-05',NULL,'1230981','adr3','free','Пушкин'),(4,'2000-07-05','2017-01-01','2018-09-09','8491823','adr4','free','Степа'),(5,'2000-01-01','2017-01-01',NULL,'812312','adr5','free','Джамшут'),(11,'1990-05-12','2023-01-01',NULL,'12345670','Москва','free','Денис'),(12,'1985-03-20','2022-05-15',NULL,'23456789','Москва','free','Бизнес'),(13,'1992-11-02','2021-08-10',NULL,'34567892','Москва','free','Крона'),(14,'1988-07-18','2020-03-20',NULL,'45678923','Москва','busy','Тим'),(15,'1995-01-30','2023-06-25',NULL,'56789034','Москва','free','Джо'),(16,'2004-07-05','2024-01-01',NULL,'891910','Тюмень','free','Байден');
/*!40000 ALTER TABLE `couriers` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `external_user`
--

DROP TABLE IF EXISTS `external_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_group` varchar(40) DEFAULT NULL,
  `login` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_client_user` FOREIGN KEY (`user_id`) REFERENCES `clients` (`cl_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `external_user`
--

LOCK TABLES `external_user` WRITE;
/*!40000 ALTER TABLE `external_user` DISABLE KEYS */;
INSERT INTO `external_user` VALUES (1,NULL,'login1','pass1'),(2,NULL,'login2','pass2'),(3,NULL,'login3','pass3'),(4,NULL,'tim','glagolev');
/*!40000 ALTER TABLE `external_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internal_user`
--

DROP TABLE IF EXISTS `internal_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internal_user` (
  `user_id` int NOT NULL,
  `user_group` varchar(40) DEFAULT NULL,
  `login` varchar(40) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internal_user`
--

LOCK TABLES `internal_user` WRITE;
/*!40000 ALTER TABLE `internal_user` DISABLE KEYS */;
INSERT INTO `internal_user` VALUES (1,'admin','admin','admin'),(2,'manager','manag1','manag1'),(3,'manager','test','test'),(4,'dispatcher','dis1','dis1');
/*!40000 ALTER TABLE `internal_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `cl_id` int DEFAULT NULL,
  `creation_date` date NOT NULL,
  `delivery_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `cl_id` (`cl_id`),
  KEY `delivery_id` (`delivery_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`cl_id`) REFERENCES `clients` (`cl_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`delivery_id`) REFERENCES `delivery` (`delivery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'2010-01-01',1),(2,2,'2020-03-02',1),(3,3,'2020-03-01',1),(4,4,'2020-06-02',1),(5,2,'2020-07-01',1),(6,3,'2020-08-01',1),(7,1,'2010-01-01',1),(8,2,'2020-02-02',1),(9,3,'2020-07-28',1),(10,2,'2020-02-03',1),(13,1,'2024-12-04',1),(14,1,'2024-12-04',2),(15,1,'2024-12-06',3),(16,1,'2024-12-06',4),(17,1,'2024-12-06',5),(18,1,'2024-12-06',6),(19,1,'2024-12-06',7),(20,1,'2024-12-06',8),(21,1,'2024-12-06',9),(22,1,'2024-12-06',10),(23,1,'2024-12-06',11),(24,1,'2024-12-06',12),(25,1,'2024-12-06',13),(26,1,'2024-12-06',14),(27,1,'2024-12-06',15),(28,1,'2024-12-06',16),(29,1,'2024-12-08',17),(30,1,'2024-12-08',18),(31,1,'2024-12-12',19),(32,1,'2024-12-12',20),(33,1,'2024-12-12',21),(34,1,'2024-12-13',22),(35,1,'2024-12-17',23),(36,1,'2024-12-19',24),(37,1,'2024-12-19',25),(38,1,'2024-12-19',26),(39,1,'2024-12-27',27);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `bouq_id` int NOT NULL,
  `kolvo` int NOT NULL,
  `total_price` int NOT NULL,
  `rep_mon` int NOT NULL,
  `rep_year` int NOT NULL,
  PRIMARY KEY (`bouq_id`,`rep_mon`,`rep_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (1,7,7700,1,2010),(5,5,7500,1,2020);
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'userdb'
--
/*!50003 DROP PROCEDURE IF EXISTS `courier_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `courier_report`(in_mon INT, in_year INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cour_id INT;
    DECLARE cour_name VARCHAR(60);
    DECLARE start_date DATE;
    DECLARE kolvo INT;

    DECLARE c1 CURSOR FOR 
        SELECT couriers.cour_id, couriers.cour_name, couriers.start_date, COUNT(orders.order_id) AS kolvo
        FROM couriers
        JOIN delivery ON couriers.cour_id = delivery.cour_id
        JOIN orders ON delivery.delivery_id = orders.delivery_id
        WHERE YEAR(delivery.del_date) = in_year AND MONTH(delivery.del_date) = in_mon
        GROUP BY couriers.cour_id, couriers.cour_name, couriers.start_date;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

    OPEN c1;

    FETCH c1 INTO cour_id, cour_name, start_date, kolvo;

    WHILE done = 0 DO
        INSERT INTO userdb.courier_report (cour_id, cour_name, quantity, start_date, rep_month, rep_year) 
        VALUES (cour_id, cour_name, kolvo, start_date, in_mon, in_year);

        FETCH c1 INTO cour_id, cour_name, start_date, kolvo;
    END WHILE;

    CLOSE c1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `date_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `date_report`(in_mon INT, in_year INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE bou_id, kolvo, total_pr INT;

    DECLARE c1 CURSOR FOR 
		SELECT bouq_id, sum(compos.quantity), sum(bouq_price*compos.quantity)
		FROM orders join compos using (order_id) join bouqets using(bouq_id) 
		WHERE YEAR(creation_date) = in_year AND MONTH(creation_date) = in_mon
        group by bouq_id;

	DECLARE CONTINUE HANDLER FOR NOT FOUND set done=1;
    
    open c1;
    while done=0 do
		fetch c1 into bou_id, kolvo, total_pr;
        if done=0 then 
			insert into userdb.report values (bou_id, kolvo, total_pr, in_mon, in_year);
        end if;
    end while;
    close c1;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-29 11:28:10
