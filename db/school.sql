/*
SQLyog Community v12.02 (64 bit)
MySQL - 5.5.46-0ubuntu0.14.04.2 : Database - english_school
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `addresses` */

DROP TABLE IF EXISTS `addresses`;

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

/*Data for the table `addresses` */

insert  into `addresses`(`id`,`name`,`email`,`phones`,`active`,`created_at`,`updated_at`,`title`,`is_main`) values (1,'вул. Мулярська 2а, 4й поверх бібліотека ім.Лесі Українки','eng.speak.club@gmail.com','063 74 86 032',1,'2015-11-10 11:51:57','2015-11-10 12:53:49','ОСНОВНА АДРЕСА',1),(2,'Україна, місто Львів, вулиця ВІРМЕНСЬКА 26, арт-галерея IconArt','','',1,'2015-11-10 12:55:43','2015-11-10 12:55:43','ЗАНЯТТЯ ГРУПИ ART AND CULTURE GROUP:',0);

/*Table structure for table `b1_admin_modules` */

DROP TABLE IF EXISTS `b1_admin_modules`;

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
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_modules` */

insert  into `b1_admin_modules`(`id`,`ico`,`parent_id`,`name_uk`,`name_en`,`controller`,`created_at`,`updated_at`,`position`,`hidden`,`show_in_list`) values (1,'fa-shield',0,'Настройки','Настройки','settings','2015-02-11 15:52:48','2015-02-11 15:52:48',0,0,1),(2,'fa-file',1,'Модули','Модули','modules','2015-02-11 15:52:48','2015-02-11 15:52:48',0,0,1),(11,'fa-file',1,'Роли доступа','Роли доступа','roles','2015-02-11 15:52:48','2015-02-18 16:16:07',1,0,1),(14,'fa-file',1,'Права доступа','Права доступа','permissions','2015-02-11 15:52:49','2015-02-11 15:52:49',2,0,1),(17,'fa-file',1,'Администраторы','Администраторы','admins','2015-02-11 15:52:49','2015-02-11 15:52:49',3,0,1),(40,'emails',1,'Шаблоны Email','Шаблоны Email','emails','2015-07-03 08:36:10','2015-07-03 08:36:10',0,0,1),(45,'fa-edit',0,'Школа','Школа','school','2015-11-09 20:00:41','2015-11-09 20:00:41',0,0,1),(46,'courses',45,'Курси','Курси','courses','2015-11-09 20:01:00','2015-11-09 20:01:00',0,0,1),(48,'fa-briefcase',0,'Загальне','Загальне','content','2015-11-09 21:23:27','2015-11-09 21:23:27',0,0,1),(49,'teachers',48,'Викладачі','Викладачі','teachers','2015-11-09 21:23:51','2015-11-09 21:23:51',0,0,1),(50,'vacancies',48,'Вакансії','Вакансії','vacancies','2015-11-09 21:24:30','2015-11-09 21:24:30',0,0,1),(51,'photos',48,'Галерея','Галерея','photos','2015-11-09 21:44:41','2015-11-09 21:44:41',0,0,1),(52,'addresses',1,'Адреси','Адреси','addresses','2015-11-10 11:41:14','2015-11-10 11:41:14',0,0,1),(53,'partners',48,'Партнери','Партнери','partners','2015-11-10 12:19:37','2015-11-10 12:19:37',0,0,1),(54,'fa-envelope',0,'Блог','Блог','blog','2015-11-10 18:11:54','2015-11-10 18:11:54',0,0,1),(55,'fa-envelope',54,'Блог','Блог','pages','2015-11-10 18:23:45','2015-11-10 18:23:45',0,0,1),(56,'fa-bullhorn',0,'Клуб','Клуб','club','2015-11-11 08:00:43','2015-11-11 08:00:43',0,0,1),(57,'courses',56,'Курси','Курси','courses','2015-11-11 08:01:30','2015-11-11 08:01:30',0,0,1),(58,'users',56,'Підписники','Підписники','users','2015-11-11 09:17:49','2015-11-11 09:17:49',0,0,1),(59,'users',45,'Підписники','Підписники','users','2015-11-11 09:18:05','2015-11-11 09:18:05',0,0,1),(60,'users',54,'Підписники','Підписники','users','2015-11-11 09:18:21','2015-11-11 09:18:21',0,0,1),(61,'lessons',56,'Заняття','Заняття','lessons','2015-11-13 10:13:00','2015-11-13 10:13:00',0,0,1),(62,'cvscvs',48,'Резюме','Резюме','cvs','2015-11-16 12:36:34','2015-11-16 12:36:34',0,0,1);

/*Table structure for table `b1_admin_modules_roles` */

DROP TABLE IF EXISTS `b1_admin_modules_roles`;

CREATE TABLE `b1_admin_modules_roles` (
  `role_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  UNIQUE KEY `b1_admin_modules_roles_index` (`module_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_modules_roles` */

insert  into `b1_admin_modules_roles`(`role_id`,`module_id`) values (1,1),(1,2),(1,11),(1,14),(1,17),(1,40),(1,45),(1,46),(1,48),(1,49),(1,50),(1,51),(1,52),(1,53),(1,54),(1,55),(1,56),(1,57),(1,58),(1,59),(1,60),(1,61),(1,62);

/*Table structure for table `b1_admin_permissions` */

DROP TABLE IF EXISTS `b1_admin_permissions`;

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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_permissions` */

insert  into `b1_admin_permissions`(`id`,`desc_uk`,`desc_en`,`module_id`,`action`,`created_at`,`updated_at`) values (1,'Просмотр модулей','Просмотр модулей',2,'index','2015-02-11 15:52:49','2015-02-18 16:19:22'),(2,'Просмотр ролей доступа','Просмотр ролей доступа',11,'index','2015-02-11 15:52:50','2015-02-11 16:09:18'),(3,'Просмотр прав доступа','Просмотр прав доступа',14,'index','2015-02-11 15:52:50','2015-02-11 16:09:52'),(4,'Просмотр администраторов','Просмотр администраторов',17,'index','2015-02-11 15:52:50','2015-02-11 16:10:03'),(5,'Просмотр логов админ панели','Просмотр логов админ панели',3,'index','2015-02-11 15:52:50','2015-02-11 16:10:20'),(6,'Просмотр стран','Просмотр стран',12,'index','2015-02-11 15:52:50','2015-02-11 16:11:05'),(7,'Просмотр городов','Просмотр городов',16,'index','2015-02-11 15:52:50','2015-02-11 15:52:50'),(8,'Просмотр аэропортов','Просмотр аэропортов',18,'index','2015-02-11 15:52:50','2015-02-11 16:08:37'),(9,'Просмотр континетов','Просмотр континетов',4,'index','2015-02-11 15:52:50','2015-02-11 16:09:31'),(10,'Просмотр факов','Просмотр факов',5,'index','2015-02-11 15:52:50','2015-02-11 16:08:49'),(11,'Просмотр списка ОТА','Просмотр списка ОТА',6,'index','2015-02-11 15:52:50','2015-02-11 16:09:42'),(12,'Просмотр списка','Просмотр списка',13,'index','2015-02-11 15:52:50','2015-06-30 12:48:38'),(13,'Просмотр списка','Просмотр списка',7,'index','2015-02-11 15:52:50','2015-02-11 15:52:50'),(14,'Просмотр списка','Просмотр списка',9,'index','2015-02-11 15:52:51','2015-02-11 15:52:51'),(15,'Просмотр списка','Просмотр списка',8,'index','2015-02-11 15:52:51','2015-02-11 15:52:51'),(16,'Просмотр статистики','Просмотр статистики',23,'index','2015-02-18 17:20:48','2015-02-18 17:20:48'),(17,'Просмотр логов фронта','Просмотр логов фронта',24,'index','2015-02-23 19:06:36','2015-02-23 19:06:36'),(18,'цуайцацйу','ацйуацйуауац',25,'index','2015-04-07 12:17:29','2015-04-07 12:17:29'),(19,'Просмотр','Просмотр',26,'index','2015-04-07 15:34:07','2015-04-07 15:34:07'),(20,'Просмотр настроек','Просмотр настроек',27,'index','2015-04-09 07:42:13','2015-04-09 07:42:13'),(21,'Просмотр списка','Просмотр списка',28,'index','2015-05-04 12:31:48','2015-06-30 12:47:33'),(22,'Просмотр списка','Просмотр списка',30,'index','2015-06-30 14:04:47','2015-06-30 14:04:47'),(23,'Просмотр списка','Просмотр списка',31,'index','2015-06-30 15:12:59','2015-06-30 15:12:59'),(24,'Просмотр типов','Просмотр типов',32,'index','2015-06-30 16:32:17','2015-06-30 16:32:17'),(25,'Просмотр списка сервисов','Просмотр списка сервисов',33,'index','2015-07-01 07:41:41','2015-07-01 07:41:41'),(26,'Просмотр списка','Просмотр списка',34,'index','2015-07-01 08:40:45','2015-07-01 08:40:45'),(27,'Просмотр списка','Просмотр списка',35,'index','2015-07-01 10:21:24','2015-07-01 10:21:24'),(28,'Просмотр списка','Просмотр списка',36,'index','2015-07-01 10:22:45','2015-07-01 10:22:45'),(29,'Просмотр списка','Просмотр списка',37,'index','2015-07-01 12:55:21','2015-07-01 12:55:21'),(30,'Просмотр списка','Просмотр списка',38,'index','2015-07-01 12:55:30','2015-07-01 12:55:30'),(31,'Просмотр списка отелей','Просмотр списка отелей',39,'index','2015-07-01 13:28:10','2015-07-01 13:28:10'),(32,'Просмотр списка','Просмотр списка',40,'index','2015-07-03 08:45:40','2015-07-03 08:45:40'),(33,'Просмотр списка бронирований','Просмотр списка бронирований',42,'index','2015-07-03 12:33:49','2015-07-03 12:33:49'),(34,'Просмотр списка заявок','Просмотр списка заявок',43,'index','2015-07-03 12:40:06','2015-07-03 12:40:06'),(35,'Создание доступа','Создание доступа',44,'create_admin','2015-09-16 13:21:36','2015-09-16 13:21:36'),(36,'просмотр списка контрактов','просмотр списка контрактов',44,'index','2015-09-16 13:22:55','2015-09-16 13:22:55'),(37,'Просмотр списка','Просмотр списка',46,'index','2015-11-09 20:02:35','2015-11-09 20:02:35'),(38,'Просмотр списка','Просмотр списка',47,'index','2015-11-09 20:46:25','2015-11-09 20:46:25'),(39,'Перегляд списку','Перегляд списку',49,'index','2015-11-09 21:24:54','2015-11-09 21:24:54'),(40,'Перегляд списку','Перегляд списку',50,'index','2015-11-09 21:25:07','2015-11-09 21:25:07'),(41,'Просмотр списка','Просмотр списка',51,'index','2015-11-10 10:19:24','2015-11-10 10:19:24'),(42,'Перегляд списку','Перегляд списку',52,'index','2015-11-10 11:41:30','2015-11-10 11:41:30'),(43,'Перегляд списку','Перегляд списку',53,'index','2015-11-10 12:20:33','2015-11-10 12:20:33'),(44,'Перегляд списку','Перегляд списку',55,'index','2015-11-10 18:24:22','2015-11-10 18:24:22'),(45,'Перегляд списку','Перегляд списку',57,'index','2015-11-11 08:09:12','2015-11-11 08:09:12'),(46,'Перегляд списку','Перегляд списку',60,'index','2015-11-11 09:19:04','2015-11-11 09:19:04'),(47,'Перегляд списку','Перегляд списку',59,'index','2015-11-11 09:19:17','2015-11-11 09:19:17'),(48,'Перегляд списку','Перегляд списку',58,'index','2015-11-11 09:19:23','2015-11-11 09:19:23'),(49,'Перегляд календаря','Перегляд календаря',61,'index','2015-11-13 10:17:51','2015-11-13 10:17:51'),(50,'Перегляд','Перегляд',62,'index','2015-11-16 12:38:07','2015-11-16 12:38:07');

/*Table structure for table `b1_admin_permissions_roles` */

DROP TABLE IF EXISTS `b1_admin_permissions_roles`;

CREATE TABLE `b1_admin_permissions_roles` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  UNIQUE KEY `b1_admin_permissions_roles_index` (`permission_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_permissions_roles` */

insert  into `b1_admin_permissions_roles`(`role_id`,`permission_id`) values (1,1),(1,2),(1,3),(1,4),(1,32),(1,37),(1,39),(1,40),(1,41),(1,42),(1,43),(1,44),(1,45),(1,46),(1,47),(1,48),(1,49),(1,50);

/*Table structure for table `b1_admin_roles` */

DROP TABLE IF EXISTS `b1_admin_roles`;

CREATE TABLE `b1_admin_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `desc_uk` varchar(50) NOT NULL,
  `desc_en` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_roles` */

insert  into `b1_admin_roles`(`id`,`name`,`desc_uk`,`desc_en`,`created_at`,`updated_at`) values (1,'Admin','Can access to admin panel','Can access to admin panel','2015-02-11 15:52:49','2015-02-11 15:52:49');

/*Table structure for table `b1_admin_roles_users` */

DROP TABLE IF EXISTS `b1_admin_roles_users`;

CREATE TABLE `b1_admin_roles_users` (
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  UNIQUE KEY `b1_admin_roles_users_index` (`role_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_roles_users` */

insert  into `b1_admin_roles_users`(`role_id`,`user_id`) values (1,1);

/*Table structure for table `b1_admin_users` */

DROP TABLE IF EXISTS `b1_admin_users`;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `b1_admin_users` */

insert  into `b1_admin_users`(`id`,`name`,`email`,`phone`,`position`,`password_digest`,`blocked`,`blocked_until`,`wrong_password_attempts`,`signins_count`,`active`,`avatar_file_name`,`avatar_content_type`,`avatar_file_size`,`avatar_updated_at`,`created_at`,`updated_at`,`hotelier_id`,`contract_owner_id`) values (1,'Admin','admin@admin.net','+380937799996','1654544','$2a$10$u4WcPWJSt4LPCwIPHNT.1u0ICg8.LqqQ39isNoStQYx6l6wbB356C',0,NULL,0,0,1,NULL,NULL,0,'0000-00-00 00:00:00','0000-00-00 00:00:00','2015-11-13 10:12:35',NULL,NULL);

/*Table structure for table `categories` */

DROP TABLE IF EXISTS `categories`;

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

/*Data for the table `categories` */

insert  into `categories`(`id`,`title`,`parent_id`,`seo_name`,`position`,`created_at`,`updated_at`,`desc`,`only_photos`) values (1,'qwefqwefqwef',0,'qwefqwefqwef',0,'2015-11-10 18:45:47','2015-11-12 20:07:11','wqefwqefwqefwqefweqfwef',1),(2,'qwefqwef',0,'qwefqwef',0,'2015-11-10 18:54:59','2015-11-10 18:54:59','weqfwqefwqefweqfew',NULL),(3,'egrregreg',1,'egrregreg',0,'2015-11-12 20:15:24','2015-11-12 20:15:24','wergergre',NULL);

/*Table structure for table `courses` */

DROP TABLE IF EXISTS `courses`;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `courses` */

insert  into `courses`(`id`,`name`,`course_type`,`active`,`created_at`,`updated_at`,`logo_file_name`,`logo_content_type`,`logo_file_size`,`logo_updated_at`,`seo`,`title`,`desc`,`date_start`) values (1,'sadvsdvsvsdv','school',1,'2015-11-09 20:25:18','2015-11-16 14:10:49','вендетта.jpg','image/jpeg',19381,'2015-11-10 10:26:13','common','ЗАГАЛЬНИЙ КУРС АНГЛІЙСЬКОЇ МОВИ','egergwergwergwregwre','2015-11-16'),(2,'weerfer','school',1,'2015-11-11 09:27:01','2015-11-15 13:45:47','IMG_2668.jpg','image/jpeg',377122,'2015-11-11 09:27:06','erer','wqregfergfre',NULL,'2016-01-21'),(3,'wqefew','school',1,'2015-11-11 09:27:36','2015-11-15 13:45:12','course-icon-12.png','image/png',10449,'2015-11-15 12:26:25','wefwqefwef','fwefweqf',NULL,'2015-11-14'),(4,'wefwef','school',1,'2015-11-11 09:27:53','2015-11-15 13:45:36','course-icon-12.png','image/png',10449,'2015-11-15 13:45:36','wefwefwfwe','wefwef',NULL,'2015-11-26'),(5,'wefweqfwqe','club',1,'2015-11-11 09:28:26','2015-11-11 09:28:31','download.jpg','image/jpeg',7470,'2015-11-11 09:28:31','wefwqefweqfwe','fwqefwqef',NULL,NULL),(6,'wefwe','club',1,'2015-11-13 10:42:21','2015-11-13 10:42:29','course-icon-6.png','image/png',16311,'2015-11-13 10:42:28','wqefwqefw','fwefwqef',NULL,NULL);

/*Table structure for table `cvs` */

DROP TABLE IF EXISTS `cvs`;

CREATE TABLE `cvs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `document_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `document_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `document_file_size` int(11) DEFAULT NULL,
  `document_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `cvs` */

insert  into `cvs`(`id`,`name`,`email`,`phone`,`document_file_name`,`document_content_type`,`document_file_size`,`document_updated_at`) values (1,'фавмавмупук','wfwefew@wefwefwe.wefwef','56104541521',NULL,NULL,NULL,NULL);

/*Table structure for table `groups` */

DROP TABLE IF EXISTS `groups`;

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

/*Data for the table `groups` */

insert  into `groups`(`id`,`name`,`group_type`,`active`,`created_at`,`updated_at`,`course_id`) values (1,'reading group','school',1,'2015-11-09 20:53:47','2015-11-10 11:07:42',1);

/*Table structure for table `lessons` */

DROP TABLE IF EXISTS `lessons`;

CREATE TABLE `lessons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `time` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `course_id` int(11) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_lessons_on_course_id` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `lessons` */

insert  into `lessons`(`id`,`date`,`time`,`course_id`,`active`,`created_at`,`updated_at`) values (1,'30.11.2015','09:00',5,1,'2015-11-13 13:17:19','2015-11-13 13:17:19'),(2,'01.12.2015','06:00',5,1,'2015-11-13 13:38:01','2015-11-13 13:38:01'),(3,'02.12.2015','14:00',5,1,'2015-11-13 13:42:23','2015-11-13 13:42:23'),(4,'01.12.2015','06:00',6,1,'2015-11-13 13:43:53','2015-11-13 13:43:53'),(5,'04.12.2015','16:00',5,1,'2015-11-13 13:44:00','2015-11-13 13:44:00');

/*Table structure for table `pages` */

DROP TABLE IF EXISTS `pages`;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `pages` */

insert  into `pages`(`id`,`category_id`,`seo_name`,`desc`,`anons`,`title`,`active`,`author`,`created_at`,`updated_at`,`position`,`logo_file_name`,`logo_content_type`,`logo_file_size`,`logo_updated_at`) values (1,1,'wefqwef','<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\" style=\"width: 300px;\">цйупкупкупу</p>','wqefqwefwqefwqe','wefqwef','1','ergewgewrgerge','2015-11-10 18:54:45','2015-11-10 20:24:42',NULL,'IMG_2668.jpg','image/jpeg',377122,'2015-11-10 20:21:25'),(2,1,'fqwefeqr','regwergwergwergwregregre','ergegwregewrg','fqwefeqr','1','0','2015-11-10 18:56:02','2015-11-10 20:21:17',NULL,'GtHjabb.png','image/png',526679,'2015-11-10 20:21:16');

/*Table structure for table `partners` */

DROP TABLE IF EXISTS `partners`;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `partners` */

insert  into `partners`(`id`,`name`,`active`,`created_at`,`updated_at`,`logo_file_name`,`logo_content_type`,`logo_file_size`,`logo_updated_at`,`first_desc_line`,`second_desc_line`) values (1,'бумеранг',1,'2015-11-10 12:23:17','2015-11-16 17:18:55','IMG_2668.jpg','image/jpeg',377122,'2015-11-10 12:24:17','qwefqwe','fwqefweqfweqfew');

/*Table structure for table `photos` */

DROP TABLE IF EXISTS `photos`;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `photos` */

insert  into `photos`(`id`,`name`,`is_in_school`,`is_in_club`,`created_at`,`updated_at`,`logo_file_name`,`logo_content_type`,`logo_file_size`,`logo_updated_at`) values (1,'ацйуацуацуацу',1,1,'2015-11-10 10:21:17','2015-11-10 10:25:01','GtHjabb.png','image/png',526679,'2015-11-10 10:25:01'),(2,'wefwefwefwefwe',1,1,'2015-11-11 13:17:03','2015-11-11 13:17:08','GtHjabb.png','image/png',526679,'2015-11-11 13:17:08'),(3,'wefwefwefwe',1,1,'2015-11-11 13:17:14','2015-11-11 13:17:19','IMG_2668.jpg','image/jpeg',377122,'2015-11-11 13:17:19');

/*Table structure for table `schema_migrations` */

DROP TABLE IF EXISTS `schema_migrations`;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `schema_migrations` */

insert  into `schema_migrations`(`version`) values ('20140103165607'),('20150916124009'),('20151109190216'),('20151109193143'),('20151109194111'),('20151109202245'),('20151109203547'),('20151109210435'),('20151109211406'),('20151110095354'),('20151110103139'),('20151110103604'),('20151110104315'),('20151110105724'),('20151110113612'),('20151110122056'),('20151110124828'),('20151110182511'),('20151110184612'),('20151110184931'),('20151110193205'),('20151110202343'),('20151111085629'),('20151111092926'),('20151112200158'),('20151113105507'),('20151115120319'),('20151115140855'),('20151115141154'),('20151116171309');

/*Table structure for table `signins` */

DROP TABLE IF EXISTS `signins`;

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `signins` */

insert  into `signins`(`id`,`signinable_id`,`signinable_type`,`token`,`referer`,`user_agent`,`ip`,`expiration_time`,`created_at`,`updated_at`) values (1,1,'B1Admin::User','ZFfmnqJ93wID1RnTCAn2qZLEkqtl7Wc5WcMQzHdasr5rIqS8N-1E5IUqCx88x5wdjkeNeKqJb3Y0VJld','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:40:35','2015-11-09 19:23:35','2015-11-09 19:40:35'),(2,1,'B1Admin::User','HRELfng0j42uYksathOK2BH-56Pg0VSj4khBc8kWSG7LeSFpsWm6PMEijrx7do6_VY97MFfxdXhI','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:53:44','2015-11-09 19:40:38','2015-11-09 19:53:44'),(3,1,'B1Admin::User','VY0IWtxttRdtbIlW87J6wEZB1OSNvKqx2KO3If7lQMkv-ZrOJC-gKi8RbzndksKI5oeAj15wiYTInUGMftO7I6kJ-CoRDK7vD8M','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:56:59','2015-11-09 19:54:12','2015-11-09 19:56:59'),(4,1,'B1Admin::User','-kFFl6rX03n-IrPegz9ApJwG4gje1x_VJFFzL36OoX7mbThCzUXWuG-HHeJDoL2lkef4','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:57:52','2015-11-09 19:57:02','2015-11-09 19:57:52'),(5,1,'B1Admin::User','qwCt4fPDAu_Gu0kB7-VyiV31BiWOY067qgYsLKZ7AmaJ9g0kOe5YIV3BX-dOREK697AaNk_EVCn3iD6qLs81EGmteSfRrmuEIGcNboo','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 19:58:23','2015-11-09 19:57:55','2015-11-09 19:58:23'),(6,1,'B1Admin::User','3Ak8rjFZEgPiXkz6JQhONVPjltPzvnsT1KznsGPh7UawzIviZt_p2_K2t1WODhU_3HlWP2eXeJ2NfOdqPHstXZK4qZOM7Q','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 20:03:03','2015-11-09 19:58:26','2015-11-09 20:03:03'),(7,1,'B1Admin::User','hBUl06vf7Fh_hZiFCOID80XhwtqxvknTByMymlvJycTrDQc68uDtZ9HpCDZr2tFnDTxF1acsEWpbCVF-dcZXGXYs9o8VCshRevEt6VhI3SlyapV-dZd1','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 20:46:38','2015-11-09 20:03:07','2015-11-09 20:46:38'),(8,1,'B1Admin::User','mSXhbkJjy65VTIfhsEHxIXSGW7hBfsCpVFOyyNb8CkrTOkyzB4C6_tQOq_aZu1OFtf0zr8z4a0hQ1JwuoxpXLzE0Qt5N7kd-VKhMBpfd7CNGIF9-WtivpEnsCHgDopRBqU4','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 21:26:59','2015-11-09 20:46:40','2015-11-09 21:26:59'),(9,1,'B1Admin::User','SL5MTesp70ZoyHfdyL5mWZyEB4B4aXS6x7KTj1F53VIKjo0i7MJOR685nKrge_-lGaygKk9urA','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-09 22:44:41','2015-11-09 21:27:33','2015-11-09 21:44:41'),(10,1,'B1Admin::User','QsqDs1H5vhBf57yB4XY4wnn5JOXnSWS2vaBxCvYnXv_tUaiJrD1A3KGTsyJd34cKBCncFIhgsBKQunRHSL7UeQvKUBcr5B1oVzTwNKUKv3Q_yYEGjXQVYrIhNpvjjViP','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 10:17:05','2015-11-10 09:04:17','2015-11-10 09:17:05'),(11,1,'B1Admin::User','qx5iCqD30uj6zxsNKPiA_T6zhmT0NdHtcYzA3fmMsEKyg19Er5B0ztrAlMRN-5_Cr5raFhyp24Byimc4gj1TMXft9GlGXKmzWWdrlQ','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 10:19:36','2015-11-10 10:17:40','2015-11-10 10:19:36'),(12,1,'B1Admin::User','rRkf9mKs782gy9TPA_qTFk63wVUnFcTRVy2O59mXtbqOSUpyP9N5GmGFCX6NaW5-T70XDjtgEB1BzjNcOZ8Cn_dbdHnG-XsUVfEepJkN','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 13:55:44','2015-11-10 10:19:39','2015-11-10 12:55:44'),(13,1,'B1Admin::User','ISqo1qTJNoRzH76ZDi8B3NsLs4IMNXJlBLbOWk37egnt5cEuxT8LsHqv9Bl5eHZ-zY6t0YZ3Tz4b86muodBPHu4XzWDGexY8Xjp2THZeNwQ1R0b3x_OztM5vVKqLMH28zlI','http://localhost:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-10 21:24:44','2015-11-10 18:10:57','2015-11-10 20:24:44'),(14,1,'B1Admin::User','vRvYVrMSqkagw-sY_aCuvaBdZi74qqvpUWvTklVDwaYivRaw4cG_dOZkqwIA0l6Q2-cEbgCc','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-11 09:09:12','2015-11-11 07:57:27','2015-11-11 08:09:12'),(15,1,'B1Admin::User','ANRVtIFFSx9lEBa_ijFuenjbpeSdVEDrt0h153-nCZl78dOEMPVhWk_xFGKcw8VQog9edvXUKUm6fR37iMHh75qKWZA4a3tt8nbitvJedVgI2GPTFPYleANYbFoKRe9dwA0vcQ','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-11 10:39:10','2015-11-11 09:17:23','2015-11-11 09:39:10'),(16,1,'B1Admin::User','eExjfTaaJaJu05WMdfesO1-UE8OMu4aEq_GI-68Vq6W5y89gCxyPwDPIb1Y4UHEGqh4RhwQmn9GfUppEDvqunGVFQKs6lQcbTstiOio639xKzHlp3MHsW2Wez6A','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-11 14:17:19','2015-11-11 13:15:02','2015-11-11 13:17:19'),(17,1,'B1Admin::User','afWr5pd10t3DocQoomJ5G91IwbOUAIZthrDyHMz98paiHrOrIJU87HuTzUjdUx51l2ZyFnHubosVzPdCjT0A','http://0.0.0.0:3000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-12 21:15:39','2015-11-12 20:04:10','2015-11-12 20:15:39'),(18,1,'B1Admin::User','dTe0Nltf_9eT8Isp6JAzdHLTulnezDbsn7dR_8Z62Bt2hRK9vEQXJa0SJNco50bJeuIXxj_TqCPh8V2CepIv_xTsUde-JcF-O6aSKWZsEJOZpJ4','http://0.0.0.0:4000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-13 14:44:00','2015-11-13 10:12:35','2015-11-13 13:44:00'),(19,1,'B1Admin::User','zx0-Jy22H1ikV3Jzsc9fzX2qFKQPclq-WgIfE9_uASmLZBWviPat0gHE73rWGUbtOSc3ESOQxWVUvMmdBCq4PhGDhCJbLqu9gFqw_iXBrBTv_U298Lk','http://0.0.0.0:4000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-15 14:46:55','2015-11-15 12:25:45','2015-11-15 13:46:55'),(20,1,'B1Admin::User','i_NJ_UV7lBI2QSU8TDdozR2BYwhLSYvtHPfYI27JUdk4dyAnqkADzvSIVsecG4Uwi0-lh3t5nvmlRkq6Veg2ASleR6cwnwIQWEYYpGv3qgNryWVWVjLYEg7s8fiYFG88HyEF','http://0.0.0.0:4000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-16 15:48:37','2015-11-16 12:36:14','2015-11-16 14:48:37'),(21,1,'B1Admin::User','nBMw35xeFt04EBoH1_2WfVUM_9ViaK6S3p3fXCp4S5IzjT3NIkjZWUlAMR_F7CCAdO7rZv7JWvXdF2lpteXGxqgy9QT757N6ybPp','http://0.0.0.0:4000/admin/login','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36','127.0.0.1','2015-11-16 18:18:57','2015-11-16 17:11:16','2015-11-16 17:18:57');

/*Table structure for table `subscribers` */

DROP TABLE IF EXISTS `subscribers`;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `subscribers` */

insert  into `subscribers`(`id`,`name`,`email`,`phone`,`active`,`school_subscribe`,`club_subscribe`,`blog_subscribe`,`created_at`,`updated_at`,`course_id`) values (1,'fwefwefwefwefwe','wefwef@fwef.ew','wefweqf',1,0,1,0,'2015-11-11 09:33:25','2015-11-11 09:38:34',5),(2,'wergewrgewrg','wergergre@werfwe.few',NULL,1,0,0,1,'2015-11-16 10:43:49','2015-11-16 10:43:49',NULL),(3,'sadgqegfer','gewrgre@wef.wefew',NULL,1,0,0,1,'2015-11-16 10:57:53','2015-11-16 10:57:53',NULL),(4,'fevewwebgewr','gerger@wefwe.fwef',NULL,1,0,0,1,'2015-11-16 10:59:44','2015-11-16 10:59:44',NULL),(5,'avearweg','ergergre@wefwe.few',NULL,1,0,0,1,'2015-11-16 11:01:45','2015-11-16 11:01:45',NULL),(6,'werfqwefwe','wefwefwe@wfwef.wefwe','fwefwefweq',1,1,0,0,'2015-11-16 11:11:00','2015-11-16 11:11:00',0),(7,NULL,'wefwefwe@we.fwefwe',NULL,1,0,0,1,'2015-11-16 11:19:52','2015-11-16 11:19:52',NULL),(8,NULL,'wefwefwe@wefwef.few',NULL,1,0,0,1,'2015-11-16 11:24:08','2015-11-16 11:24:08',NULL),(9,NULL,'wefwefe@wef.wefew',NULL,1,0,0,1,'2015-11-16 11:24:35','2015-11-16 11:24:35',NULL),(10,'wfweqfwef','wefwefew@wefwef.wefew','wef51451',1,1,0,0,'2015-11-16 18:31:10','2015-11-16 18:31:10',0);

/*Table structure for table `teachers` */

DROP TABLE IF EXISTS `teachers`;

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

/*Data for the table `teachers` */

insert  into `teachers`(`id`,`name`,`desc`,`is_in_school`,`is_in_club`,`created_at`,`updated_at`,`logo_file_name`,`logo_content_type`,`logo_file_size`,`logo_updated_at`) values (1,'ergwergwregerwgrege','ergfergrewgre',1,1,'2015-11-09 21:40:05','2015-11-10 10:25:42','GtHjabb.png','image/png',526679,'2015-11-10 10:25:42'),(2,'ergre','gregerwgerwg',1,1,'2015-11-09 21:43:37','2015-11-10 10:25:49','download.jpg','image/jpeg',7470,'2015-11-10 10:25:49');

/*Table structure for table `upload_images` */

DROP TABLE IF EXISTS `upload_images`;

CREATE TABLE `upload_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `file_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_file_size` int(11) DEFAULT NULL,
  `file_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `upload_images` */

insert  into `upload_images`(`id`,`created_at`,`updated_at`,`file_file_name`,`file_content_type`,`file_file_size`,`file_updated_at`) values (1,'2015-11-10 18:51:21','2015-11-10 18:51:21','GtHjabb.png','image/png',526679,'2015-11-10 18:51:20'),(2,'2015-11-10 18:54:40','2015-11-10 18:54:40','вендетта.jpg','image/jpeg',19381,'2015-11-10 18:54:40');

/*Table structure for table `vacancies` */

DROP TABLE IF EXISTS `vacancies`;

CREATE TABLE `vacancies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `desc` text COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `vacancies` */

insert  into `vacancies`(`id`,`name`,`desc`,`active`,`created_at`,`updated_at`) values (1,'цкпаукпцкуп','уцкпуцкпуцкпцкупцкупку',1,'2015-11-10 09:15:43','2015-11-10 09:16:51'),(2,'цкпаукпцкуп','уцкпуцкпуцкпцкупцкупку',0,'2015-11-10 09:16:31','2015-11-10 09:16:31');

/*Table structure for table `versions` */

DROP TABLE IF EXISTS `versions`;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `versions` */

insert  into `versions`(`id`,`item_type`,`item_id`,`event`,`whodunnit`,`object`,`created_at`,`object_changes`) values (1,'Page',1,'update','1','---\nid: 1\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\"></p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 18:54:45.000000000 Z\nposition: \n','2015-11-10 18:57:29','---\ndesc:\n- \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\"></p>\'\n- \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nupdated_at:\n- 2015-11-10 18:54:45.000000000 Z\n- 2015-11-10 18:57:29.644593877 Z\n'),(2,'Page',1,'update','1','---\nid: 1\nlogo_file_name: \ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 18:57:29.000000000 Z\nposition: \nlogo_content_type: \nlogo_file_size: \nlogo_updated_at: \n','2015-11-10 19:37:35','---\nlogo_file_name:\n- \n- IMG_2668.jpg\nlogo_content_type:\n- \n- image/jpeg\nlogo_file_size:\n- \n- 377122\nlogo_updated_at:\n- \n- 2015-11-10 19:37:35.361340375 Z\nupdated_at:\n- 2015-11-10 18:57:29.000000000 Z\n- 2015-11-10 19:37:35.520812077 Z\n'),(3,'Page',2,'update','1','---\nid: 2\nlogo_file_name: \ncategory_id: 1\nseo_name: fqwefeqr\ndesc: regwergwergwergwregregre\nanons: ergegwregewrg\ntitle: fqwefeqr\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:56:02.000000000 Z\nupdated_at: 2015-11-10 18:56:02.000000000 Z\nposition: \nlogo_content_type: \nlogo_file_size: \nlogo_updated_at: \n','2015-11-10 19:37:52','---\nlogo_file_name:\n- \n- \"ппп_-_1.jpg\"\nlogo_content_type:\n- \n- image/jpeg\nlogo_file_size:\n- \n- 18204\nlogo_updated_at:\n- \n- 2015-11-10 19:37:52.768491902 Z\nupdated_at:\n- 2015-11-10 18:56:02.000000000 Z\n- 2015-11-10 19:37:52.892359386 Z\n'),(4,'Page',2,'update','1','---\nid: 2\nlogo_file_name: \"ппп_-_1.jpg\"\ncategory_id: 1\nseo_name: fqwefeqr\ndesc: regwergwergwergwregregre\nanons: ergegwregewrg\ntitle: fqwefeqr\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:56:02.000000000 Z\nupdated_at: 2015-11-10 19:37:52.000000000 Z\nposition: \nlogo_content_type: image/jpeg\nlogo_file_size: 18204\nlogo_updated_at: 2015-11-10 19:37:52.000000000 Z\n','2015-11-10 20:21:17','---\nlogo_file_name:\n- \"ппп_-_1.jpg\"\n- GtHjabb.png\nlogo_content_type:\n- image/jpeg\n- image/png\nlogo_file_size:\n- 18204\n- 526679\nlogo_updated_at:\n- 2015-11-10 19:37:52.000000000 Z\n- 2015-11-10 20:21:16.609407698 Z\nupdated_at:\n- 2015-11-10 19:37:52.000000000 Z\n- 2015-11-10 20:21:17.089355240 Z\n'),(5,'Page',1,'update','1','---\nid: 1\nlogo_file_name: IMG_2668.jpg\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 19:37:35.000000000 Z\nposition: \nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 19:37:35.000000000 Z\n','2015-11-10 20:21:26','---\nlogo_updated_at:\n- 2015-11-10 19:37:35.000000000 Z\n- 2015-11-10 20:21:25.930217489 Z\nlogo_file_name:\n- IMG_2668.jpg\n- IMG_2668.jpg\nupdated_at:\n- 2015-11-10 19:37:35.000000000 Z\n- 2015-11-10 20:21:26.166552842 Z\n'),(6,'Page',1,'update','1','---\nid: 1\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: 0\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 20:21:26.000000000 Z\nposition: \nlogo_file_name: IMG_2668.jpg\nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 20:21:25.000000000 Z\n','2015-11-10 20:23:12','---\nauthor:\n- 0\n- 0\nupdated_at:\n- 2015-11-10 20:21:26.000000000 Z\n- 2015-11-10 20:23:12.300207202 Z\n'),(7,'Page',1,'update','1','---\nid: 1\ncategory_id: 1\nseo_name: wefqwef\ndesc: \'<p>wqefwqefweqfweqfwefwefwefw<img src=\"/system/upload_images/2/original.png?1447181680\"\n  style=\"width: 300px;\">цйупкупкупу</p>\'\nanons: wqefqwefwqefwqe\ntitle: wefqwef\nactive: \'1\'\nauthor: \'0\'\ncreated_at: 2015-11-10 18:54:45.000000000 Z\nupdated_at: 2015-11-10 20:23:12.000000000 Z\nposition: \nlogo_file_name: IMG_2668.jpg\nlogo_content_type: image/jpeg\nlogo_file_size: 377122\nlogo_updated_at: 2015-11-10 20:21:25.000000000 Z\n','2015-11-10 20:24:42','---\nauthor:\n- \'0\'\n- ergewgewrgerge\nupdated_at:\n- 2015-11-10 20:23:12.000000000 Z\n- 2015-11-10 20:24:42.288067237 Z\n');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
