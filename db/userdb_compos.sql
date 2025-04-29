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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-29 11:29:10
