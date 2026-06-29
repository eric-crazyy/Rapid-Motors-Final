/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.7.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: rapid_motors
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cars`
--

DROP TABLE IF EXISTS `cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cars` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `manufacturer` varchar(255) NOT NULL,
  `year` int(11) NOT NULL,
  `category` enum('oldtimer','luxury','supercar') NOT NULL,
  `price` decimal(16,2) NOT NULL,
  `horsepower` int(11) NOT NULL,
  `engine` varchar(255) NOT NULL,
  `top_speed` decimal(5,1) NOT NULL,
  `acceleration` decimal(4,2) NOT NULL,
  `description` text NOT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cars`
--

LOCK TABLES `cars` WRITE;
/*!40000 ALTER TABLE `cars` DISABLE KEYS */;
INSERT INTO `cars` VALUES
(1,'Chevelle SS','Chevrolet',1970,'oldtimer',45000000.00,450,'7.4L V8 LS6',210.0,5.40,'Az amerikai \"muscle car\" éra egyik legmeghatározóbb darabja. Brutális erő és összetéveszthetetlen forma.',1,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(2,'300SL Gullwing','Mercedes-Benz',1955,'oldtimer',432000000.00,215,'3.0L I6',260.0,8.80,'Ikonikus sirályszárnyú ajtókkal rendelkező sportkocsi. Az 50-es évek szuperautója.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(3,'E-Type Series 1','Jaguar',1961,'oldtimer',102000000.00,265,'3.8L I6',241.0,7.10,'Enzo Ferrari szerint a legszebb autó amit valaha készítettek. Brit elegancia és teljesítmény.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(4,'250 GTO','Ferrari',1962,'oldtimer',17280000000.00,300,'3.0L V12',280.0,6.10,'A világ legértékesebb autója. Mindössze 36 darab készült belőle.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(5,'911 Carrera RS 2.7','Porsche',1973,'oldtimer',342000000.00,210,'2.7L Flat-6',245.0,5.80,'A legenda kezdete. Az első RS kacsafarokkal és ikonikus dizájnnal.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(6,'Chiron','Bugatti',2021,'supercar',1080000000.00,1500,'8.0L W16 Quad-Turbo',420.0,2.40,'A Bugatti hiperautó megtestesítője. 1500 lóerő, négyturbós W16 motor és elektronikusan korlátozott 420 km/h-s végsebesség.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(7,'SF90 Stradale','Ferrari',2023,'supercar',225000000.00,1000,'4.0L V8 + 3 E-Motor',340.0,2.50,'Ferrari első plug-in hybrid szuperautója. 1000 lóerő kombinált teljesítménnyel.',1,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(8,'Aventador SVJ','Lamborghini',2023,'supercar',206000000.00,770,'6.5L V12',350.0,2.80,'A természetesen szívott V12 búcsúszimfóniája. Nürburgring rekorder.',1,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(9,'720S','McLaren',2024,'supercar',113400000.00,720,'4.0L V8 Twin-Turbo',341.0,2.90,'McLaren szupersorozatának gyöngyszeme. Káprázatos teljesítmény és dizájn.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(10,'918 Spyder','Porsche',2023,'supercar',648000000.00,887,'4.6L V8 + 2 E-Motor',345.0,2.60,'A szent hármasság német tagja. Elektromos és benzines erő tökéletes szimbiózisa.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(11,'AMG One','Mercedes-AMG',2024,'supercar',972000000.00,1063,'1.6L V6 Turbo Hybrid',352.0,2.90,'F1 motor az utcán. Lewis Hamilton technológiája civilian változatban.',1,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(12,'Huayra BC','Pagani',2023,'supercar',1224000000.00,800,'6.0L V12 Twin-Turbo',370.0,2.80,'Művészet négy keréken. Benny Caiola tiszteletére készült limitált szériás csoda.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(13,'Gemera','Koenigsegg',2024,'supercar',612000000.00,1700,'2.0L I3 + 3 E-Motor',400.0,1.90,'A világ első négyüléses megahyperautója. Családi szuperautó új definíciója.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(14,'Valkyrie','Aston Martin',2023,'supercar',1152000000.00,1160,'6.5L V12 Hybrid',402.0,2.50,'Adrian Newey F1 mérnök remeke. Szélcsatorna és utca közötti határ.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(15,'GT2 RS','Porsche',2024,'supercar',125000000.00,700,'3.8L Flat-6 Twin-Turbo',340.0,2.70,'A leggyorsabb utcai legális 911. Nürburgring pályarekord-tartó.',1,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(16,'Senna','McLaren',2023,'supercar',396000000.00,800,'4.0L V8 Twin-Turbo',340.0,2.80,'Ayrton Senna emlékére. Tiszta pályaautó karakter utcai rendszámmal.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(17,'Revuelto','Lamborghini',2024,'supercar',218800000.00,1015,'6.5L V12 + 3 E-Motor',350.0,2.50,'Lamborghini első V12 plug-in hybridja. Az Aventador utódja.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(18,'Jesko Absolut','Koenigsegg',2024,'supercar',1080000000.00,1600,'5.0L V8 Twin-Turbo',531.0,2.50,'Koenigsegg végsebességre optimalizált hyperautója. Elméleti maximum: 531 km/h.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(19,'LaFerrari','Ferrari',2023,'supercar',1152000000.00,963,'6.3L V12 Hybrid',350.0,2.40,'A szent hármasság olasz tagja. Ferrari első hibrid hyperautója.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(20,'Venom F5','Hennessey',2024,'supercar',756000000.00,1817,'6.6L V8 Twin-Turbo',484.0,2.60,'Amerikai hypercar. Cél: 500 km/h megdöntése.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(21,'DBX707','Aston Martin',2024,'luxury',84600000.00,707,'4.0L V8 Twin-Turbo',310.0,3.30,'A világ legerősebb luxus SUV-ja. Brit elegancia és brutális teljesítmény.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(22,'Speedtail','McLaren',2023,'luxury',810000000.00,1070,'4.0L V8 Hybrid',403.0,2.90,'A McLaren F1 szellemi utódja. Központi vezetőülés, három ülés.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(23,'Battista','Pininfarina',2024,'luxury',792000000.00,1900,'Quad Electric Motor',350.0,1.90,'Tisztán elektromos hyperscar olasz dizájnnal. 1900 lóerő csendben.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(24,'Urus Performante','Lamborghini',2024,'luxury',93600000.00,666,'4.0L V8 Twin-Turbo',306.0,3.30,'Szuper SUV Lamborghini módra. Pályaautó képességek családi csomagtartóval.',0,'2026-04-27 10:07:20','2026-04-27 10:07:20'),
(25,'SLS AMG GT','Mercedes-Benz',2013,'luxury',75000000.00,583,'6.2L V8',320.0,3.70,'Ikonikus sirályszárnyas szuperautó brutális V8 hanggal és klasszikus AMG karakterrel.',1,'2026-04-27 10:07:20','2026-04-27 10:07:20');
/*!40000 ALTER TABLE `cars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'create_cache_table',1),
(2,'create_cars_table',1),
(3,'create_jobs_table',1),
(4,'create_personal_access_tokens_table',1),
(5,'create_users_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES
(1,'App\\Models\\User',1,'auth_token','d9e582a43c483bf03ea01f93ce6ee795c949533f0f78e3b82b9ec71000e5dc8a','[\"*\"]','2026-04-27 10:11:29',NULL,'2026-04-27 10:10:11','2026-04-27 10:11:29');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
('yuAWaefqdGqGnmsHO018qklBAKf1ZHcVpT2bPzUu',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibFZhanVaUjBJc095eEFLZkhrMEVabVAzdmdFTDFVUVoyWWFIQWt6dyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvY2Fycz9mZWF0dXJlZD10cnVlIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1777292086);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Admin','admin@rapidmotors.com',NULL,'$2y$12$CIfCZMq6dRVjBL9t7tJeluif5uJUsgfjRlqc2ni4tW/daX3cQGoGC',1,NULL,'2026-04-27 10:07:20','2026-04-27 10:07:20');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'rapid_motors'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-27 14:15:49
