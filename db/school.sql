-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: english_school
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.1

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
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `phones` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `is_main` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_addresses_on_active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'вул. Мулярська 2а, 4й поверх бібліотека ім.Лесі Українки','eng.speak.club@gmail.com','063 74 86 032',1,'2015-11-10 11:51:57','2015-11-10 12:53:49','ОСНОВНА АДРЕСА',1),(2,'Україна, місто Львів, вулиця ВІРМЕНСЬКА 26, арт-галерея IconArt','','',1,'2015-11-10 12:55:43','2015-11-16 17:36:37','ЗАНЯТТЯ ГРУПИ ART AND CULTURE GROUP',0);
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_modules`
--

DROP TABLE IF EXISTS `b1_admin_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ico` varchar(20) NOT NULL DEFAULT 'fa-file',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `name_uk` varchar(50) NOT NULL,
  `name_en` varchar(50) NOT NULL,
  `controller` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `hidden` tinyint(1) DEFAULT '0',
  `show_in_list` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_b1_admin_modules_on_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_modules`
--

LOCK TABLES `b1_admin_modules` WRITE;
/*!40000 ALTER TABLE `b1_admin_modules` DISABLE KEYS */;
INSERT INTO `b1_admin_modules` VALUES (1,'fa-shield',0,'Настройки','Настройки','settings','2015-02-11 15:52:48','2015-02-11 15:52:48',0,0,1),(2,'fa-file',1,'Модули','Модули','modules','2015-02-11 15:52:48','2015-02-11 15:52:48',0,0,1),(11,'fa-file',1,'Роли доступа','Роли доступа','roles','2015-02-11 15:52:48','2015-02-18 16:16:07',1,0,1),(14,'fa-file',1,'Права доступа','Права доступа','permissions','2015-02-11 15:52:49','2015-02-11 15:52:49',2,0,1),(17,'fa-file',1,'Администраторы','Администраторы','admins','2015-02-11 15:52:49','2015-02-11 15:52:49',3,0,1),(40,'emails',1,'Шаблоны Email','Шаблоны Email','emails','2015-07-03 08:36:10','2015-07-03 08:36:10',0,0,1),(45,'fa-edit',0,'Школа','Школа','school','2015-11-09 20:00:41','2015-11-09 20:00:41',0,0,1),(46,'courses',45,'Курси','Курси','courses','2015-11-09 20:01:00','2015-11-09 20:01:00',0,0,1),(48,'fa-briefcase',0,'Загальне','Загальне','content','2015-11-09 21:23:27','2015-11-09 21:23:27',0,0,1),(49,'teachers',48,'Викладачі','Викладачі','teachers','2015-11-09 21:23:51','2015-11-09 21:23:51',0,0,1),(50,'vacancies',48,'Вакансії','Вакансії','vacancies','2015-11-09 21:24:30','2015-11-09 21:24:30',0,0,1),(51,'photos',48,'Галерея','Галерея','photos','2015-11-09 21:44:41','2015-11-09 21:44:41',0,0,1),(52,'addresses',1,'Адреси','Адреси','addresses','2015-11-10 11:41:14','2015-11-10 11:41:14',0,0,1),(53,'partners',48,'Партнери','Партнери','partners','2015-11-10 12:19:37','2015-11-10 12:19:37',0,0,1),(54,'fa-envelope',0,'Блог','Блог','blog','2015-11-10 18:11:54','2015-11-10 18:11:54',0,0,1),(55,'fa-envelope',54,'Блог','Блог','pages','2015-11-10 18:23:45','2015-11-10 18:23:45',0,0,1),(56,'fa-bullhorn',0,'Клуб','Клуб','club','2015-11-11 08:00:43','2015-11-11 08:00:43',0,0,1),(57,'courses',56,'Курси','Курси','courses','2015-11-11 08:01:30','2015-11-11 08:01:30',0,0,1),(58,'users',56,'Підписники','Підписники','users','2015-11-11 09:17:49','2015-11-11 09:17:49',0,0,1),(59,'users',45,'Підписники','Підписники','users','2015-11-11 09:18:05','2015-11-11 09:18:05',0,0,1),(60,'users',54,'Підписники','Підписники','users','2015-11-11 09:18:21','2015-11-11 09:18:21',0,0,1),(61,'lessons',56,'Заняття','Заняття','lessons','2015-11-13 13:56:25','2015-11-13 13:56:25',0,0,1),(62,'lessons',45,'Заняття','Заняття','lessons','2015-11-16 12:34:15','2015-11-16 12:34:15',0,0,1),(63,'cvscvs',48,'Резюме','Резюме','cvs','2015-11-16 12:35:12','2015-11-16 12:35:12',0,0,1);
/*!40000 ALTER TABLE `b1_admin_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_modules_roles`
--

DROP TABLE IF EXISTS `b1_admin_modules_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_modules_roles` (
  `role_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  UNIQUE KEY `b1_admin_modules_roles_index` (`module_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_modules_roles`
--

LOCK TABLES `b1_admin_modules_roles` WRITE;
/*!40000 ALTER TABLE `b1_admin_modules_roles` DISABLE KEYS */;
INSERT INTO `b1_admin_modules_roles` VALUES (1,1),(1,2),(1,11),(1,14),(1,17),(1,40),(1,45),(1,46),(1,48),(1,49),(1,50),(1,51),(1,52),(1,53),(1,54),(1,55),(1,56),(1,57),(1,58),(1,59),(1,60),(1,61),(1,62),(1,63);
/*!40000 ALTER TABLE `b1_admin_modules_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_permissions`
--

DROP TABLE IF EXISTS `b1_admin_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `desc_uk` varchar(50) NOT NULL,
  `desc_en` varchar(50) NOT NULL,
  `module_id` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_b1_admin_permissions_on_module_id` (`module_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_permissions`
--

LOCK TABLES `b1_admin_permissions` WRITE;
/*!40000 ALTER TABLE `b1_admin_permissions` DISABLE KEYS */;
INSERT INTO `b1_admin_permissions` VALUES (1,'Просмотр модулей','Просмотр модулей',2,'index','2015-02-11 15:52:49','2015-02-18 16:19:22'),(2,'Просмотр ролей доступа','Просмотр ролей доступа',11,'index','2015-02-11 15:52:50','2015-02-11 16:09:18'),(3,'Просмотр прав доступа','Просмотр прав доступа',14,'index','2015-02-11 15:52:50','2015-02-11 16:09:52'),(4,'Просмотр администраторов','Просмотр администраторов',17,'index','2015-02-11 15:52:50','2015-02-11 16:10:03'),(5,'Просмотр логов админ панели','Просмотр логов админ панели',3,'index','2015-02-11 15:52:50','2015-02-11 16:10:20'),(6,'Просмотр стран','Просмотр стран',12,'index','2015-02-11 15:52:50','2015-02-11 16:11:05'),(7,'Просмотр городов','Просмотр городов',16,'index','2015-02-11 15:52:50','2015-02-11 15:52:50'),(8,'Просмотр аэропортов','Просмотр аэропортов',18,'index','2015-02-11 15:52:50','2015-02-11 16:08:37'),(9,'Просмотр континетов','Просмотр континетов',4,'index','2015-02-11 15:52:50','2015-02-11 16:09:31'),(10,'Просмотр факов','Просмотр факов',5,'index','2015-02-11 15:52:50','2015-02-11 16:08:49'),(11,'Просмотр списка ОТА','Просмотр списка ОТА',6,'index','2015-02-11 15:52:50','2015-02-11 16:09:42'),(12,'Просмотр списка','Просмотр списка',13,'index','2015-02-11 15:52:50','2015-06-30 12:48:38'),(13,'Просмотр списка','Просмотр списка',7,'index','2015-02-11 15:52:50','2015-02-11 15:52:50'),(14,'Просмотр списка','Просмотр списка',9,'index','2015-02-11 15:52:51','2015-02-11 15:52:51'),(15,'Просмотр списка','Просмотр списка',8,'index','2015-02-11 15:52:51','2015-02-11 15:52:51'),(16,'Просмотр статистики','Просмотр статистики',23,'index','2015-02-18 17:20:48','2015-02-18 17:20:48'),(17,'Просмотр логов фронта','Просмотр логов фронта',24,'index','2015-02-23 19:06:36','2015-02-23 19:06:36'),(18,'цуайцацйу','ацйуацйуауац',25,'index','2015-04-07 12:17:29','2015-04-07 12:17:29'),(19,'Просмотр','Просмотр',26,'index','2015-04-07 15:34:07','2015-04-07 15:34:07'),(20,'Просмотр настроек','Просмотр настроек',27,'index','2015-04-09 07:42:13','2015-04-09 07:42:13'),(21,'Просмотр списка','Просмотр списка',28,'index','2015-05-04 12:31:48','2015-06-30 12:47:33'),(22,'Просмотр списка','Просмотр списка',30,'index','2015-06-30 14:04:47','2015-06-30 14:04:47'),(23,'Просмотр списка','Просмотр списка',31,'index','2015-06-30 15:12:59','2015-06-30 15:12:59'),(24,'Просмотр типов','Просмотр типов',32,'index','2015-06-30 16:32:17','2015-06-30 16:32:17'),(25,'Просмотр списка сервисов','Просмотр списка сервисов',33,'index','2015-07-01 07:41:41','2015-07-01 07:41:41'),(26,'Просмотр списка','Просмотр списка',34,'index','2015-07-01 08:40:45','2015-07-01 08:40:45'),(27,'Просмотр списка','Просмотр списка',35,'index','2015-07-01 10:21:24','2015-07-01 10:21:24'),(28,'Просмотр списка','Просмотр списка',36,'index','2015-07-01 10:22:45','2015-07-01 10:22:45'),(29,'Просмотр списка','Просмотр списка',37,'index','2015-07-01 12:55:21','2015-07-01 12:55:21'),(30,'Просмотр списка','Просмотр списка',38,'index','2015-07-01 12:55:30','2015-07-01 12:55:30'),(31,'Просмотр списка отелей','Просмотр списка отелей',39,'index','2015-07-01 13:28:10','2015-07-01 13:28:10'),(32,'Просмотр списка','Просмотр списка',40,'index','2015-07-03 08:45:40','2015-07-03 08:45:40'),(33,'Просмотр списка бронирований','Просмотр списка бронирований',42,'index','2015-07-03 12:33:49','2015-07-03 12:33:49'),(34,'Просмотр списка заявок','Просмотр списка заявок',43,'index','2015-07-03 12:40:06','2015-07-03 12:40:06'),(35,'Создание доступа','Создание доступа',44,'create_admin','2015-09-16 13:21:36','2015-09-16 13:21:36'),(36,'просмотр списка контрактов','просмотр списка контрактов',44,'index','2015-09-16 13:22:55','2015-09-16 13:22:55'),(37,'Просмотр списка','Просмотр списка',46,'index','2015-11-09 20:02:35','2015-11-09 20:02:35'),(38,'Просмотр списка','Просмотр списка',47,'index','2015-11-09 20:46:25','2015-11-09 20:46:25'),(39,'Перегляд списку','Перегляд списку',49,'index','2015-11-09 21:24:54','2015-11-09 21:24:54'),(40,'Перегляд списку','Перегляд списку',50,'index','2015-11-09 21:25:07','2015-11-09 21:25:07'),(41,'Просмотр списка','Просмотр списка',51,'index','2015-11-10 10:19:24','2015-11-10 10:19:24'),(42,'Перегляд списку','Перегляд списку',52,'index','2015-11-10 11:41:30','2015-11-10 11:41:30'),(43,'Перегляд списку','Перегляд списку',53,'index','2015-11-10 12:20:33','2015-11-10 12:20:33'),(44,'Перегляд списку','Перегляд списку',55,'index','2015-11-10 18:24:22','2015-11-10 18:24:22'),(45,'Перегляд списку','Перегляд списку',57,'index','2015-11-11 08:09:12','2015-11-11 08:09:12'),(46,'Перегляд списку','Перегляд списку',60,'index','2015-11-11 09:19:04','2015-11-11 09:19:04'),(47,'Перегляд списку','Перегляд списку',59,'index','2015-11-11 09:19:17','2015-11-11 09:19:17'),(48,'Перегляд списку','Перегляд списку',58,'index','2015-11-11 09:19:23','2015-11-11 09:19:23'),(49,'Перегляд списку','Перегляд списку',61,'index','2015-11-13 13:56:43','2015-11-13 13:56:43'),(50,'Перегляд','Перегляд',62,'index','2015-11-16 12:34:28','2015-11-16 12:34:28'),(51,'Резюме','Резюме',63,'index','2015-11-16 12:54:28','2015-11-16 12:54:28');
/*!40000 ALTER TABLE `b1_admin_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_permissions_roles`
--

DROP TABLE IF EXISTS `b1_admin_permissions_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_permissions_roles` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  UNIQUE KEY `b1_admin_permissions_roles_index` (`permission_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_permissions_roles`
--

LOCK TABLES `b1_admin_permissions_roles` WRITE;
/*!40000 ALTER TABLE `b1_admin_permissions_roles` DISABLE KEYS */;
INSERT INTO `b1_admin_permissions_roles` VALUES (1,1),(1,2),(1,3),(1,4),(1,32),(1,37),(1,39),(1,40),(1,41),(1,42),(1,43),(1,44),(1,45),(1,46),(1,47),(1,48),(1,49),(1,50),(1,51);
/*!40000 ALTER TABLE `b1_admin_permissions_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_roles`
--

DROP TABLE IF EXISTS `b1_admin_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `desc_uk` varchar(50) NOT NULL,
  `desc_en` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_roles`
--

LOCK TABLES `b1_admin_roles` WRITE;
/*!40000 ALTER TABLE `b1_admin_roles` DISABLE KEYS */;
INSERT INTO `b1_admin_roles` VALUES (1,'Admin','Can access to admin panel','Can access to admin panel','2015-02-11 15:52:49','2015-02-11 15:52:49');
/*!40000 ALTER TABLE `b1_admin_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_roles_users`
--

DROP TABLE IF EXISTS `b1_admin_roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_roles_users` (
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  UNIQUE KEY `b1_admin_roles_users_index` (`role_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_roles_users`
--

LOCK TABLES `b1_admin_roles_users` WRITE;
/*!40000 ALTER TABLE `b1_admin_roles_users` DISABLE KEYS */;
INSERT INTO `b1_admin_roles_users` VALUES (1,1);
/*!40000 ALTER TABLE `b1_admin_roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b1_admin_users`
--

DROP TABLE IF EXISTS `b1_admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b1_admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `password_digest` varchar(255) NOT NULL,
  `blocked` tinyint(1) DEFAULT '0',
  `blocked_until` datetime DEFAULT NULL,
  `wrong_password_attempts` int(11) DEFAULT '0',
  `signins_count` int(11) DEFAULT '0',
  `active` tinyint(1) DEFAULT '1',
  `avatar_file_name` varchar(255) DEFAULT NULL,
  `avatar_content_type` varchar(255) DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `hotelier_id` varchar(255) DEFAULT NULL,
  `contract_owner_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_b1_admin_users_on_email_and_blocked_and_active` (`email`,`blocked`,`active`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b1_admin_users`
--

LOCK TABLES `b1_admin_users` WRITE;
/*!40000 ALTER TABLE `b1_admin_users` DISABLE KEYS */;
INSERT INTO `b1_admin_users` VALUES (1,'Admin','admin@admin.net','+380937799996','1654544','$2a$10$u4WcPWJSt4LPCwIPHNT.1u0ICg8.LqqQ39isNoStQYx6l6wbB356C',0,NULL,0,0,1,NULL,NULL,0,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL);
/*!40000 ALTER TABLE `b1_admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `seo_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `desc` longtext COLLATE utf8_unicode_ci,
  `only_photos` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_categories_on_parent_id` (`parent_id`),
  KEY `index_categories_on_position` (`position`),
  KEY `index_categories_on_seo_name` (`seo_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'qwefqwefqwef',0,'qwefqwefqwef',0,'2015-11-10 18:45:47','2015-11-10 18:45:47','wqefwqefwqefwqefweqfwef',NULL),(2,'тільки фото',0,'qwefqwef',0,'2015-11-10 18:54:59','2015-11-12 20:34:46','weqfwqefwqefweqfew',1),(3,'цуацуйацйуацуйа',2,'tsuatsujatsjuatsuja',0,'2015-11-12 20:34:52','2015-11-12 20:36:07','іуацуа',1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `course_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  `seo` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `desc` text COLLATE utf8_unicode_ci,
  `date_start` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_courses_on_course_type` (`course_type`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (5,'READING GROUP','club',1,'2015-11-11 09:28:26','2015-11-16 14:22:46','course-icon-1.png','image/png',11929,'2015-11-16 13:13:39','reading','READING GROUP','<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Читання є невід’ємною частиною вивчення англійської мови. Ви набираєтесь нових слів та звикаєте до справжньої “живої” англійської.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Тут ми спілкуємось про прочитане та похідні теми, переглядаємо відео, дискутуємо. Читаємо вдома, а не на занятті. Читаємо короткі цікаві оповідки на різну тематику. Кожного разу щось інше, тому до нас можна доєднуватись будь-коли.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Читати англійською можна починаючи з 500 слів основного словникового запасу. А в процесі доберете більше :)</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Заняття в Reading Group відбуваються по вівторках. Отож, реєструйтесь зазделегідь і гайда освоювати reading!</p>',NULL),(6,'ART AND CULTURE GROUP','club',1,'2015-11-16 13:21:20','2015-11-16 14:23:23','course-icon-2.png','image/png',13273,'2015-11-16 13:21:40','art',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">В групі Art and Culture говоримо про мистецтво в цілому, відвідуємо гуртом актуальні виставки у Львові та обговорюємо їх, беремо участь в майстер-класах та ще багато інших активностей, і тільки на англійській мові.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Зустрічаємось кожного другого вівторка о 18:30. Місце проведення: Галерея Сакрального Мистецтва IconArt Galeery на Вірменській 26.</p>',NULL),(7,'TRAVELLING GROUP','club',1,'2015-11-16 13:22:11','2015-11-16 14:23:38','course-icon-3.png','image/png',15899,'2015-11-16 13:22:21','travel',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Для тих, хто любить подорожувати!</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">В програмі: потрібна для подорожей лексика, поради, досвід інших, місця, куди варто податися та багато-багато іншого.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Загалом, про подорожі можна говорити вічно. Ми починаємо з півтори-двох годин. Приєднуйся, адже душа бажає пригод завжди ))</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Заняття в Travelling Group відбуваються по четвергах. Отож, реєструйтесь зазделегідь і гайда в мандри з нашою допомогою!</p>',NULL),(8,'MOVIES & ENGLISH GROUP','club',1,'2015-11-16 13:25:15','2015-11-16 14:23:59','course-icon-4.png','image/png',17590,'2015-11-16 13:25:35','movie',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Ми дивимось короткометражки, уривки з фільмів, короткі серіали, мультики та інше відео. Звичайно, що все англійською мовою. А потім разом із викладачем обговорюємо, дискутуємо та розбираємо складні моменти, ідіоми, фрази, сленг та незрозумілі слова. Навчально-пізнавально-цікаві заняття.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Заняття в Movies &amp; English group відбуваються по вівторках на вул.Мулярська 2а, 4-й поверх.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Отож, реєструйтесь зазделегідь і гайда в мандри з нашою допомогою!</p>',NULL),(9,'LIFESTYLE GROUP','club',1,'2015-11-16 13:26:08','2015-11-16 14:24:16','course-icon-5.png','image/png',22895,'2015-11-16 13:26:15','lifestyle',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Ми спілкуємось на різні цікаві теми, пов\'язані з стилем та способом життя. Скільки людей, стільки й історій, тому завжди є про що поговорити.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Заняття в Lifestyle Group відбуваються по четвергах.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Отож, реєструйтесь заздалегідь і гайда практикувати та вдосконалювати свою англійську!</p>',NULL),(10,'ENGLISH THROUGH GAMES','club',1,'2015-11-16 13:26:41','2015-11-16 14:24:35','course-icon-6.png','image/png',16311,'2015-11-16 13:27:03','games',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Англійську завжди цікаво вивчати, граючи у веселі та інтелектуальні ігри. Приєднуйся до нас та вдосконалюй свою англійську у веселий спосіб!</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Ведучий заняття – Andrew Simmons з США.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Отож, реєструйтесь заздалегідь і гайда практикувати та вдосконалювати свою англійську!</p>',NULL),(11,'COOKING GROUP','club',1,'2015-11-16 13:26:55','2015-11-16 14:24:49','course-icon-7.png','image/png',36167,'2015-11-16 13:27:11','cook',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">А чи пробували ви коли-небудь готувати англійською? Це весело, цікаво та, ох як навчально!</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Долучайтесь до Cooking групи, буде смачно :)</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Отож, реєструйтесь заздалегідь і гайда практикувати та вдосконалювати свою англійську!</p>',NULL),(12,'ЗАГАЛЬНИЙ КУРС АНГЛІЙСЬКОЇ МОВИ','school',1,'2015-11-16 13:47:59','2015-11-16 14:19:40','course-icon-8.png','image/png',18902,'2015-11-16 13:48:08','common',NULL,'<p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Читання є невід’ємною частиною вивчення англійської мови. Ви набираєтесь нових слів та звикаєте до справжньої “живої” англійської.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Тут ми спілкуємось про прочитане та похідні теми, переглядаємо відео, дискутуємо. Читаємо вдома, а не на занятті. Читаємо короткі цікаві оповідки на різну тематику. Кожного разу щось інше, тому до нас можна доєднуватись будь-коли.</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Читати англійською можна починаючи з 500 слів основного словникового запасу. А в процесі доберете більше :)</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Заняття в Reading Group відбуваються по вівторках. Отож, реєструйтесь зазделегідь і гайда освоювати reading!</p>','2015-11-16'),(13,'АНГЛІЙСЬКА БЕЗ АКЦЕНТУ','school',1,'2015-11-16 13:48:34','2015-11-16 17:51:59','course-icon-9.png','image/png',21520,'2015-11-16 13:48:44','accent',NULL,'<p class=\"yellow\" style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; text-transform: uppercase; color: rgb(247, 235, 19); text-align: center;\">УРС РОЗНАХОВАНИЙ НА РІВЕНЬ PRE-INTERMEDIATE</p><p style=\"margin-bottom: 15px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">Одномісячний курс для тих, хто хоче позбавитись акценту та навчитись правильної вимови. Курс особливо буде корисним людям, які збираються здавати іспити IELTS або TOEFL чи виїжджати в англомовні країни.</p><span style=\"margin: 0px; padding: 0px; border: 0px; font-weight: inherit; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotobold; vertical-align: baseline; color: rgb(255, 255, 255); text-align: center;\">З 21 вересня по 19 жовтня</span><br><div class=\"text-left\" style=\"margin: 0px; padding: 0px; border: 0px; font-stretch: inherit; font-size: 14px; line-height: 21px; font-family: robotoregular; vertical-align: baseline; color: rgb(255, 255, 255);\"><span class=\"yellow\" style=\"margin: 0px; padding: 0px; border: 0px; border-image-source: initial; border-image-slice: initial; border-image-width: initial; border-image-outset: initial; border-image-repeat: initial; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; text-transform: uppercase; color: rgb(247, 235, 19);\">ОПИС КУРСУ:</span><ul class=\"list\" style=\"margin-top: 10px; margin-right: 0px; margin-left: 0px; padding: 0px; border: 0px; border-image-source: initial; border-image-slice: initial; border-image-width: initial; border-image-outset: initial; border-image-repeat: initial; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; list-style: none;\"><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Студенти вивчають правильні позиції губ та язика при вимові кожного звуку</li><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; ; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Практикують звуки в словах та реченнях, виконуючи різні вправи</li><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline;  background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Вчаться розрізняти схожі за звучанням звуки</li><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Звикають до звучання різних звуків, прослуховуючи аудіозаписи носіїв мови</li><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline;  background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Освоюють правильні інтонацію та ритм мови</li></ul><span class=\"yellow\" style=\"margin: 0px; padding: 0px; border: 0px; border-image-source: initial; border-image-slice: initial; border-image-width: initial; border-image-outset: initial; border-image-repeat: initial; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; text-transform: uppercase; color: rgb(247, 235, 19);\">ОПИС ЗАНЯТТЯ:</span><ul class=\"list\" style=\"margin-top: 10px; margin-right: 0px; margin-left: 0px; padding: 0px; border: 0px; border-image-source: initial; border-image-slice: initial; border-image-width: initial; border-image-outset: initial; border-image-repeat: initial; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; list-style: none;\"><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline;  background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Групи до 10 людей</li><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">2 рази на тиждень по 2 години</li><li style=\"margin: 0px; padding: 0px 0px 0px 17px; border: 0px; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; vertical-align: baseline;  background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: 0px 6px; background-repeat: no-repeat;\">Вечірній час, з 19:00 по 21:10</li></ul><span class=\"yellow\" style=\"margin: 0px; padding: 0px; border: 0px; border-image-source: initial; border-image-slice: initial; border-image-width: initial; border-image-outset: initial; border-image-repeat: initial; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: robotobold; vertical-align: baseline; text-transform: uppercase; color: rgb(247, 235, 19);\">ВАРТІСТЬ КУРСУ 600 ГРН.</span></div>','2015-11-16'),(14,'Інтенсив «Галопом по граматиці»','school',1,'2015-11-16 13:49:25','2015-11-16 13:49:34','course-icon-10.png','image/png',18861,'2015-11-16 13:49:34','intensive',NULL,NULL,'2015-11-15'),(15,'Англійська для ІТ-шників','school',1,'2015-11-16 13:51:18','2015-11-16 13:51:28','course-icon-11.png','image/png',14925,'2015-11-16 13:51:27','it',NULL,NULL,'2015-11-15'),(16,'діловата Бізнес англійська','school',1,'2015-11-16 13:52:02','2015-11-16 13:52:12','course-icon-12.png','image/png',10449,'2015-11-16 13:52:12','business',NULL,NULL,'2015-11-15'),(17,'Англійська для фінансової сфери','school',1,'2015-11-16 13:52:42','2015-11-16 13:52:51','course-icon-13.png','image/png',14689,'2015-11-16 13:52:51','financial',NULL,NULL,'2015-11-15'),(18,'Англійська для медсестр','school',1,'2015-11-16 13:53:35','2015-11-16 13:54:14','course-icon-14.png','image/png',14209,'2015-11-16 13:54:14','medical',NULL,NULL,'2015-11-15'),(19,'Англійська для Work & Travel','school',1,'2015-11-16 13:54:34','2015-11-16 13:54:41','course-icon-15.png','image/png',14419,'2015-11-16 13:54:41','wat',NULL,NULL,'2015-11-15');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvs`
--

DROP TABLE IF EXISTS `cvs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `phone` varchar(255) DEFAULT '',
  `document_file_name` varchar(255) DEFAULT NULL,
  `document_content_type` varchar(255) DEFAULT NULL,
  `document_file_size` int(11) DEFAULT NULL,
  `document_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvs`
--

LOCK TABLES `cvs` WRITE;
/*!40000 ALTER TABLE `cvs` DISABLE KEYS */;
INSERT INTO `cvs` VALUES (1,'olena','olenafedorovaaa@gmail.com','0937596991',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `cvs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `group_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_groups_on_group_type` (`group_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'reading group','school',1,'2015-11-09 20:53:47','2015-11-10 11:07:42',1);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lessons`
--

DROP TABLE IF EXISTS `lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lessons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(255) NOT NULL DEFAULT '',
  `time` varchar(255) NOT NULL DEFAULT '',
  `course_id` int(11) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_lessons_on_course_id` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (1,'16.11.2015','11:00',5,1,'2015-11-13 13:57:51','2015-11-13 13:57:51');
/*!40000 ALTER TABLE `lessons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL DEFAULT '0',
  `seo_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `desc` longtext COLLATE utf8_unicode_ci,
  `anons` text COLLATE utf8_unicode_ci,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `active` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `author` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pages_on_category_id` (`category_id`),
  KEY `index_pages_on_seo_name` (`seo_name`),
  KEY `index_pages_on_active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES (1,1,'wefqwef','<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\" style=\"width: 300px;\">цйупкупкупу</p>','wqefqwefwqefwqe','wefqwef','1','ergewgewrgerge','2015-11-10 18:54:45','2015-11-11 15:38:06',NULL,'photo.jpg','image/jpeg',67362,'2015-11-11 15:38:05'),(2,1,'fqwefeqr','regwergwergwergwregregre','ergegwregewrg','fqwefeqr','1','0','2015-11-10 18:56:02','2015-11-11 15:38:19',NULL,'photo.jpg','image/jpeg',67362,'2015-11-11 15:38:18'),(3,1,'wefwqef','<p><img style=\"width: 291px;\" src=\"/system/upload_images/3/original.png?1447256327\">wefw&nbsp;<span style=\"line-height: 17.1429px;\">qwefwefqwefqwe wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e</span><span style=\"line-height: 17.1429px;\">qwefwefqwefqwe wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e</span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p>','qwefwefqwefqwe wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e qwefwefqwefqwe wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e','wefwqef','1','weqfwqefwef','2015-11-11 15:38:53','2015-11-11 15:39:26',NULL,'slide-3.jpg','image/jpeg',23959,'2015-11-11 15:39:25'),(4,3,'tsuatsua','цуацуцу','цуацйуацуацуауц','цуацуа','1','цуацуйацу','2015-11-12 20:35:14','2015-11-12 20:35:26',NULL,'photo.jpg','image/jpeg',67362,'2015-11-12 20:35:26');
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners`
--

DROP TABLE IF EXISTS `partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  `first_desc_line` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `second_desc_line` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_partners_on_active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners`
--

LOCK TABLES `partners` WRITE;
/*!40000 ALTER TABLE `partners` DISABLE KEYS */;
INSERT INTO `partners` VALUES (1,'Rhizome',1,'2015-11-10 12:23:17','2015-11-16 17:32:18','partner.jpg','image/jpeg',35701,'2015-11-16 13:42:08','20% знижки нашим учням!','Для того щоб повноцынно опанувати мову!'),(2,'Знижки учням',1,'2015-11-16 13:41:15','2015-11-16 17:32:30','partner4.jpg','image/jpeg',17853,'2015-11-16 17:32:28','20% знижки нашим учням!','Для того щоб повноцынно опанувати мову!'),(3,'The room',1,'2015-11-16 13:43:13','2015-11-16 17:32:34','partner2.jpg','image/jpeg',13106,'2015-11-16 13:43:22','20% знижки нашим учням!','Для того щоб повноцынно опанувати мову!'),(4,'Соус кафе',1,'2015-11-16 13:43:42','2015-11-16 17:32:40','partner3.jpg','image/jpeg',27143,'2015-11-16 13:43:49','20% знижки нашим учням!','Для того щоб повноцынно опанувати мову!'),(5,'Boomerang',1,'2015-11-16 13:44:01','2015-11-16 17:32:43','partner4.jpg','image/jpeg',17853,'2015-11-16 13:44:07','20% знижки нашим учням!','Для того щоб повноцынно опанувати мову!'),(6,'Альтернативна кава',1,'2015-11-16 13:44:23','2015-11-16 17:32:47','partner5.jpg','image/jpeg',16472,'2015-11-16 13:44:33','20% знижки нашим учням!','Для того щоб повноцынно опанувати мову!');
/*!40000 ALTER TABLE `partners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `is_in_school` tinyint(1) NOT NULL DEFAULT '1',
  `is_in_club` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_photos_on_is_in_school` (`is_in_school`),
  KEY `index_photos_on_is_in_club` (`is_in_club`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,'ацйуацуацуацу',1,1,'2015-11-10 10:21:17','2015-11-11 15:36:28','photo-2.jpg','image/jpeg',29755,'2015-11-11 15:36:28'),(2,'wefwefwefwefwe',1,1,'2015-11-11 13:17:03','2015-11-11 15:36:45','photo.jpg','image/jpeg',67362,'2015-11-11 15:36:45'),(3,'wefwefwefwe',1,1,'2015-11-11 13:17:14','2015-11-11 15:36:52','slide-3.jpg','image/jpeg',23959,'2015-11-11 15:36:52'),(4,'цауцуацуацуйацу',1,1,'2015-11-16 17:52:51','2015-11-16 17:52:57','slide-1.jpg','image/jpeg',28294,'2015-11-16 17:52:57');
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20140103165607'),('20150916124009'),('20151109190216'),('20151109193143'),('20151109194111'),('20151109202245'),('20151109203547'),('20151109210435'),('20151109211406'),('20151110095354'),('20151110103139'),('20151110103604'),('20151110104315'),('20151110105724'),('20151110113612'),('20151110122056'),('20151110124828'),('20151110182511'),('20151110184612'),('20151110184931'),('20151110193205'),('20151110202343'),('20151111085629'),('20151111092926'),('20151112200158'),('20151113105507'),('20151115120319'),('20151115140855'),('20151115141154'),('20151116171309');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `signins`
--

DROP TABLE IF EXISTS `signins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `signins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `signinable_id` int(11) NOT NULL,
  `signinable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `referer` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `ip` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `expiration_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_signins_on_signinable_id_and_signinable_type` (`signinable_id`,`signinable_type`),
  KEY `index_signins_on_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `signins`
--

LOCK TABLES `signins` WRITE;
/*!40000 ALTER TABLE `signins` DISABLE KEYS */;
INSERT INTO `signins` VALUES (1,1,'B1Admin::User','ZFfmnqJ93wID1RnTCAn2qZLEkqtl7Wc5WcMQzHdasr5rIqS8N-1E5IUqCx88x5wdjkeNeKqJb3Y0VJld','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:40:35','2015-11-09 19:23:35','2015-11-09 19:40:35'),(2,1,'B1Admin::User','HRELfng0j42uYksathOK2BH-56Pg0VSj4khBc8kWSG7LeSFpsWm6PMEijrx7do6_VY97MFfxdXhI','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:53:44','2015-11-09 19:40:38','2015-11-09 19:53:44'),(3,1,'B1Admin::User','VY0IWtxttRdtbIlW87J6wEZB1OSNvKqx2KO3If7lQMkv-ZrOJC-gKi8RbzndksKI5oeAj15wiYTInUGMftO7I6kJ-CoRDK7vD8M','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:56:59','2015-11-09 19:54:12','2015-11-09 19:56:59'),(4,1,'B1Admin::User','-kFFl6rX03n-IrPegz9ApJwG4gje1x_VJFFzL36OoX7mbThCzUXWuG-HHeJDoL2lkef4','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:57:52','2015-11-09 19:57:02','2015-11-09 19:57:52'),(5,1,'B1Admin::User','qwCt4fPDAu_Gu0kB7-VyiV31BiWOY067qgYsLKZ7AmaJ9g0kOe5YIV3BX-dOREK697AaNk_EVCn3iD6qLs81EGmteSfRrmuEIGcNboo','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:58:23','2015-11-09 19:57:55','2015-11-09 19:58:23'),(6,1,'B1Admin::User','3Ak8rjFZEgPiXkz6JQhONVPjltPzvnsT1KznsGPh7UawzIviZt_p2_K2t1WODhU_3HlWP2eXeJ2NfOdqPHstXZK4qZOM7Q','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 20:03:03','2015-11-09 19:58:26','2015-11-09 20:03:03'),(7,1,'B1Admin::User','hBUl06vf7Fh_hZiFCOID80XhwtqxvknTByMymlvJycTrDQc68uDtZ9HpCDZr2tFnDTxF1acsEWpbCVF-dcZXGXYs9o8VCshRevEt6VhI3SlyapV-dZd1','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 20:46:38','2015-11-09 20:03:07','2015-11-09 20:46:38'),(8,1,'B1Admin::User','mSXhbkJjy65VTIfhsEHxIXSGW7hBfsCpVFOyyNb8CkrTOkyzB4C6_tQOq_aZu1OFtf0zr8z4a0hQ1JwuoxpXLzE0Qt5N7kd-VKhMBpfd7CNGIF9-WtivpEnsCHgDopRBqU4','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 21:26:59','2015-11-09 20:46:40','2015-11-09 21:26:59'),(9,1,'B1Admin::User','SL5MTesp70ZoyHfdyL5mWZyEB4B4aXS6x7KTj1F53VIKjo0i7MJOR685nKrge_-lGaygKk9urA','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 22:44:41','2015-11-09 21:27:33','2015-11-09 21:44:41'),(10,1,'B1Admin::User','QsqDs1H5vhBf57yB4XY4wnn5JOXnSWS2vaBxCvYnXv_tUaiJrD1A3KGTsyJd34cKBCncFIhgsBKQunRHSL7UeQvKUBcr5B1oVzTwNKUKv3Q_yYEGjXQVYrIhNpvjjViP','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 10:17:05','2015-11-10 09:04:17','2015-11-10 09:17:05'),(11,1,'B1Admin::User','qx5iCqD30uj6zxsNKPiA_T6zhmT0NdHtcYzA3fmMsEKyg19Er5B0ztrAlMRN-5_Cr5raFhyp24Byimc4gj1TMXft9GlGXKmzWWdrlQ','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 10:19:36','2015-11-10 10:17:40','2015-11-10 10:19:36'),(12,1,'B1Admin::User','rRkf9mKs782gy9TPA_qTFk63wVUnFcTRVy2O59mXtbqOSUpyP9N5GmGFCX6NaW5-T70XDjtgEB1BzjNcOZ8Cn_dbdHnG-XsUVfEepJkN','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 13:55:44','2015-11-10 10:19:39','2015-11-10 12:55:44'),(13,1,'B1Admin::User','ISqo1qTJNoRzH76ZDi8B3NsLs4IMNXJlBLbOWk37egnt5cEuxT8LsHqv9Bl5eHZ-zY6t0YZ3Tz4b86muodBPHu4XzWDGexY8Xjp2THZeNwQ1R0b3x_OztM5vVKqLMH28zlI','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 21:24:44','2015-11-10 18:10:57','2015-11-10 20:24:44'),(14,1,'B1Admin::User','vRvYVrMSqkagw-sY_aCuvaBdZi74qqvpUWvTklVDwaYivRaw4cG_dOZkqwIA0l6Q2-cEbgCc','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-11 09:09:12','2015-11-11 07:57:27','2015-11-11 08:09:12'),(15,1,'B1Admin::User','ANRVtIFFSx9lEBa_ijFuenjbpeSdVEDrt0h153-nCZl78dOEMPVhWk_xFGKcw8VQog9edvXUKUm6fR37iMHh75qKWZA4a3tt8nbitvJedVgI2GPTFPYleANYbFoKRe9dwA0vcQ','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-11 10:39:10','2015-11-11 09:17:23','2015-11-11 09:39:10'),(16,1,'B1Admin::User','eExjfTaaJaJu05WMdfesO1-UE8OMu4aEq_GI-68Vq6W5y89gCxyPwDPIb1Y4UHEGqh4RhwQmn9GfUppEDvqunGVFQKs6lQcbTstiOio639xKzHlp3MHsW2Wez6A','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-11 14:17:19','2015-11-11 13:15:02','2015-11-11 13:17:19'),(17,1,'B1Admin::User','r2cYQVvWMNVkwagFuWqDTYylcOPJKmSOJp-yoK0SvWCO4-yvxUnXtRwfVWcNpzFtvx8LoRYJ9yoSSPpNsRctk5g','http://193.84.22.53/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','193.84.22.30','2015-11-11 16:39:25','2015-11-11 15:27:19','2015-11-11 15:39:25'),(18,1,'B1Admin::User','bFyQtMR20tELvgkYMovJUOQjcUXIUNmkCN7EDmhXhCA8rUjLdFrZUWsndcbIZj9Z3QSMsiAnRj-ckA','http://193.84.22.53/admin/login','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7','94.231.69.118','2015-11-12 11:36:02','2015-11-12 10:34:53','2015-11-12 10:36:02'),(19,1,'B1Admin::User','bhqS0PzAPuDne7VxvawXUKP3CeaGHe6zjXF8u-zd6ZC2OEOZ7mJoNs068VrtmYe9phUIog3GiS4AoZy0EkqsOjn7CSJ5rcJyhA','http://193.84.22.53/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','93.75.225.47','2015-11-12 21:36:07','2015-11-12 20:34:24','2015-11-12 20:36:07'),(20,1,'B1Admin::User','3GHLOb0xuo073gnyeMgujd6dDUyp4Qo6cFVSjXFER3C4o5qKrz2EMl07Pjfi1cUBRoyZk4crvkc_gw','http://193.84.22.53/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','193.84.22.30','2015-11-13 13:56:55','2015-11-13 13:56:02','2015-11-13 13:56:55'),(21,1,'B1Admin::User','Tem9ckLZCGyeZaFXJK74Xodd4Qs4XfH5zYnRc_jU-U_9g02FQvak2zkae3nJ5apBd63EQGbDngLEUeJjhP5y_8oNymUnwJ4W0dZr-IKGD7pVhZTG_l7_R_ZUmBOVaA','http://193.84.22.53/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','193.84.22.30','2015-11-13 14:58:10','2015-11-13 13:56:56','2015-11-13 13:58:10'),(22,1,'B1Admin::User','4qOsS9dfkthqKC-LjgQb7PH9GZeD299TupYzl19R3NteT5mA3h7KbYpKnLMRZBwOko-4TdbHvQSoZmpOdwL3Zic6ICa5F0bGTDmhtKNs4bwEpUm484xjWw-hnoZYoJUkMEM','http://193.84.22.53/admin/login','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7','94.231.69.118','2015-11-15 11:25:09','2015-11-15 10:24:25','2015-11-15 10:25:09'),(23,1,'B1Admin::User','uw1YZnl-8vCuK2nqgZwwTsJHlg-HWU5oMi0KycdRR_HAyIgOsyDkCGoc62tOQqVWiCjJkmOGkY8m7HoV0VuZX1268HlhMDQH6AK8rTpyb_Qi9EaX','http://193.84.22.53/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','193.84.22.54','2015-11-16 15:24:50','2015-11-16 12:33:47','2015-11-16 14:24:50'),(24,1,'B1Admin::User','4njhx0nE3D2MPZnvT8mR5VlvdUhigFn6J88QKCCMJ4YzDXdTGuTURGhD-yGDp1pZqmo-87qP-9UynL4rMA','http://193.84.22.53/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','93.75.229.175','2015-11-16 18:52:57','2015-11-16 17:24:12','2015-11-16 17:52:57');
/*!40000 ALTER TABLE `signins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribers`
--

DROP TABLE IF EXISTS `subscribers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscribers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `school_subscribe` tinyint(1) DEFAULT '0',
  `club_subscribe` tinyint(1) DEFAULT '0',
  `blog_subscribe` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribers`
--

LOCK TABLES `subscribers` WRITE;
/*!40000 ALTER TABLE `subscribers` DISABLE KEYS */;
INSERT INTO `subscribers` VALUES (1,'fwefwefwefwefwe','wefwef@fwef.ew','wefweqf',1,0,1,0,'2015-11-11 09:33:25','2015-11-11 09:38:34',5),(2,'Олена Федорова','olenafedorovaaa@gmail.com','093 7496991',1,1,0,0,'2015-11-16 19:57:32','2015-11-16 19:57:32',18);
/*!40000 ALTER TABLE `subscribers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teachers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `desc` text COLLATE utf8_unicode_ci NOT NULL,
  `is_in_school` tinyint(1) NOT NULL DEFAULT '1',
  `is_in_club` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_teachers_on_is_in_school` (`is_in_school`),
  KEY `index_teachers_on_is_in_club` (`is_in_club`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (1,'ergwergwregerwgrege','ergfergrewgre',1,1,'2015-11-09 21:40:05','2015-11-11 15:36:07','foto.jpg','image/jpeg',34156,'2015-11-11 15:36:07'),(2,'ergre','gregerwgerwg',1,1,'2015-11-09 21:43:37','2015-11-11 15:36:19','foto.jpg','image/jpeg',34156,'2015-11-11 15:36:18');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upload_images`
--

DROP TABLE IF EXISTS `upload_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upload_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `file_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_file_size` int(11) DEFAULT NULL,
  `file_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upload_images`
--

LOCK TABLES `upload_images` WRITE;
/*!40000 ALTER TABLE `upload_images` DISABLE KEYS */;
INSERT INTO `upload_images` VALUES (1,'2015-11-10 18:51:21','2015-11-10 18:51:21','GtHjabb.png','image/png',526679,'2015-11-10 18:51:20'),(2,'2015-11-10 18:54:40','2015-11-10 18:54:40','вендетта.jpg','image/jpeg',19381,'2015-11-10 18:54:40'),(3,'2015-11-11 15:38:47','2015-11-11 15:38:47','partner.jpg','image/jpeg',35701,'2015-11-11 15:38:47');
/*!40000 ALTER TABLE `upload_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vacancies`
--

DROP TABLE IF EXISTS `vacancies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacancies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `desc` text COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vacancies`
--

LOCK TABLES `vacancies` WRITE;
/*!40000 ALTER TABLE `vacancies` DISABLE KEYS */;
INSERT INTO `vacancies` VALUES (1,'ВИКЛАДАЧ АНГЛІЙСЬКОЇ МОВИ','уцкпуцкпуцкпцкупцкупку',1,'2015-11-10 09:15:43','2015-11-16 13:55:53'),(2,'ОФІС МЕНЕДЖЕР','уцкпуцкпуцкпцкупцкупку',1,'2015-11-10 09:16:31','2015-11-16 13:56:08');
/*!40000 ALTER TABLE `vacancies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_id` int(11) NOT NULL,
  `event` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `whodunnit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `object` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `object_changes` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_versions_on_item_type_and_item_id` (`item_type`,`item_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
INSERT INTO `versions` VALUES (1,'Page',1,'update','1','---\nid: 1\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\"></p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 18:54:45.000000000 Z\nposition: \n','2015-11-10 18:57:29','---\ndesc:\n- \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\"></p>\'\n- \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nupdated_at:\n- 2015-11-10 18:54:45.000000000 Z\n- 2015-11-10 18:57:29.644593877 Z\n'),(2,'Page',1,'update','1','---\nid: 1\nlogo_file_name: \ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 18:57:29.000000000 Z\nposition: \nlogo_content_type: \nlogo_file_size: \nlogo_updated_at: \n','2015-11-10 19:37:35','---\nlogo_file_name:\n- \n- IMG_2668.jpg\nlogo_content_type:\n- \n- image/jpeg\nlogo_file_size:\n- \n- 377122\nlogo_updated_at:\n- \n- 2015-11-10 19:37:35.361340375 Z\nupdated_at:\n- 2015-11-10 18:57:29.000000000 Z\n- 2015-11-10 19:37:35.520812077 Z\n'),(3,'Page',2,'update','1','---\nid: 2\nlogo_file_name: \ncategory_id: 1\nseo_name: fqwefeqr\ndesc: regwergwergwergwregregre\nanons: ergegwregewrg\ntitle: fqwefeqr\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:56:02.000000000 Z\nupdated_at: 2015-11-10 18:56:02.000000000 Z\nposition: \nlogo_content_type: \nlogo_file_size: \nlogo_updated_at: \n','2015-11-10 19:37:52','---\nlogo_file_name:\n- \n- \"ппп_-_1.jpg\"\nlogo_content_type:\n- \n- image/jpeg\nlogo_file_size:\n- \n- 18204\nlogo_updated_at:\n- \n- 2015-11-10 19:37:52.768491902 Z\nupdated_at:\n- 2015-11-10 18:56:02.000000000 Z\n- 2015-11-10 19:37:52.892359386 Z\n'),(4,'Page',2,'update','1','---\nid: 2\nlogo_file_name: \"ппп_-_1.jpg\"\ncategory_id: 1\nseo_name: fqwefeqr\ndesc: regwergwergwergwregregre\nanons: ergegwregewrg\ntitle: fqwefeqr\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:56:02.000000000 Z\nupdated_at: 2015-11-10 19:37:52.000000000 Z\nposition: \nlogo_content_type: image/jpeg\nlogo_file_size: 18204\nlogo_updated_at: 2015-11-10 19:37:52.000000000 Z\n','2015-11-10 20:21:17','---\nlogo_file_name:\n- \"ппп_-_1.jpg\"\n- GtHjabb.png\nlogo_content_type:\n- image/jpeg\n- image/png\nlogo_file_size:\n- 18204\n- 526679\nlogo_updated_at:\n- 2015-11-10 19:37:52.000000000 Z\n- 2015-11-10 20:21:16.609407698 Z\nupdated_at:\n- 2015-11-10 19:37:52.000000000 Z\n- 2015-11-10 20:21:17.089355240 Z\n'),(5,'Page',1,'update','1','---\nid: 1\nlogo_file_name: IMG_2668.jpg\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 19:37:35.000000000 Z\nposition: \nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 19:37:35.000000000 Z\n','2015-11-10 20:21:26','---\nlogo_updated_at:\n- 2015-11-10 19:37:35.000000000 Z\n- 2015-11-10 20:21:25.930217489 Z\nlogo_file_name:\n- IMG_2668.jpg\n- IMG_2668.jpg\nupdated_at:\n- 2015-11-10 19:37:35.000000000 Z\n- 2015-11-10 20:21:26.166552842 Z\n'),(6,'Page',1,'update','1','---\nid: 1\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 20:21:26.000000000 Z\nposition: \nlogo_file_name: IMG_2668.jpg\nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 20:21:25.000000000 Z\n','2015-11-10 20:23:12','---\nauthor:\n- 0\n- 0\nupdated_at:\n- 2015-11-10 20:21:26.000000000 Z\n- 2015-11-10 20:23:12.300207202 Z\n'),(7,'Page',1,'update','1','---\nid: 1\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: \'0\'\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 20:23:12.000000000 Z\nposition: \nlogo_file_name: IMG_2668.jpg\nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 20:21:25.000000000 Z\n','2015-11-10 20:24:42','---\nauthor:\n- \'0\'\n- ergewgewrgerge\nupdated_at:\n- 2015-11-10 20:23:12.000000000 Z\n- 2015-11-10 20:24:42.288067237 Z\n'),(8,'Page',1,'update','1','---\nid: 1\nlogo_file_name: IMG_2668.jpg\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: ergewgewrgerge\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 20:24:42.000000000 Z\nposition: \nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 20:21:25.000000000 Z\n','2015-11-11 15:38:06','---\nlogo_file_name:\n- IMG_2668.jpg\n- photo.jpg\nlogo_file_size:\n- 377122\n- 67362\nlogo_updated_at:\n- 2015-11-10 20:21:25.000000000 Z\n- 2015-11-11 15:38:05.656335663 Z\nupdated_at:\n- 2015-11-10 20:24:42.000000000 Z\n- 2015-11-11 15:38:06.026369983 Z\n'),(9,'Page',2,'update','1','---\nid: 2\nlogo_file_name: GtHjabb.png\ncategory_id: 1\nseo_name: fqwefeqr\ndesc: regwergwergwergwregregre\nanons: ergegwregewrg\ntitle: fqwefeqr\nactive: \'1\'\nauthor: \'0\'\ncreated_at: 2015-11-10 18:56:02.000000000 Z\nupdated_at: 2015-11-10 20:21:17.000000000 Z\nposition: \nlogo_content_type: image/png\nlogo_file_size: 526679\nlogo_updated_at: 2015-11-10 20:21:16.000000000 Z\n','2015-11-11 15:38:19','---\nlogo_file_name:\n- GtHjabb.png\n- photo.jpg\nlogo_content_type:\n- image/png\n- image/jpeg\nlogo_file_size:\n- 526679\n- 67362\nlogo_updated_at:\n- 2015-11-10 20:21:16.000000000 Z\n- 2015-11-11 15:38:18.764643047 Z\nupdated_at:\n- 2015-11-10 20:21:17.000000000 Z\n- 2015-11-11 15:38:19.173947727 Z\n'),(10,'Page',3,'update','1','---\nid: 3\nlogo_file_name: \ncategory_id: 1\nseo_name: wefwqef\ndesc: \'<p><img style=\"width: 291px;\" src=\"/system/upload_images/3/original.png?1447256327\">wefw&nbsp;<span\n  style=\"line-height: 17.1429px;\">qwefwefqwefqwe wefwqfwqefwqefwqfwq fwqewqfqwfwq\n  wqqw fevwevf wd we e e</span><span style=\"line-height: 17.1429px;\">qwefwefqwefqwe\n  wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e</span></p><p><span style=\"line-height:\n  17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span\n  style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span\n  style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span\n  style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span\n  style=\"line-height: 17.1429px;\"><br></span></p><p><span style=\"line-height: 17.1429px;\"><br></span></p><p><span\n  style=\"line-height: 17.1429px;\"><br></span></p>\'\nanons: qwefwefqwefqwe wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e qwefwefqwefqwe\n  wefwqfwqefwqefwqfwq fwqewqfqwfwq wqqw fevwevf wd we e e\ntitle: wefwqef\nactive: \'1\'\nauthor: weqfwqefwef\ncreated_at: 2015-11-11 15:38:53.000000000 Z\nupdated_at: 2015-11-11 15:38:53.000000000 Z\nposition: \nlogo_content_type: \nlogo_file_size: \nlogo_updated_at: \n','2015-11-11 15:39:26','---\nlogo_file_name:\n- \n- slide-3.jpg\nlogo_content_type:\n- \n- image/jpeg\nlogo_file_size:\n- \n- 23959\nlogo_updated_at:\n- \n- 2015-11-11 15:39:25.925139343 Z\nupdated_at:\n- 2015-11-11 15:38:53.000000000 Z\n- 2015-11-11 15:39:26.100605636 Z\n'),(11,'Page',4,'update','1','---\nid: 4\nlogo_file_name: \ncategory_id: 3\nseo_name: tsuatsua\ndesc: цуацуцу\nanons: цуацйуацуацуауц\ntitle: цуацуа\nactive: \'1\'\nauthor: цуацуйацу\ncreated_at: 2015-11-12 20:35:14.000000000 Z\nupdated_at: 2015-11-12 20:35:14.000000000 Z\nposition: \nlogo_content_type: \nlogo_file_size: \nlogo_updated_at: \n','2015-11-12 20:35:26','---\nlogo_file_name:\n- \n- photo.jpg\nlogo_content_type:\n- \n- image/jpeg\nlogo_file_size:\n- \n- 67362\nlogo_updated_at:\n- \n- 2015-11-12 20:35:26.317507994 Z\nupdated_at:\n- 2015-11-12 20:35:14.000000000 Z\n- 2015-11-12 20:35:26.986808026 Z\n');
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-17 11:50:50
