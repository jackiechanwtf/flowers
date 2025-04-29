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

-- Dump completed on 2025-04-29 11:29:10
