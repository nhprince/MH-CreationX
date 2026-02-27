-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 20, 2026 at 03:42 PM
-- Server version: 11.4.10-MariaDB
-- PHP Version: 8.4.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mhcreati_studio`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `details` text NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `actor_type` enum('staff','client','system') NOT NULL DEFAULT 'system',
  `actor_id` varchar(36) DEFAULT NULL,
  `project_id` varchar(20) DEFAULT NULL,
  `customer_id` varchar(20) DEFAULT NULL,
  `category` enum('project','finance','user','system') NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `action`, `details`, `user_name`, `actor_type`, `actor_id`, `project_id`, `customer_id`, `category`, `timestamp`) VALUES
(1, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 16:50:38'),
(2, 'Create Customer', 'Added new customer Prince (CU-3efc47)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'system', '2026-02-03 16:52:31'),
(3, 'Create Project', 'Created project Movie (PRJ-6cf53a5a)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 16:54:21'),
(4, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 16:57:46'),
(5, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 17:18:20'),
(6, 'Create Customer', 'Added new customer Mahin (CU-c545d9)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'system', '2026-02-03 17:20:53'),
(7, 'Create Project', 'Created project GUYGYUFGF (PRJ-c3a167f0)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 17:22:05'),
(8, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 17:26:15'),
(9, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 17:36:17'),
(10, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 17:39:52'),
(11, 'Add Expense', 'Recorded expense: Example (BDT 100)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'finance', '2026-02-03 17:40:59'),
(12, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 17:51:35'),
(13, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 18:09:11'),
(14, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 18:11:00'),
(15, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 18:28:00'),
(16, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 19:16:09'),
(17, 'Create Project', 'Created project Reel (PRJ-05aad999)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 19:22:42'),
(18, 'Create Customer', 'Added new customer Fahim (FAHIM-199)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'system', '2026-02-03 19:23:30'),
(19, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 19:24:42'),
(20, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 19:26:21'),
(21, 'Create Project', 'Created project Lenden (PRJ-3f0811f9)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 19:27:52'),
(22, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 19:29:20'),
(23, 'Create Project', 'Created project sdcscs (PRJ-c405892d)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 19:30:44'),
(24, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 19:31:26'),
(25, 'Create Project', 'Created project dfgveferf (PRJ-7d0cb1b3)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 19:31:33'),
(26, 'Create Project', 'Created project dvdvdsvdfvd (PRJ-55aea437)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 19:32:16'),
(27, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 19:34:40'),
(28, 'Create Project', 'Created project svdsvdv (PRJ-aaad4b3a)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 19:59:46'),
(29, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-03 20:19:19'),
(30, 'Create Project', 'Created project ewfdfvdf (PRJ-0fb99bec)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:19:55'),
(31, 'Create Project', 'Created project scvscvdfsvcdefr (PRJ-b31d3af6)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:20:32'),
(32, 'Create Project', 'Created project scfsdcfe (PRJ-d0df1526)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:20:58'),
(33, 'Create Project', 'Created project dscsdcdsc (PRJ-3480b699)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:21:19'),
(34, 'Create Project', 'Created project cwdscsdcades (PRJ-78c676bc)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:21:46'),
(35, 'Create Project', 'Created project dscxscx (PRJ-52d90ac9)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:24:00'),
(36, 'Create Project', 'Created project uujujui (PRJ-f2085680)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:24:41'),
(37, 'Create Project', 'Created project mhmhjmhjk (PRJ-b6b4eac0)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:25:23'),
(38, 'Create Project', 'Created project eswfsdvdf (PRJ-cc176685)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:26:50'),
(39, 'Create Project', 'Created project fgbfgbfg (PRJ-88db030e)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:27:21'),
(40, 'Create Project', 'Created project iku kuikiu (PRJ-648c2e45)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 20:28:24'),
(41, 'Create Project', 'Created project svdvd (PRJ-71a75f8b)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-03 21:23:34'),
(42, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 07:45:18'),
(43, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 07:48:30'),
(44, 'Create Customer', 'Added new customer nh P (NHP-491)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'system', '2026-02-04 07:51:23'),
(45, 'Add Expense', 'Recorded expense: 500 (BDT 500)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'finance', '2026-02-04 07:52:45'),
(46, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 08:15:40'),
(47, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 09:41:58'),
(48, 'Delete Project', 'Deleted project PRJ-b6b4eac0', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 09:42:09'),
(49, 'Delete Project', 'Deleted project PRJ-f2085680', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 09:42:12'),
(50, 'Delete Project', 'Deleted project PRJ-c405892d', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 09:42:23'),
(51, 'Delete Project', 'Deleted project PRJ-05aad999', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 09:42:28'),
(52, 'Delete Project', 'Deleted project PRJ-c3a167f0', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 09:42:31'),
(53, 'Delete Project', 'Deleted project PRJ-6cf53a5a', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 09:42:35'),
(54, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 09:45:23'),
(55, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 10:17:54'),
(56, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:06:33'),
(57, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:10:40'),
(58, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:17:56'),
(59, 'Create Customer', 'Added new customer Prince Prtadhan (PRINCEPR-707)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'system', '2026-02-04 14:18:19'),
(60, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:19:09'),
(61, 'Create Project', 'Created project Reels Video (PRJ-8e78b676)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 14:20:38'),
(62, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:23:30'),
(63, 'Login', 'Staff Login Success', 'Moazzem vai', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:29:56'),
(64, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:30:12'),
(65, 'Login', 'Staff Login Success', 'Prince', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:32:11'),
(66, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 14:33:50'),
(67, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:04:22'),
(68, 'Update Project', 'Updated project PRJ-8e78b676', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:04:29'),
(69, 'Update Project', 'Updated project PRJ-71a75f8b', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:06:01'),
(70, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:08:41'),
(71, 'Login', 'Staff Login Success', 'Prince', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:10:17'),
(72, 'Login', 'Staff Login Success', 'Prince', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:12:17'),
(73, 'Update Project', 'Updated project PRJ-648c2e45', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:33:34'),
(74, 'Create Project', 'Created project dsxv dfsvdfv (PRJ-fa8e975a)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:35:21'),
(75, 'Update Project', 'Updated project PRJ-fa8e975a', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:38:56'),
(76, 'Update Project', 'Updated project PRJ-88db030e', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:39:36'),
(77, 'Login', 'Staff Login Success', 'Prince', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:41:40'),
(78, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:41:53'),
(79, 'Login', 'Staff Login Success', 'Prince', 'system', NULL, NULL, NULL, 'user', '2026-02-04 15:42:30'),
(80, 'Update Project', 'Updated project PRJ-8e78b676', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:43:31'),
(81, 'Update Project', 'Updated project PRJ-fa8e975a', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:48:07'),
(82, 'Add Expense', 'Recorded expense: Phone (BDT 10000)', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'finance', '2026-02-04 15:49:03'),
(83, 'Update Project', 'Updated project PRJ-fa8e975a', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:50:13'),
(84, 'Update Project', 'Updated project PRJ-8e78b676', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 15:53:53'),
(85, 'Update Project', 'Updated project PRJ-fa8e975a', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:13:43'),
(86, 'Update Project', 'Updated project PRJ-fa8e975a', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:14:02'),
(87, 'Update Project', 'Updated project PRJ-fa8e975a', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:15:14'),
(88, 'Delete Project', 'Deleted project PRJ-8e78b676', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:15:20'),
(89, 'Update Project', 'Updated project PRJ-78c676bc', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:15:44'),
(90, 'Update Project', 'Updated project PRJ-0fb99bec', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:16:08'),
(91, 'Delete Project', 'Deleted project PRJ-7d0cb1b3', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:16:27'),
(92, 'Delete Project', 'Deleted project PRJ-3f0811f9', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-04 20:16:30'),
(93, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 04:08:52'),
(94, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 04:19:47'),
(95, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 04:33:56'),
(96, 'Update Project', 'Updated project PRJ-71a75f8b', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-05 04:35:56'),
(97, 'Update Project', 'Updated project PRJ-88db030e', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-05 04:36:52'),
(98, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 04:37:32'),
(99, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 04:38:54'),
(100, 'Update Project', 'Updated project PRJ-88db030e', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-05 04:39:15'),
(101, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 04:56:01'),
(102, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 05:00:13'),
(103, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 05:37:17'),
(104, 'Update Project', 'Updated project PRJ-cc176685', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'project', '2026-02-05 05:37:31'),
(105, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 06:28:44'),
(106, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 06:48:46'),
(107, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 07:58:45'),
(108, 'Update Project', 'Updated project PRJ-71a75f8b', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 08:13:34'),
(109, 'Update Project', 'Updated project PRJ-fa8e975a', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 08:14:06'),
(110, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 08:19:23'),
(111, 'Create Customer', 'Added new customer Emon Hossen (EMONHOSS-030)', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 08:44:49'),
(112, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 08:55:53'),
(113, 'Create Customer', 'Added new customer Abir Hasan (ABIRHASA-015)', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 09:01:22'),
(114, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 09:13:22'),
(115, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 09:14:11'),
(116, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 09:15:33'),
(117, 'Create Customer', 'Added new customer Bijoy (BIJO866)', 'contact@nhprince.dpdns.org', 'system', NULL, NULL, NULL, 'system', '2026-02-05 09:24:31'),
(118, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 09:35:23'),
(119, 'Create Customer', 'Added new customer Akram Khan (AKRA773)', 'prince@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 09:55:47'),
(120, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 09:55:51'),
(121, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:02:40'),
(122, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:03:16'),
(123, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:32:23'),
(124, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:35:45'),
(125, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:37:34'),
(126, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:40:19'),
(127, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:43:30'),
(128, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:54:27'),
(129, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 10:55:25'),
(130, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 11:06:33'),
(131, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 11:08:04'),
(132, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 11:12:36'),
(133, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 11:35:53'),
(134, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 11:38:17'),
(135, 'Create Customer', 'Added new customer abir ahmmed (ABIR397)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 11:38:34'),
(136, 'Create Customer', 'Added new customer fvuhjguyg (FVUH187)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 11:39:12'),
(137, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 11:42:21'),
(138, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 12:30:49'),
(139, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 12:44:33'),
(140, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 12:55:52'),
(141, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 12:58:10'),
(142, 'Login', 'Staff Login Success', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 13:01:58'),
(143, 'Update', 'Email changed', 'Administrator', 'system', NULL, NULL, NULL, 'user', '2026-02-05 13:09:17'),
(144, 'Login', 'Staff Login Success', 'nurulhudaprince18@gmail.com', 'system', NULL, NULL, NULL, 'user', '2026-02-05 13:09:52'),
(145, 'Login', 'Staff Login Success', 'nurulhudaprince18@gmail.com', 'system', NULL, NULL, NULL, 'user', '2026-02-05 13:12:21'),
(146, 'Login', 'Staff Login Success', 'nurulhudaprince18@gmail.com', 'system', NULL, NULL, NULL, 'user', '2026-02-05 13:14:16'),
(147, 'Login', 'Staff Login Success', 'nurulhudaprince18@gmail.com', 'system', NULL, NULL, NULL, 'user', '2026-02-05 13:20:11'),
(148, 'Login', 'Staff Login Success', 'nurulhudaprince18@gmail.com', 'system', NULL, NULL, NULL, 'user', '2026-02-05 14:48:35'),
(149, 'Create Customer', 'Added new customer Mahamudul Hasan Shovon (MAHA432)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 14:57:43'),
(150, 'Create Project', 'Created project Urbo ami Fainal (PRJ-5eba46b7)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 15:02:57'),
(151, 'Create Customer', 'Added new customer Faizul Kabir Rothi (FAIZ760)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 15:06:37'),
(152, 'Create Project', 'Created project বড়জন POSTER-2 (PRJ-8ac7758c)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 15:08:42'),
(153, 'Update Project', 'Updated project PRJ-8ac7758c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 15:09:49'),
(154, 'Update Project', 'Updated project PRJ-8ac7758c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 15:10:04'),
(155, 'Create Project', 'Created project বড়জন POSTER-1 (PRJ-b4539fe1)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-05 15:11:32'),
(156, 'Create Customer', 'Added new customer BHAI BROTHERS (BHAI034)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 15:22:06'),
(157, 'Create Customer', 'Added new customer Shuvro Mehrazz (SHUV584)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-05 17:06:48'),
(158, 'Create Project', 'Created project এলাকার মুরুব্বি (PRJ-208c963c)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 06:34:54'),
(159, 'Create Project', 'Created project বিষের ছুরি (PRJ-513a86b6)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 06:36:57'),
(160, 'Create Project', 'Created project বাবার স্বপ্ন (PRJ-de49b199)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 07:40:33'),
(161, 'Create Project', 'Created project বড়জন POSTER-3 (PRJ-0ee1acac)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 08:20:45'),
(162, 'Update Project', 'Updated project PRJ-0ee1acac', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 08:21:17'),
(163, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 08:21:39'),
(164, 'Update Project', 'Updated project PRJ-208c963c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 08:22:01'),
(165, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 08:22:16'),
(166, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-06 08:29:40'),
(167, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-06 12:31:11'),
(168, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 12:31:32'),
(169, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 12:32:38'),
(170, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-06 12:51:21'),
(171, 'Update Project', 'Updated project PRJ-5eba46b7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 14:45:32'),
(172, 'Update Project', 'Updated project PRJ-5eba46b7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 16:38:31'),
(173, 'Create Customer', 'Added new customer RM RAFI SARDAR (RMRA690)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-06 16:57:03'),
(174, 'Update Project', 'Updated project PRJ-5eba46b7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 17:27:33'),
(175, 'Update Project', 'Updated project PRJ-5eba46b7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:46:57'),
(176, 'Update Project', 'Updated project PRJ-5eba46b7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:47:15'),
(177, 'Update Project', 'Updated project PRJ-208c963c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:48:46'),
(178, 'Update Project', 'Updated project PRJ-513a86b6', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:50:07'),
(179, 'Update Project', 'Updated project PRJ-208c963c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:50:22'),
(180, 'Update Project', 'Updated project PRJ-513a86b6', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:50:34'),
(181, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:52:21'),
(182, 'Update Project', 'Updated project PRJ-8ac7758c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:52:39'),
(183, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-06 21:55:59'),
(184, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:56:32'),
(185, 'Update Project', 'Updated project PRJ-8ac7758c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-06 21:56:40'),
(186, 'Add Expense', 'Recorded expense: Poket mony (BDT 100)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'finance', '2026-02-06 22:03:07'),
(187, 'Create Customer', 'Added new customer Sheikh Sakib Actor (SHEI043)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-07 08:17:28'),
(188, 'Add Expense', 'Recorded expense: Poket Money  (BDT 100)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'finance', '2026-02-07 11:54:56'),
(189, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-07 13:18:12'),
(190, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-08 14:50:11'),
(191, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-08 14:50:51'),
(192, 'Create Customer', 'Added new customer Zaher Alvi (ZAHE124)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-08 15:41:56'),
(193, 'Create Customer', 'Added new customer Mohon Islam (MOHO118)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-08 15:45:20'),
(194, 'Create Customer', 'Added new customer Ashik Vahi (ASHI205)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-08 18:35:38'),
(195, 'Create Customer', 'Added new customer RM RAFI SARDAR (RMRA367)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-08 21:47:36'),
(196, 'Create Project', 'Created project শখের মানুষ POSTER-1 (PRJ-b8318eb0)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-08 21:49:13'),
(197, 'Update Project', 'Updated project PRJ-b8318eb0', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-08 21:50:56'),
(198, 'Update Project', 'Updated project PRJ-b8318eb0', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-08 22:13:02'),
(199, 'Update Project', 'Updated project PRJ-b8318eb0', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-08 22:30:45'),
(200, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-09 05:12:36'),
(201, 'Update Project', 'Updated project PRJ-b8318eb0', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-09 05:12:48'),
(202, 'Create Project', 'Created project THABA POSTER 1 (PRJ-c3e6ca23)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-09 10:36:50'),
(203, 'Update Project', 'Updated project PRJ-c3e6ca23', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-09 10:38:14'),
(204, 'Update Project', 'Updated project PRJ-c3e6ca23', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-09 13:02:04'),
(205, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-09 15:27:33'),
(206, 'Update Project', 'Updated project PRJ-b8318eb0', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-09 15:27:41'),
(207, 'Create Customer', 'Added new customer Rakib Ahmmed (RAKI672)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-10 08:20:35'),
(208, 'Create Project', 'Created project Churi Cham Cham (PRJ-fa97287d)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 08:23:17'),
(209, 'Create Customer', 'Added new customer Streamo Digital (STRE716)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-10 08:27:56'),
(210, 'Create Project', 'Created project PORANER PAKHI (PRJ-9f9e348f)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 08:30:08'),
(211, 'Create Project', 'Created project Tagar Romantic (PRJ-0c2012df)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:44:18'),
(212, 'Update Project', 'Updated project PRJ-0c2012df', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:44:39'),
(213, 'Create Project', 'Created project Tagar Actione (PRJ-03b646be)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:48:19'),
(214, 'Create Customer', 'Added new customer Demo Customer (DEMO325)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-10 10:49:23'),
(215, 'Create Project', 'Created project XYZ (PRJ-eeb55726)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:54:51'),
(216, 'Create Project', 'Created project DEMO 2 (PRJ-1876ca41)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:56:05'),
(217, 'Update Project', 'Updated project PRJ-1876ca41', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:56:28'),
(218, 'Update Project', 'Updated project PRJ-1876ca41', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:56:38'),
(219, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-10 10:59:37'),
(220, 'Update Project', 'Updated project PRJ-1876ca41', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-10 10:59:53'),
(221, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-11 13:11:42'),
(222, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-11 13:14:14'),
(223, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-12 09:43:06'),
(224, 'Create Customer', 'Added new customer Gourob GoGo (GOUR342)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-12 09:43:52'),
(225, 'Delete Project', 'Deleted project PRJ-eeb55726', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-12 09:45:02'),
(226, 'Delete Project', 'Deleted project PRJ-1876ca41', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-12 09:45:04'),
(227, 'Create Project', 'Created project আমি এমন একজন মানুষ পাইলাম না (PRJ-d57896d2)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-12 09:58:23'),
(228, 'Update Project', 'Updated project PRJ-d57896d2', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-12 10:59:30'),
(229, 'Create Customer', 'Added new customer Shamim Ahsan (SHAM526)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-12 20:16:27'),
(230, 'Create Project', 'Created project ভালবাসা ফিরে আসে (PRJ-5187edf7)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-12 20:17:56'),
(231, 'Update Project', 'Updated project PRJ-5187edf7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-12 20:18:17'),
(232, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-13 06:58:44'),
(233, 'Create Customer', 'Added new customer Sk Sameer (SKSA114)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-13 06:59:19'),
(234, 'Create Project', 'Created project Chupi Chupi (PRJ-a893f2df)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-13 07:01:20'),
(235, 'Update Project', 'Updated project PRJ-a893f2df', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-13 07:03:48'),
(236, 'Update Project', 'Updated project PRJ-a893f2df', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-13 07:04:04'),
(237, 'Create Project', 'Created project দেশী নির্বাচন (PRJ-cb2d8789)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-13 07:54:00'),
(238, 'Update Project', 'Updated project PRJ-5187edf7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-13 07:56:08'),
(239, 'Add Expense', 'Recorded expense: schiushcn (BDT 500)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'finance', '2026-02-13 16:26:20'),
(240, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-13 18:42:24'),
(241, 'Create Customer', 'Added new customer Shimul Chowdhury (SHIM080)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-14 07:23:37'),
(242, 'Update Project', 'Updated project PRJ-cb2d8789', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 07:26:27'),
(243, 'Update Project', 'Updated project PRJ-de49b199', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 07:26:34'),
(244, 'Login', 'Staff Login Success', 'Lullu VAi', 'system', NULL, NULL, NULL, 'user', '2026-02-14 07:37:27'),
(245, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'system', NULL, NULL, NULL, 'user', '2026-02-14 07:39:11'),
(246, 'Create Project', 'Created project বাংলা আমার মায়ের ভাষা (PRJ-50485094)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 08:41:54'),
(247, 'Update Project', 'Updated project PRJ-50485094', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 08:42:28'),
(248, 'Update Project', 'Updated project PRJ-50485094', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 08:43:07'),
(249, 'Update Project', 'Updated project PRJ-50485094', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 08:44:54'),
(250, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-14 08:47:53'),
(251, 'Create Project', 'Created project ভালবাসা ফিরে আসে POSTER (PRJ-ac7bb13d)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 09:32:48'),
(252, 'Update Project', 'Updated project PRJ-ac7bb13d', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 09:33:28'),
(253, 'Update Project', 'Updated project PRJ-50485094', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 09:42:07'),
(254, 'Update Project', 'Updated project PRJ-8ac7758c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 09:57:11'),
(255, 'Update Project', 'Updated project PRJ-cb2d8789', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 09:57:52'),
(256, 'Update Project', 'Updated project PRJ-8ac7758c', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 09:59:13'),
(257, 'Create Customer', 'Added new customer Prince Khan (PRIN967)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'system', '2026-02-14 11:32:27'),
(258, 'Create Project', 'Created project লাঙ্গে এখন উধাও (PRJ-30f84505)', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 11:33:08'),
(259, 'Update Project', 'Updated project PRJ-30f84505', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 11:33:31'),
(260, 'Update Project', 'Updated project PRJ-30f84505', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 11:33:43'),
(261, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'system', NULL, NULL, NULL, 'user', '2026-02-14 17:45:40'),
(262, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'system', NULL, NULL, NULL, 'user', '2026-02-14 17:45:55'),
(263, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-14 17:48:54'),
(264, 'Update Project', 'Updated project PRJ-5187edf7', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 17:49:08'),
(265, 'Update Project', 'Updated project PRJ-ac7bb13d', 'mhcreationx@gmail.com', 'system', NULL, NULL, NULL, 'project', '2026-02-14 17:49:16'),
(266, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'system', NULL, NULL, NULL, 'user', '2026-02-15 06:10:06'),
(267, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'system', NULL, NULL, NULL, 'user', '2026-02-15 06:11:22'),
(268, 'Login', 'Staff Login Success', 'Test', 'system', NULL, NULL, NULL, 'user', '2026-02-15 06:14:51'),
(269, 'Login', 'Staff Login Success', 'Test', 'system', NULL, NULL, NULL, 'user', '2026-02-15 06:15:26'),
(270, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'system', NULL, NULL, NULL, 'user', '2026-02-15 06:15:50'),
(271, 'Login', 'Staff Login Success', 'Mh Creation X', 'system', NULL, NULL, NULL, 'user', '2026-02-15 06:19:47'),
(272, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 08:40:55'),
(273, 'Create Project', 'Created project Test Project (PRJ-334db1d9)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-334db1d9', 'PRIN967', 'project', '2026-02-15 08:43:04'),
(274, 'Client Login', 'Client Login Success (PRIN967)', 'Prince Khan', 'client', NULL, NULL, 'PRIN967', 'system', '2026-02-15 08:43:48'),
(275, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 08:44:18'),
(276, 'Update Project', 'Updated fields: paid_amount, payment_status, payment_method, payment_details for project PRJ-334db1d9', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-334db1d9', 'PRIN967', 'project', '2026-02-15 08:45:18'),
(277, 'Delete Project', 'Deleted project PRJ-334db1d9', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-334db1d9', NULL, 'project', '2026-02-15 08:45:41'),
(278, 'Upload Client Photo', 'Uploaded profile image for customer PRIN967', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'PRIN967', 'system', '2026-02-15 08:51:05'),
(279, 'Create Customer', 'Added new customer Test Client (TEST022)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST022', 'system', '2026-02-15 08:52:44'),
(280, 'Upload Client Photo', 'Uploaded profile image for customer TEST022', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST022', 'system', '2026-02-15 08:53:07'),
(281, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-15 08:53:52'),
(282, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 08:54:10'),
(283, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:04:27'),
(284, 'Delete User', 'Deleted user 8a3c7291-0a35-11f1-a292-9c6b0053504c', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:05:32'),
(285, 'Create User', 'Created user test (89319948-0a4d-11f1-a292-9c6b0053504c) with role Team', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:05:52'),
(286, 'Login', 'Staff Login Success', 'test', 'staff', '89319948-0a4d-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:06:35'),
(287, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:08:07'),
(288, 'Upload Client Photo', 'Uploaded profile image for customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-15 09:09:45'),
(289, 'Client Login', 'Client Login Success (BHAI034)', 'BHAI BROTHERS', 'client', NULL, NULL, 'BHAI034', 'system', '2026-02-15 09:10:36'),
(290, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:29:42'),
(291, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-15 09:30:53'),
(292, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:31:24'),
(293, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-15 09:44:51'),
(294, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:50:09'),
(295, 'Create Project', 'Created project Test Project (PRJ-dc22e00b)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-dc22e00b', 'TEST022', 'project', '2026-02-15 09:52:03'),
(296, 'Update Project', 'Updated payment for Test Project (PRJ-dc22e00b). Received ৳100.00 of ৳100.00; status: Paid; method: Cash', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-dc22e00b', 'TEST022', 'project', '2026-02-15 09:52:18'),
(297, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-15 09:52:29'),
(298, 'Upload Client Photo', 'Uploaded profile image for customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-15 09:53:14'),
(299, 'Login', 'Staff Login Success', 'test', 'staff', '89319948-0a4d-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 09:53:47'),
(300, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:17:20'),
(301, 'Delete User Denied', 'Denied attempt to delete admin user a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:18:02'),
(302, 'Delete User Denied', 'Denied attempt to delete admin user a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:18:06'),
(303, 'Delete User Denied', 'Denied attempt to delete admin user a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:18:07'),
(304, 'Delete User', 'Deleted user 89319948-0a4d-11f1-a292-9c6b0053504c', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:18:09'),
(305, 'Create User', 'Created user test (7d963612-0a59-11f1-a292-9c6b0053504c) with role Team', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:31:27'),
(306, 'Login', 'Staff Login Success', 'test', 'staff', '7d963612-0a59-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-15 10:31:43'),
(307, 'Create Customer', 'Added new customer mshgf (MSHG102)', 'test@test.com', 'staff', '7d963612-0a59-11f1-a292-9c6b0053504c', NULL, 'MSHG102', 'system', '2026-02-15 10:32:06'),
(308, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-15 10:51:49'),
(309, 'Upload Client Photo', 'Uploaded profile image for customer PRIN967', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'PRIN967', 'system', '2026-02-15 16:51:33'),
(310, 'Client Login', 'Client Login Success (PRIN967)', 'Prince Khan', 'client', NULL, NULL, 'PRIN967', 'system', '2026-02-15 16:56:40'),
(311, 'Client Login', 'Client Login Success (SKSA114)', 'Sk Sameer', 'client', NULL, NULL, 'SKSA114', 'system', '2026-02-15 17:01:42'),
(312, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-15 17:51:02'),
(313, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-16 04:43:14'),
(314, 'Create User', 'Created user test123 (93778f92-0af7-11f1-a292-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-16 05:23:03'),
(315, 'Login', 'Staff Login Success', 'test123', 'staff', '93778f92-0af7-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-16 05:23:28'),
(316, 'Create Customer', 'Added new customer BJHJBHXGBx (BJHJ368)', 'mahi@123', 'staff', '93778f92-0af7-11f1-a292-9c6b0053504c', NULL, 'BJHJ368', 'system', '2026-02-16 05:23:58'),
(317, 'Create Customer', 'Added new customer BHIJIUHIUH (BHIJ006)', 'mahi@123', 'staff', '93778f92-0af7-11f1-a292-9c6b0053504c', NULL, 'BHIJ006', 'system', '2026-02-16 05:24:15'),
(318, 'Delete User', 'Deleted user 93778f92-0af7-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-16 05:25:56'),
(319, 'Create Project', 'Created project কি মায়া POSTER-1 (PRJ-961bcb86)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-961bcb86', 'FAIZ760', 'project', '2026-02-16 17:20:35'),
(320, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 09:28:54'),
(321, 'Client Login', 'Client Login Success (PRIN967)', 'Prince Khan', 'client', NULL, NULL, 'PRIN967', 'system', '2026-02-17 09:32:50'),
(322, 'Delete Customer', 'Deleted customer BHIJ006', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'BHIJ006', 'system', '2026-02-17 10:20:59'),
(323, 'Delete Customer', 'Deleted customer BJHJ368', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'BJHJ368', 'system', '2026-02-17 10:21:05'),
(324, 'Delete Customer', 'Deleted customer MSHG102', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'MSHG102', 'system', '2026-02-17 10:21:08'),
(325, 'Delete User', 'Deleted user 7d963612-0a59-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 10:21:15'),
(326, 'Create User', 'Created user Text123 (81d1572a-0bea-11f1-a292-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 10:22:01'),
(327, 'Delete User', 'Deleted user 81d1572a-0bea-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 10:23:04'),
(328, 'Create User', 'Created user test123 (b0f137ad-0bea-11f1-a292-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 10:23:20'),
(329, 'Login', 'Staff Login Success', 'test123', 'staff', 'b0f137ad-0bea-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 10:23:32'),
(330, 'Create Customer', 'Added new customer Mahin (MAHI576)', 'test@123', 'staff', 'b0f137ad-0bea-11f1-a292-9c6b0053504c', NULL, 'MAHI576', 'system', '2026-02-17 10:25:34'),
(331, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 10:42:58'),
(332, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-17 10:45:16'),
(333, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 10:47:01'),
(334, 'Delete Customer', 'Deleted customer MAHI576', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'MAHI576', 'system', '2026-02-17 10:52:01'),
(335, 'Update Customer', 'Updated fields: status for customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-17 10:52:42'),
(336, 'Update Customer', 'Updated fields: status for customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-17 10:52:44'),
(337, 'Update Customer', 'Updated fields: status for customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-17 10:52:49'),
(338, 'Update Customer', 'Updated fields: status for customer PRIN967', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'PRIN967', 'system', '2026-02-17 10:52:50'),
(339, 'Update Customer', 'Updated fields: status for customer PRIN967', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'PRIN967', 'system', '2026-02-17 10:54:41'),
(340, 'Update Customer', 'Updated fields: status for customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-17 10:54:42'),
(341, 'Delete Project', 'Deleted project PRJ-dc22e00b', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-dc22e00b', NULL, 'project', '2026-02-17 10:55:32'),
(342, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳500.00 of ৳500.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 10:55:36'),
(343, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 10:55:42'),
(344, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳500.00 of ৳500.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 10:55:46'),
(345, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 10:56:09'),
(346, 'Update Project', 'Updated payment for Urbo ami Fainal (PRJ-5eba46b7). Received ৳5000.00 of ৳10000.00; status: Paid; method: Bank', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-5eba46b7', 'MAHA432', 'project', '2026-02-17 10:56:21');
INSERT INTO `audit_logs` (`id`, `action`, `details`, `user_name`, `actor_type`, `actor_id`, `project_id`, `customer_id`, `category`, `timestamp`) VALUES
(347, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-17 10:56:38'),
(348, 'Create Project', 'Created project test project (PRJ-a656d6da)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 10:57:48'),
(349, 'Client Login', 'Client Login Success (TEST022)', 'Test Client', 'client', NULL, NULL, 'TEST022', 'system', '2026-02-17 10:58:36'),
(350, 'Client Login', 'Client Login Success (PRIN967)', 'Prince Khan', 'client', NULL, NULL, 'PRIN967', 'system', '2026-02-17 10:58:48'),
(351, 'Update Project', 'Updated payment for test project (PRJ-a656d6da). Received ৳0.00 of ৳10.00; status: Unpaid; method: None', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 10:59:07'),
(352, 'Update Project', 'Updated payment for test project (PRJ-a656d6da). Received ৳10.00 of ৳10.00; status: Paid; method: Cash', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 11:00:05'),
(353, 'Login', 'Staff Login Success', 'test123', 'staff', 'b0f137ad-0bea-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 11:08:41'),
(354, 'Client Login', 'Client Login Success (PRIN967)', 'Prince Khan', 'client', NULL, NULL, 'PRIN967', 'system', '2026-02-17 11:14:07'),
(355, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 11:14:59'),
(356, 'Client Login', 'Client Login Success (PRIN967)', 'Prince Khan', 'client', NULL, NULL, 'PRIN967', 'system', '2026-02-17 11:15:13'),
(357, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳500.00 of ৳500.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 11:15:28'),
(358, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 12:09:23'),
(359, 'Update Project', 'Updated payment for test project (PRJ-a656d6da). Received ৳2.00 of ৳10.00; status: Unpaid; method: None', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 12:09:26'),
(360, 'Update Project', 'Updated payment for test project (PRJ-a656d6da). Received ৳10.00 of ৳10.00; status: Paid; method: Cash', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 12:09:43'),
(361, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 13:08:09'),
(362, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 13:11:19'),
(363, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 13:30:04'),
(364, 'Update Project', 'Updated payment for test project (PRJ-a656d6da). Received ৳2.00 of ৳10.00; status: Unpaid; method: None', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 14:25:54'),
(365, 'Update Project', 'Updated payment for test project (PRJ-a656d6da). Received ৳10.00 of ৳10.00; status: Paid; method: Cash', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a656d6da', 'TEST022', 'project', '2026-02-17 14:26:01'),
(366, 'Add Expense', 'Recorded expense: test expense (BDT 100)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'finance', '2026-02-17 15:21:16'),
(367, 'Delete Expense', 'Deleted expense ID 7', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'finance', '2026-02-17 15:21:30'),
(368, 'Delete Project', 'Deleted project PRJ-a656d6da', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-a656d6da', NULL, 'project', '2026-02-17 16:38:32'),
(369, 'Delete Customer', 'Deleted customer TEST022', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'TEST022', 'system', '2026-02-17 16:38:48'),
(370, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 16:39:44'),
(371, 'Update Project', 'Updated payment for লাঙ্গে এখন উধাও (PRJ-30f84505). Received ৳500.00 of ৳500.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-30f84505', 'PRIN967', 'project', '2026-02-17 16:39:53'),
(372, 'Delete Expense', 'Deleted expense ID 4', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-17 16:40:23'),
(373, 'Add Expense', 'Recorded expense: MaHi Phone (BDT 10000)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-17 16:40:53'),
(374, 'Add Expense', 'Recorded expense: Basha  Bazar (BDT 4000)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-17 16:42:07'),
(375, 'Add Expense', 'Recorded expense: Web (BDT 2000)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-17 16:42:26'),
(376, 'Add Expense', 'Recorded expense: Adobe (BDT 250)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-17 16:42:37'),
(377, 'Update Project', 'Updated payment for আমি এমন একজন মানুষ পাইলাম না (PRJ-d57896d2). Received ৳1000.00 of ৳1000.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-d57896d2', 'GOUR342', 'project', '2026-02-17 16:43:29'),
(378, 'Create Project', 'Created project টিকটকারের লিংক ভাইরাল (PRJ-cc99bcc5)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-cc99bcc5', 'BHAI034', 'project', '2026-02-17 16:48:26'),
(379, 'Update Project', 'Updated payment for টিকটকারের লিংক ভাইরাল (PRJ-cc99bcc5). Received ৳700.00 of ৳700.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-cc99bcc5', 'BHAI034', 'project', '2026-02-17 16:48:31'),
(380, 'Client Login', 'Client Login Success (BHAI034)', 'BHAI BROTHERS', 'client', NULL, NULL, 'BHAI034', 'system', '2026-02-17 16:49:13'),
(381, 'Update Project', 'Updated payment for টিকটকারের লিংক ভাইরাল (PRJ-cc99bcc5). Received ৳700.00 of ৳700.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-cc99bcc5', 'BHAI034', 'project', '2026-02-17 16:49:43'),
(382, 'Create Customer', 'Added new customer Doelbd Apurbo (DOEL464)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'DOEL464', 'system', '2026-02-17 16:55:56'),
(383, 'Create Project', 'Created project TVC Doelbd (PRJ-e9bfed2d)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-17 17:05:14'),
(384, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳12800.00 of ৳12800.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-17 17:05:30'),
(385, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-17 17:05:41'),
(386, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-17 17:07:47'),
(387, 'Upload Client Photo', 'Uploaded profile image for customer DOEL464', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'DOEL464', 'system', '2026-02-17 17:09:55'),
(388, 'Client Login', 'Client Login Success (DOEL464)', 'Doelbd Apurbo', 'client', NULL, NULL, 'DOEL464', 'system', '2026-02-17 17:11:57'),
(389, 'Client Login', 'Client Login Success (DOEL464)', 'Doelbd Apurbo', 'client', NULL, NULL, 'DOEL464', 'system', '2026-02-17 17:27:24'),
(390, 'Create Customer', 'Added new customer Dipta Das (DIPT409)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'DIPT409', 'system', '2026-02-17 17:30:07'),
(391, 'Upload Client Photo', 'Uploaded profile image for customer DIPT409', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'DIPT409', 'system', '2026-02-17 17:30:25'),
(392, 'Client Login', 'Client Login Success (DIPT409)', 'Dipta Das', 'client', NULL, NULL, 'DIPT409', 'system', '2026-02-17 17:31:32'),
(393, 'Client Login', 'Client Login Success (DIPT409)', 'Dipta Das', 'client', NULL, NULL, 'DIPT409', 'system', '2026-02-17 17:32:11'),
(394, 'Create Project', 'Created project AAAAA (PRJ-8f57561f)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-8f57561f', 'DIPT409', 'project', '2026-02-17 17:33:06'),
(395, 'Update Project', 'Updated payment for AAAAA (PRJ-8f57561f). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-8f57561f', 'DIPT409', 'project', '2026-02-17 17:35:43'),
(396, 'Update Project', 'Updated payment for AAAAA (PRJ-8f57561f). Received ৳500.00 of ৳500.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-8f57561f', 'DIPT409', 'project', '2026-02-17 17:36:14'),
(397, 'Update Project', 'Updated payment for AAAAA (PRJ-8f57561f). Received ৳100.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-8f57561f', 'DIPT409', 'project', '2026-02-17 17:36:23'),
(398, 'Delete Project', 'Deleted project PRJ-8f57561f', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-8f57561f', NULL, 'project', '2026-02-17 17:37:56'),
(399, 'Delete User', 'Deleted user b0f137ad-0bea-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 17:45:32'),
(400, 'Create User', 'Created user test123 (80962f86-0c28-11f1-a292-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 17:45:48'),
(401, 'Login', 'Staff Login Success', 'test123', 'staff', '80962f86-0c28-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-17 17:46:00'),
(402, 'Create Customer', 'Added new customer Dip (DIP240)', 'test@123', 'staff', '80962f86-0c28-11f1-a292-9c6b0053504c', NULL, 'DIP240', 'system', '2026-02-17 17:46:18'),
(403, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 18:05:53'),
(404, 'Update Project', 'Updated payment for Tagar Actione (PRJ-03b646be). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-03b646be', 'STRE716', 'project', '2026-02-17 18:06:12'),
(405, 'Update Project', 'Updated payment for Tagar Romantic (PRJ-0c2012df). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-0c2012df', 'STRE716', 'project', '2026-02-17 18:06:27'),
(406, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-17 18:46:35'),
(407, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-17 18:47:11'),
(408, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-17 18:47:46'),
(409, 'Update Project', 'Updated payment for Urbo ami Fainal (PRJ-5eba46b7). Received ৳10000.00 of ৳10000.00; status: Paid; method: Bank', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-5eba46b7', 'MAHA432', 'project', '2026-02-17 18:48:20'),
(410, 'Client Login', 'Client Login Success (ZAHE124)', 'Zaher Alvi', 'client', NULL, NULL, 'ZAHE124', 'system', '2026-02-17 18:48:47'),
(411, 'Client Login', 'Client Login Success (RMRA690)', 'RM RAFI SARDAR', 'client', NULL, NULL, 'RMRA690', 'system', '2026-02-17 18:49:10'),
(412, 'Client Login', 'Client Login Success (FAIZ760)', 'Faizul Kabir Rothi', 'client', NULL, NULL, 'FAIZ760', 'system', '2026-02-17 18:49:53'),
(413, 'Upload Client Photo', 'Uploaded profile image for customer FAIZ760', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'FAIZ760', 'system', '2026-02-17 18:50:30'),
(414, 'Upload Client Photo', 'Uploaded profile image for customer MAHA432', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'MAHA432', 'system', '2026-02-17 18:51:51'),
(415, 'Upload Client Photo', 'Uploaded profile image for customer BHAI034', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'BHAI034', 'system', '2026-02-17 18:52:22'),
(416, 'Upload Client Photo', 'Uploaded profile image for customer SHUV584', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'SHUV584', 'system', '2026-02-17 18:52:51'),
(417, 'Update Customer', 'Updated fields: status for customer DIP240', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'DIP240', 'system', '2026-02-17 18:53:37'),
(418, 'Delete Customer', 'Deleted customer DIP240', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'DIP240', 'system', '2026-02-17 18:53:40'),
(419, 'Create Project', 'Created project Purosh Sokhe Nari Mol (PRJ-2dd6504b)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-2dd6504b', 'SHEI043', 'project', '2026-02-17 20:10:00'),
(420, 'Upload Client Photo', 'Uploaded profile image for customer SHEI043', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'SHEI043', 'system', '2026-02-17 20:11:45'),
(421, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-17 20:45:51'),
(422, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-18 05:31:24'),
(423, 'Create Project', 'Created project কি মায়া POSTER-2 (PRJ-f7542499)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-f7542499', 'FAIZ760', 'project', '2026-02-18 05:33:14'),
(424, 'Update Project', 'Updated payment for ভালবাসা ফিরে আসে POSTER (PRJ-ac7bb13d). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-ac7bb13d', 'DEMO325', 'project', '2026-02-18 05:33:35'),
(425, 'Update Project', 'Updated payment for PORANER PAKHI (PRJ-9f9e348f). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-9f9e348f', 'RAKI672', 'project', '2026-02-18 05:34:01'),
(426, 'Client Login', 'Client Login Success (FAIZ760)', 'Faizul Kabir Rothi', 'client', NULL, NULL, 'FAIZ760', 'system', '2026-02-18 05:34:56'),
(427, 'Client Login', 'Client Login Success (BHAI034)', 'BHAI BROTHERS', 'client', NULL, NULL, 'BHAI034', 'system', '2026-02-18 05:36:04'),
(428, 'Client Login', 'Client Login Success (SHUV584)', 'Shuvro Mehrazz', 'client', NULL, NULL, 'SHUV584', 'system', '2026-02-18 05:36:19'),
(429, 'Update Project', 'Updated payment for কি মায়া POSTER-1 (PRJ-961bcb86). Received ৳0.00 of ৳1500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-961bcb86', 'FAIZ760', 'project', '2026-02-18 05:48:53'),
(430, 'Update Project', 'Updated payment for কি মায়া POSTER-2 (PRJ-f7542499). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-f7542499', 'FAIZ760', 'project', '2026-02-18 05:49:30'),
(431, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-2dd6504b). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-2dd6504b', 'SHEI043', 'project', '2026-02-18 06:18:36'),
(432, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-2dd6504b). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-2dd6504b', 'SHEI043', 'project', '2026-02-18 06:48:18'),
(433, 'Client Login', 'Client Login Success (SHEI043)', 'Sheikh Sakib Actor', 'client', NULL, NULL, 'SHEI043', 'system', '2026-02-18 06:53:35'),
(434, 'Update Project', 'Updated payment for একলা থাকাই ভালা (PRJ-2dd6504b). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-2dd6504b', 'SHEI043', 'project', '2026-02-18 07:11:42'),
(435, 'Update Project', 'Updated payment for একলা থাকাই ভালা (PRJ-2dd6504b). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-2dd6504b', 'SHEI043', 'project', '2026-02-18 07:14:39'),
(436, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 07:52:24'),
(437, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 08:35:28'),
(438, 'Create Project', 'Created project সুপার জুটি (PRJ-0ecd50d4)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-0ecd50d4', 'SHEI043', 'project', '2026-02-18 08:35:51'),
(439, 'Update Project', 'Updated payment for সুপার জুটি (PRJ-0ecd50d4). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-0ecd50d4', 'SHEI043', 'project', '2026-02-18 08:36:41'),
(440, 'Create Project', 'Created project জীবন আমার থমকে গেছে রে (PRJ-95e874e8)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-95e874e8', 'SHEI043', 'project', '2026-02-18 08:45:02'),
(441, 'Create Project', 'Created project Purosh Sokhe Nari Mol (PRJ-4ae219fb)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-18 08:48:01'),
(442, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 09:07:23'),
(443, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-4ae219fb). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-18 10:11:25'),
(444, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-4ae219fb). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-18 10:30:25'),
(445, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-18 10:33:23'),
(446, 'Client Login', 'Client Login Success (FAIZ760)', 'Faizul Kabir Rothi', 'client', NULL, NULL, 'FAIZ760', 'system', '2026-02-18 10:33:40'),
(447, 'Login', 'Staff Login Success', 'test123', 'staff', '80962f86-0c28-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 10:36:30'),
(448, 'Create Customer', 'Added new customer gthtyhtyh (GTHT910)', 'test@123', 'staff', '80962f86-0c28-11f1-a292-9c6b0053504c', NULL, 'GTHT910', 'system', '2026-02-18 10:38:26'),
(449, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-18 11:03:59'),
(450, 'Client Login', 'Client Login Success (SHEI043)', 'Sheikh Sakib Actor', 'client', NULL, NULL, 'SHEI043', 'system', '2026-02-18 11:05:05'),
(451, 'Client Login', 'Client Login Success (BHAI034)', 'BHAI BROTHERS', 'client', NULL, NULL, 'BHAI034', 'system', '2026-02-18 11:06:53'),
(452, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-18 11:58:15'),
(453, 'Delete User', 'Deleted user 80962f86-0c28-11f1-a292-9c6b0053504c', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:12:26'),
(454, 'Create User', 'Created user Test (4f9eee09-0cdc-11f1-a292-9c6b0053504c) with role Team', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:12:55'),
(455, 'Login', 'Staff Login Success', 'Test', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:13:18'),
(456, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:18:05'),
(457, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:25:48'),
(458, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:31:21'),
(459, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 15:32:47'),
(460, 'Add Expense', 'Recorded expense: Poket Money  (BDT 150)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-18 15:51:06'),
(461, 'Update Customer', 'Updated fields: status for customer GTHT910', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'GTHT910', 'system', '2026-02-18 15:59:07'),
(462, 'Update Customer', 'Updated fields: status for customer GTHT910', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'GTHT910', 'system', '2026-02-18 15:59:11'),
(463, 'Login', 'Staff Login Success', 'Test', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 16:23:22'),
(464, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-18 16:33:18'),
(465, 'Client Login', 'Client Login Success (SHEI043)', 'Sheikh Sakib Actor', 'client', NULL, NULL, 'SHEI043', 'system', '2026-02-18 16:33:58'),
(466, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:09:21'),
(467, 'Create Project', 'Created project test (PRJ-a380d29e)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a380d29e', 'GTHT910', 'project', '2026-02-18 17:09:53'),
(468, 'Delete Project', 'Deleted project PRJ-a380d29e', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-a380d29e', NULL, 'project', '2026-02-18 17:10:02'),
(469, 'Create Project', 'Created project tgb (PRJ-e794b772)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-e794b772', NULL, 'project', '2026-02-18 17:13:35'),
(470, 'Delete Project', 'Deleted project PRJ-e794b772', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-e794b772', NULL, 'project', '2026-02-18 17:13:40'),
(471, 'Login', 'Staff Login Success', 'Test', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:13:57'),
(472, 'Create Project', 'Created project er (PRJ-e0adc0a7)', 'test@test.com', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', 'PRJ-e0adc0a7', NULL, 'project', '2026-02-18 17:14:11'),
(473, 'Create Customer', 'Added new customer testtt (TEST497)', 'test@test.com', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, 'TEST497', 'system', '2026-02-18 17:14:50'),
(474, 'Login', 'Staff Login Success', 'Test', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:15:07'),
(475, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:15:19'),
(476, 'Delete Project', 'Deleted project PRJ-e0adc0a7', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-e0adc0a7', NULL, 'project', '2026-02-18 17:15:29'),
(477, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:21:17'),
(478, 'Create Project', 'Created project API Test Project 1771435280992 (PRJ-7f6536ae)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-7f6536ae', NULL, 'project', '2026-02-18 17:21:21'),
(479, 'Update Project', 'Updated payment for API Test Project 1771435280992 (PRJ-7f6536ae). Received ৳4000.00 of ৳8000.00; status: Partial', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-7f6536ae', NULL, 'project', '2026-02-18 17:21:21'),
(480, 'Delete Project', 'Deleted project PRJ-7f6536ae', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-7f6536ae', NULL, 'project', '2026-02-18 17:21:22'),
(481, 'Create Customer', 'Added new customer Test Client Suite (TEST639)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST639', 'system', '2026-02-18 17:21:23'),
(482, 'Update Customer', 'Updated fields: phone, address for customer TEST639', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST639', 'system', '2026-02-18 17:21:24'),
(483, 'Delete Customer', 'Deleted customer TEST639', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST639', 'system', '2026-02-18 17:21:25'),
(484, 'Create User', 'Created user Test Suite User (43bef337-0cee-11f1-a292-9c6b0053504c) with role Team', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:21:26'),
(485, 'Delete User', 'Deleted user 43bef337-0cee-11f1-a292-9c6b0053504c', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:21:27'),
(486, 'Add Expense', 'Recorded expense: Test Expense Suite (BDT 500)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'finance', '2026-02-18 17:21:28'),
(487, 'Delete Expense', 'Deleted expense ID 13', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'finance', '2026-02-18 17:21:29'),
(488, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:23:15'),
(489, 'Create Project', 'Created project API Test Project 1771435398873 (PRJ-879bd01e)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-879bd01e', NULL, 'project', '2026-02-18 17:23:19'),
(490, 'Update Project', 'Updated payment for API Test Project 1771435398873 (PRJ-879bd01e). Received ৳4000.00 of ৳8000.00; status: Partial', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-879bd01e', NULL, 'project', '2026-02-18 17:23:19'),
(491, 'Delete Project', 'Deleted project PRJ-879bd01e', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-879bd01e', NULL, 'project', '2026-02-18 17:23:20'),
(492, 'Create Customer', 'Added new customer Test Client Suite (TEST442)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST442', 'system', '2026-02-18 17:23:21'),
(493, 'Update Customer', 'Updated fields: phone, address for customer TEST442', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST442', 'system', '2026-02-18 17:23:22'),
(494, 'Delete Customer', 'Deleted customer TEST442', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST442', 'system', '2026-02-18 17:23:22'),
(495, 'Create User', 'Created user Test Suite User (89ffe460-0cee-11f1-a292-9c6b0053504c) with role Team', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:23:24'),
(496, 'Delete User', 'Deleted user 89ffe460-0cee-11f1-a292-9c6b0053504c', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:23:25'),
(497, 'Add Expense', 'Recorded expense: Test Expense Suite (BDT 500)', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'finance', '2026-02-18 17:23:26'),
(498, 'Delete Expense', 'Deleted expense ID 14', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'finance', '2026-02-18 17:23:27'),
(499, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 17:23:35'),
(500, 'Login', 'Staff Login Success', 'Test', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 18:07:55'),
(501, 'Create Project', 'Created project thdf (PRJ-89041398)', 'test@test.com', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', 'PRJ-89041398', NULL, 'project', '2026-02-18 18:08:17'),
(502, 'Create Customer', 'Added new customer  vc (VC102)', 'test@test.com', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', NULL, 'VC102', 'system', '2026-02-18 18:08:32'),
(503, 'Create Project', 'Created project fgchgn  (PRJ-5caedd92)', 'test@test.com', 'staff', '4f9eee09-0cdc-11f1-a292-9c6b0053504c', 'PRJ-5caedd92', 'VC102', 'project', '2026-02-18 18:09:11'),
(504, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 18:09:40'),
(505, 'Client Login', 'Client Login Success (VC102)', ' vc', 'client', NULL, NULL, 'VC102', 'system', '2026-02-18 18:10:14'),
(506, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-18 18:10:33'),
(507, 'Client Login', 'Client Login Success (VC102)', ' vc', 'client', NULL, NULL, 'VC102', 'system', '2026-02-18 18:11:04'),
(508, 'Create Customer', 'Added new customer Sharif (SHAR758)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'SHAR758', 'system', '2026-02-18 18:56:14'),
(509, 'Upload Client Photo', 'Uploaded profile image for customer SHAR758', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'SHAR758', 'system', '2026-02-18 18:57:13'),
(510, 'Create Project', 'Created project নূর (PRJ-7dbdeeed)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 19:09:36'),
(511, 'Delete Project', 'Deleted project PRJ-89041398', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-89041398', NULL, 'project', '2026-02-18 19:10:33'),
(512, 'Delete Project', 'Deleted project PRJ-5caedd92', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-5caedd92', NULL, 'project', '2026-02-18 19:10:35'),
(513, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 19:22:27'),
(514, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 19:23:11'),
(515, 'Client Login', 'Client Login Success (SHAR758)', 'Sharif', 'client', NULL, NULL, 'SHAR758', 'system', '2026-02-18 21:08:54'),
(516, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 21:09:56'),
(517, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 21:11:30'),
(518, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 21:11:39'),
(519, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 21:12:43'),
(520, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 21:12:54'),
(521, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-18 21:16:00'),
(522, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-18 21:19:29'),
(523, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-18 21:19:47'),
(524, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 21:25:35'),
(525, 'Client Login', 'Client Login Success (SHAR758)', 'Sharif', 'client', NULL, NULL, 'SHAR758', 'system', '2026-02-18 21:28:15'),
(526, 'Update Project', 'Updated payment for কি মায়া POSTER-1 (PRJ-961bcb86). Received ৳0.00 of ৳1500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-961bcb86', 'FAIZ760', 'project', '2026-02-18 21:32:13'),
(527, 'Update Project', 'Updated payment for কি মায়া POSTER-1 (PRJ-961bcb86). Received ৳0.00 of ৳1500.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-961bcb86', 'FAIZ760', 'project', '2026-02-18 21:34:04'),
(528, 'Update Project', 'Updated payment for বড়জন POSTER-3 (PRJ-0ee1acac). Received ৳0.00 of ৳0.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-0ee1acac', 'FAIZ760', 'project', '2026-02-18 21:36:54'),
(529, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 23:10:51'),
(530, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳0.00 of ৳2000.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-18 23:11:23'),
(531, 'Client Login', 'Client Login Success (SHAR758)', 'Sharif', 'client', NULL, NULL, 'SHAR758', 'system', '2026-02-19 05:56:38'),
(532, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 06:10:09'),
(533, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳2000.00 of ৳2000.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-19 06:10:46'),
(534, 'Update Project', 'Updated payment for নূর (PRJ-7dbdeeed). Received ৳2000.00 of ৳2000.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-7dbdeeed', 'SHAR758', 'project', '2026-02-19 07:05:16'),
(535, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:42:41'),
(536, 'Delete User', 'Deleted user 4f9eee09-0cdc-11f1-a292-9c6b0053504c', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:43:09'),
(537, 'Delete User Denied', 'Denied attempt to delete admin user a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:43:15'),
(538, 'Create User', 'Created user test (8188082f-0d77-11f1-a292-9c6b0053504c) with role Team', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:43:50'),
(539, 'Login', 'Staff Login Success', 'test', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:44:03'),
(540, 'Create Customer', 'Added new customer testttt (TEST029)', 'test@test.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, 'TEST029', 'system', '2026-02-19 09:44:28'),
(541, 'Create Project', 'Created project bjbhg (PRJ-778a7407)', 'test@test.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-778a7407', 'TEST029', 'project', '2026-02-19 09:45:09'),
(542, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:45:47'),
(543, 'Update Project', 'Updated payment for bjbhg (PRJ-778a7407). Received ৳110.00 of ৳110.00; status: Paid; method: Cash', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-778a7407', 'TEST029', 'project', '2026-02-19 09:46:07'),
(544, 'Login', 'Staff Login Success', 'test', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:46:24'),
(545, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:46:35'),
(546, 'Delete Project', 'Deleted project PRJ-778a7407', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-778a7407', NULL, 'project', '2026-02-19 09:46:41'),
(547, 'Delete Customer', 'Deleted customer TEST029', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST029', 'system', '2026-02-19 09:46:51'),
(548, 'Delete Customer', 'Deleted customer TEST497', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'TEST497', 'system', '2026-02-19 09:46:59'),
(549, 'Delete Customer', 'Deleted customer GTHT910', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'GTHT910', 'system', '2026-02-19 09:47:05'),
(550, 'Delete Customer', 'Deleted customer VC102', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, 'VC102', 'system', '2026-02-19 09:47:11'),
(551, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 09:48:26'),
(552, 'Add Expense', 'Recorded expense: Ramadan (BDT 1500)', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'finance', '2026-02-19 12:40:25'),
(553, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳12800.00 of ৳12800.00; status: Paid; method: Cash', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-19 16:11:17'),
(554, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳0.00 of ৳12800.00; status: Unpaid; method: None', 'lulluvai.fb@gmail.com', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-19 16:11:21'),
(555, 'Login', 'Staff Login Success', 'test', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 16:38:58'),
(556, 'Login', 'Staff Login Success', 'test', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 16:40:13'),
(557, 'Update', 'Email changed', 'test', 'system', NULL, NULL, NULL, 'user', '2026-02-19 16:41:27'),
(558, 'Update User', 'Updated fields: name for user 8188082f-0d77-11f1-a292-9c6b0053504c', 'test@test.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 16:41:27'),
(559, 'Login', 'Staff Login Success', 'Lullu Vaiiiiiii', 'staff', '369cace6-0978-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 16:41:50'),
(560, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-19 19:42:41'),
(561, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-19 19:43:01'),
(562, 'Client Login', 'Client Login Success (FAIZ760)', 'Faizul Kabir Rothi', 'client', NULL, NULL, 'FAIZ760', 'system', '2026-02-19 19:46:26'),
(563, 'Client Login', 'Client Login Success (FAIZ760)', 'Faizul Kabir Rothi', 'client', NULL, NULL, 'FAIZ760', 'system', '2026-02-19 19:47:22'),
(564, 'Create User', 'Created user admin (0a95f46e-0dcc-11f1-a292-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:48:58'),
(565, 'Delete User', 'Deleted user 369cace6-0978-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:49:09'),
(566, 'Delete User', 'Deleted user 0a95f46e-0dcc-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:49:28'),
(567, 'Create User', 'Created user Admin (2856fded-0dcc-11f1-a292-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:49:48'),
(568, 'Login', 'Staff Login Success', 'Admin', 'staff', '2856fded-0dcc-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 19:50:06'),
(569, 'Create Customer', 'Added new customer naxax (NAXA844)', 'admin@123', 'staff', '2856fded-0dcc-11f1-a292-9c6b0053504c', NULL, 'NAXA844', 'system', '2026-02-19 19:50:21'),
(570, 'Upload Client Photo', 'Uploaded profile image for customer NAXA844', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'NAXA844', 'system', '2026-02-19 19:51:28'),
(571, 'Create Project', 'Created project accs (PRJ-6d57ea91)', 'admin@123', 'staff', '2856fded-0dcc-11f1-a292-9c6b0053504c', 'PRJ-6d57ea91', 'NAXA844', 'project', '2026-02-19 19:53:22'),
(572, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:55:47'),
(573, 'Delete Project', 'Deleted project PRJ-6d57ea91', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-6d57ea91', NULL, 'project', '2026-02-19 19:56:36'),
(574, 'Delete User', 'Deleted user 2856fded-0dcc-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:56:49'),
(575, 'Create User', 'Created user Mahin (3493dcda-0dcd-11f1-a292-9c6b0053504c) with role Admin', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:57:18'),
(576, 'Delete Customer', 'Deleted customer NAXA844', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, 'NAXA844', 'system', '2026-02-19 19:58:04'),
(577, 'Login', 'Staff Login Success', 'Mahin', 'staff', '3493dcda-0dcd-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-19 19:58:25'),
(578, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:59:44'),
(579, 'Delete User', 'Deleted user 3493dcda-0dcd-11f1-a292-9c6b0053504c', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-19 19:59:57'),
(580, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 03:58:51'),
(581, 'Update Project', 'Updated payment for বড়জন POSTER-1 (PRJ-b4539fe1). Received ৳0.00 of ৳0.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-b4539fe1', 'FAIZ760', 'project', '2026-02-20 04:17:37'),
(582, 'Update Project', 'Updated payment for বড়জন POSTER-3 (PRJ-0ee1acac). Received ৳0.00 of ৳0.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-0ee1acac', 'FAIZ760', 'project', '2026-02-20 04:17:46'),
(583, 'Update Project', 'Updated payment for PORANER PAKHI (PRJ-9f9e348f). Received ৳0.00 of ৳0.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-9f9e348f', 'RAKI672', 'project', '2026-02-20 04:19:02'),
(584, 'Update Project', 'Updated payment for Tagar Romantic (PRJ-0c2012df). Received ৳0.00 of ৳0.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-0c2012df', 'STRE716', 'project', '2026-02-20 04:19:07'),
(585, 'Update Project', 'Updated payment for Tagar Actione (PRJ-03b646be). Received ৳0.00 of ৳0.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-03b646be', 'STRE716', 'project', '2026-02-20 04:19:13'),
(586, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 04:52:02'),
(587, 'Client Login', 'Client Login Success (SHAR758)', 'Sharif', 'client', NULL, NULL, 'SHAR758', 'system', '2026-02-20 04:56:40'),
(588, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 04:58:09'),
(589, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 08:50:18'),
(590, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-20 08:52:34'),
(591, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-20 08:56:42'),
(592, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-20 08:57:49'),
(593, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 08:58:46'),
(594, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-20 08:58:52'),
(595, 'Client Login', 'Client Login Success (DIPT409)', 'Dipta Das', 'client', NULL, NULL, 'DIPT409', 'system', '2026-02-20 08:59:42'),
(596, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 09:00:29'),
(597, 'Create User', 'Created user mahin (d0b4e037-0e3a-11f1-8a59-9c6b0053504c) with role Team', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-20 09:01:59'),
(598, 'Client Login', 'Client Login Success (DOEL464)', 'Doelbd Apurbo', 'client', NULL, NULL, 'DOEL464', 'system', '2026-02-20 09:05:33'),
(599, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 09:06:02'),
(600, 'Client Login', 'Client Login Success (SHAR758)', 'Sharif', 'client', NULL, NULL, 'SHAR758', 'system', '2026-02-20 09:08:42'),
(601, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 09:41:01'),
(602, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-4ae219fb). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-20 09:41:18'),
(603, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-4ae219fb). Received ৳0.00 of ৳500.00; status: Unpaid; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-20 09:42:10'),
(604, 'Update Project', 'Updated payment for জীবন আমার থমকে গেছে রে (PRJ-95e874e8). Received ৳0.00 of ৳1000.00; status: Unpaid; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-95e874e8', 'SHEI043', 'project', '2026-02-20 09:42:35');
INSERT INTO `audit_logs` (`id`, `action`, `details`, `user_name`, `actor_type`, `actor_id`, `project_id`, `customer_id`, `category`, `timestamp`) VALUES
(605, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 10:25:48'),
(606, 'Create Project', 'Created project test (PRJ-68d4c80c)', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-68d4c80c', NULL, 'project', '2026-02-20 11:14:36'),
(607, 'Update Project', 'Updated payment for test (PRJ-68d4c80c). Received ৳200.00 of ৳1000.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-68d4c80c', NULL, 'project', '2026-02-20 11:27:49'),
(608, 'Update Project', 'Updated payment for test (PRJ-68d4c80c). Received ৳200.00 of ৳1000.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-68d4c80c', NULL, 'project', '2026-02-20 11:28:23'),
(609, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 11:31:44'),
(610, 'Client Login', 'Client Login Success (BHAI034)', 'BHAI BROTHERS', 'client', NULL, NULL, 'BHAI034', 'system', '2026-02-20 12:52:57'),
(611, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 12:53:21'),
(612, 'Client Login', 'Client Login Success (MAHA432)', 'Mahamudul Hasan Shovon', 'client', NULL, NULL, 'MAHA432', 'system', '2026-02-20 12:54:52'),
(613, 'Login', 'Staff Login Success', 'Mh Creation X', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', NULL, NULL, 'user', '2026-02-20 12:54:59'),
(614, 'Login', 'Staff Login Success', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', NULL, NULL, 'user', '2026-02-20 13:23:31'),
(615, 'Delete Project', 'Deleted project PRJ-68d4c80c', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-68d4c80c', NULL, 'project', '2026-02-20 13:24:49'),
(616, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 13:25:56'),
(617, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 13:26:40'),
(618, 'Create Project', 'Created project test (PRJ-ec1c215b)', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-ec1c215b', NULL, 'project', '2026-02-20 13:48:09'),
(619, 'Delete Project', 'Deleted project PRJ-ec1c215b', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-ec1c215b', NULL, 'project', '2026-02-20 13:48:29'),
(620, 'Create Project', 'Created project test (PRJ-2f5bbcd2)', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-2f5bbcd2', NULL, 'project', '2026-02-20 13:49:27'),
(621, 'Delete Project', 'Deleted project PRJ-2f5bbcd2', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-2f5bbcd2', NULL, 'project', '2026-02-20 13:50:18'),
(622, 'Create Project', 'Created project test (PRJ-e415adf8)', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e415adf8', NULL, 'project', '2026-02-20 13:51:45'),
(623, 'Update Project', 'Updated payment for test (PRJ-e415adf8). Received ৳500.00 of ৳1000.00; status: Partial', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e415adf8', NULL, 'project', '2026-02-20 13:52:00'),
(624, 'Update Project', 'Updated payment for test (PRJ-e415adf8). Received ৳600.00 of ৳1000.00; status: Partial', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e415adf8', NULL, 'project', '2026-02-20 13:52:31'),
(625, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-4ae219fb). Received ৳100.00 of ৳500.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-20 13:52:51'),
(626, 'Delete Project', 'Deleted project PRJ-e415adf8', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e415adf8', NULL, 'project', '2026-02-20 13:52:59'),
(627, 'Update Project', 'Updated payment for Purosh Sokhe Nari Mol (PRJ-4ae219fb). Received ৳100.00 of ৳500.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-4ae219fb', 'SHEI043', 'project', '2026-02-20 13:53:10'),
(628, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳12800.00 of ৳12800.00; status: Paid; method: Cash', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 14:32:36'),
(629, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳0.00 of ৳12800.00; status: Unpaid; method: None', 'mhcreationx@gmail.com', 'staff', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 14:32:52'),
(630, 'Update Project', 'Updated payment for TVC Doelbd (PRJ-e9bfed2d). Received ৳3000.00 of ৳12800.00; status: Partial; method: None', 'darkhacker19684@gmail.com', 'staff', '8188082f-0d77-11f1-a292-9c6b0053504c', 'PRJ-e9bfed2d', 'DOEL464', 'project', '2026-02-20 15:41:47');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('Director','Local Client','Producer','Actor') NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `profile_image_url` varchar(500) DEFAULT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `type`, `phone`, `email`, `address`, `profile_image_url`, `status`, `joined_at`, `created_by`) VALUES
('BHAI034', 'BHAI BROTHERS', 'Actor', '+880 1997-016691', NULL, NULL, '/uploads/customers/BHAI034/profile_20260217_185222_d792b18c.jpg', 'Active', '2026-02-05 15:22:06', NULL),
('DEMO325', 'Demo Customer', 'Local Client', '4156146514561', NULL, NULL, NULL, 'Active', '2026-02-10 10:49:23', NULL),
('DIPT409', 'Dipta Das', 'Local Client', '+880 1956-813899', NULL, NULL, '/uploads/customers/DIPT409/profile_20260217_173025_bb14e186.jpg', 'Active', '2026-02-17 17:30:07', NULL),
('DOEL464', 'Doelbd Apurbo', 'Director', '+880 1627-791406', NULL, NULL, '/uploads/customers/DOEL464/profile_20260217_170955_d739f18f.jpg', 'Active', '2026-02-17 16:55:56', NULL),
('FAIZ760', 'Faizul Kabir Rothi', 'Director', '+880 1707-073346', NULL, NULL, '/uploads/customers/FAIZ760/profile_20260217_185030_4c0ae23b.jpg', 'Active', '2026-02-05 15:06:37', NULL),
('GOUR342', 'Gourob GoGo', 'Director', '+880 1984-939390', NULL, NULL, NULL, 'Active', '2026-02-12 09:43:52', NULL),
('MAHA432', 'Mahamudul Hasan Shovon', 'Producer', '+61 451 697 807', NULL, NULL, '/uploads/customers/MAHA432/profile_20260217_185151_e76bdbb0.jpg', 'Active', '2026-02-05 14:57:43', NULL),
('MOHO118', 'Mohon Islam', 'Director', '+880 1981-955530', NULL, NULL, NULL, 'Active', '2026-02-08 15:45:20', NULL),
('PRIN967', 'Prince Khan', 'Director', '+880 1315-171891', NULL, NULL, '/uploads/customers/PRIN967/profile_20260215_165133_9c65628f.jpg', 'Active', '2026-02-14 11:32:27', NULL),
('RAKI672', 'Rakib Ahmmed', 'Director', '+880 1316-328704', NULL, NULL, NULL, 'Active', '2026-02-10 08:20:35', NULL),
('RMRA690', 'RM RAFI SARDAR', 'Director', '+880 1978-585898', NULL, NULL, NULL, 'Active', '2026-02-06 16:57:03', NULL),
('SHAM526', 'Shamim Ahsan', 'Director', '+880 1792-095788', NULL, NULL, NULL, 'Active', '2026-02-12 20:16:27', NULL),
('SHAR758', 'Sharif', 'Director', '+880 1877-809232', NULL, NULL, '/uploads/customers/SHAR758/profile_20260218_185713_4fcea229.png', 'Active', '2026-02-18 18:56:14', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'),
('SHEI043', 'Sheikh Sakib Actor', 'Director', '+880 1603-273098', NULL, NULL, '/uploads/customers/SHEI043/profile_20260217_201145_ffe688de.jpg', 'Active', '2026-02-07 08:17:28', NULL),
('SHIM080', 'Shimul Chowdhury', 'Director', '+880 1837-418040', NULL, NULL, NULL, 'Active', '2026-02-14 07:23:37', NULL),
('SHUV584', 'Shuvro Mehrazz', 'Director', '+880 1622-233323', NULL, NULL, '/uploads/customers/SHUV584/profile_20260217_185251_d35d74ea.jpg', 'Active', '2026-02-05 17:06:48', NULL),
('SKSA114', 'Sk Sameer', 'Producer', '+880 1553-282320', NULL, NULL, NULL, 'Active', '2026-02-13 06:59:19', NULL),
('STRE716', 'Streamo Digital', 'Producer', '+880 1992-398022', NULL, NULL, NULL, 'Active', '2026-02-10 08:27:56', NULL),
('ZAHE124', 'Zaher Alvi', 'Actor', '+880 1682-510152', NULL, NULL, NULL, 'Active', '2026-02-08 15:41:56', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `category` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `reason`, `amount`, `category`, `date`, `created_by`, `created_at`) VALUES
(5, 'Poket Money ', 100.00, 'Operating', '2026-02-07', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-07 11:54:56'),
(6, 'schiushcn', 500.00, 'Operating', '2026-02-13', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-13 16:26:20'),
(8, 'MaHi Phone', 10000.00, 'Production', '2026-02-17', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-17 16:40:53'),
(9, 'Basha  Bazar', 4000.00, 'Operating', '2026-02-17', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-17 16:42:07'),
(10, 'Web', 2000.00, 'Operating', '2026-02-17', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-17 16:42:26'),
(11, 'Adobe', 250.00, 'Operating', '2026-02-17', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-17 16:42:37'),
(12, 'Poket Money ', 150.00, 'Assets', '2026-02-18', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-18 15:51:06'),
(15, 'Ramadan', 1500.00, 'Operating', '2026-02-19', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '2026-02-19 12:40:25');

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `attempt_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `text` text NOT NULL,
  `sender` varchar(100) NOT NULL,
  `timestamp` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(150) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `token` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `email`, `otp`, `token`, `created_at`, `expires_at`) VALUES
(16, 'darkhacker19684@gmaial.com', '192016', NULL, '2026-02-05 11:15:57', '2026-02-05 11:25:57'),
(19, 'mhcreationx@gmail.com', '028710', NULL, '2026-02-05 11:33:14', '2026-02-05 11:43:14'),
(20, 'mhcreationx@gmail.com', '447348', NULL, '2026-02-05 11:42:48', '2026-02-05 11:57:48'),
(21, 'mhcreationx@gmail.com', '567941', NULL, '2026-02-05 11:58:18', '2026-02-05 12:13:18'),
(27, 'mhcreationx@gmail.com', '899019', NULL, '2026-02-05 12:34:49', '2026-02-05 12:44:49'),
(31, 'contact@nhprince.dpdns.org', '764510', NULL, '2026-02-05 12:44:48', '2026-02-05 12:54:48'),
(32, 'contact@nhprince.dpdns.org', '350341', NULL, '2026-02-05 12:46:40', '2026-02-05 12:56:40'),
(34, 'contact@nhprince.dpdns.org', '420843', NULL, '2026-02-05 12:58:37', '2026-02-05 13:08:37'),
(35, 'nurulhudaprince18@gmail.com', '813793', NULL, '2026-02-05 13:02:29', '2026-02-05 13:12:29');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` varchar(20) NOT NULL,
  `serial_number` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `customer_id` varchar(255) DEFAULT NULL,
  `category` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `director` varchar(100) DEFAULT NULL,
  `status` enum('Pending','Running','Live','Delivered','Final') NOT NULL DEFAULT 'Pending',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `advance_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('Unpaid','Partial','Paid') NOT NULL DEFAULT 'Unpaid',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payment_details`)),
  `delivery_date` date DEFAULT NULL,
  `is_visible_on_public` tinyint(1) NOT NULL DEFAULT 1,
  `show_in_landing` tinyint(1) DEFAULT 0 COMMENT 'Show project in landing page animation slider',
  `show_in_animation` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_previous` tinyint(1) NOT NULL DEFAULT 1,
  `secure_token` varchar(64) DEFAULT NULL,
  `designer_name` varchar(100) DEFAULT NULL,
  `assistant_name` varchar(100) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `drive_link` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `serial_number`, `title`, `customer_id`, `category`, `description`, `director`, `status`, `price`, `advance_amount`, `paid_amount`, `discount`, `payment_status`, `payment_method`, `payment_details`, `delivery_date`, `is_visible_on_public`, `show_in_landing`, `show_in_animation`, `show_in_previous`, `secure_token`, `designer_name`, `assistant_name`, `created_by`, `drive_link`, `created_at`, `updated_at`) VALUES
('PRJ-03b646be', 13, 'Tagar Actione', 'STRE716', 'Movie', 'Eid movie', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-17', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', NULL, '', '2026-02-10 10:48:19', '2026-02-20 04:19:13'),
('PRJ-0c2012df', 12, 'Tagar Romantic', 'STRE716', 'Movie', 'Cinama', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-10', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', NULL, '', '2026-02-10 10:44:18', '2026-02-20 04:19:07'),
('PRJ-0ecd50d4', 27, 'সুপার জুটি', 'SHEI043', 'Music Video', '', '', 'Pending', 500.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-18', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '', '2026-02-18 08:35:51', '2026-02-18 08:36:41'),
('PRJ-0ee1acac', 7, 'বড়জন POSTER-3', 'FAIZ760', 'Natok / Drama', 'Poster 3', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-06', 1, 0, 0, 1, NULL, 'Moazzem Hossen', '', NULL, '', '2026-02-06 08:20:45', '2026-02-20 04:17:46'),
('PRJ-208c963c', 4, 'এলাকার মুরুব্বি', 'SHUV584', 'Music Video', 'POSTER/ Thumbnil', '', 'Delivered', 1500.00, 0.00, 1500.00, 0.00, 'Paid', 'bKash', '{\"method\":\"bKash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"+880 1622-233323\"}', '2026-02-06', 1, 0, 0, 0, NULL, '', '', NULL, '', '2026-02-06 06:34:54', '2026-02-17 14:23:08'),
('PRJ-2dd6504b', 25, 'একলা থাকাই ভালা', 'SHEI043', 'Movie', '', '', 'Delivered', 500.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-18', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/drive/folders/1c_vKuozALmkeKwulZB5ZsQIofgCBJ-0q?usp=sharing', '2026-02-17 20:10:00', '2026-02-18 07:11:42'),
('PRJ-30f84505', 20, 'লাঙ্গে এখন উধাও', 'PRIN967', 'Music Video', 'YT/P', '', 'Delivered', 500.00, 0.00, 500.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-14', 1, 0, 0, 0, NULL, '', '', NULL, 'https://drive.google.com/drive/folders/1QhGkcdAt-Of6JMpB5tQB3N7kZDlvKCNn?usp=sharing', '2026-02-14 11:33:08', '2026-02-17 16:39:53'),
('PRJ-4ae219fb', 29, 'Purosh Sokhe Nari Mol', 'SHEI043', 'Music Video', '', '', 'Delivered', 500.00, 0.00, 100.00, 0.00, 'Partial', 'None', NULL, '2026-02-18', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/drive/folders/1hnFuKMDcw3IAjZW8-rLdSHNd3uIw-Ywz?usp=sharing', '2026-02-18 08:48:01', '2026-02-20 13:53:10'),
('PRJ-50485094', 18, 'বাংলা আমার মায়ের ভাষা', 'SHIM080', 'Music Video', 'YT', '', 'Delivered', 500.00, 0.00, 500.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-14', 1, 0, 0, 0, NULL, '', '', NULL, 'https://drive.google.com/drive/folders/1bdPgRy9W2TtVODMcJvlj1ZQTWGOr29Wo?usp=sharing', '2026-02-14 08:41:54', '2026-02-14 09:42:07'),
('PRJ-513a86b6', 5, 'বিষের ছুরি', 'SHUV584', 'Music Video', 'YT', '', 'Delivered', 500.00, 0.00, 500.00, 0.00, 'Paid', 'bKash', '{\"method\":\"bKash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"+880 1622-233323\"}', '2026-02-06', 1, 0, 0, 0, NULL, '', '', NULL, '', '2026-02-06 06:36:57', '2026-02-06 21:50:34'),
('PRJ-5187edf7', 15, 'ভালবাসা ফিরে আসে', 'SHAM526', 'Natok / Drama', 'Poster', '', 'Delivered', 3000.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-12', 1, 0, 1, 0, NULL, 'Moazzem Hossen', 'MH Creationx Teem', NULL, 'https://drive.google.com/drive/folders/19YR2BCqM2n-1uhW7aP8E-qd1rukzYy-5?usp=sharing', '2026-02-12 20:17:56', '2026-02-14 17:49:08'),
('PRJ-5eba46b7', 1, 'Urbo ami Fainal', 'MAHA432', 'Music Video', 'Singer: Kushol & Konal\nLyrics: Shomeshwar Oli\nTune & Music: Sajid Sarker\nCasting:  Pavan Rao & Megha Shah\nDOP: Karthik Gopal\nDirector: Baba Yadav\nProducer: Mahamudul Hasan Shovon', '', 'Delivered', 10000.00, 0.00, 10000.00, 0.00, 'Paid', 'Bank', '{\"method\":\"Bank\",\"bankName\":\"Tap Tap Send\",\"accountNumber\":\"+61 451 697 807\",\"walletNumber\":\"\"}', '2026-02-06', 1, 0, 0, 1, NULL, 'Moazzem Hossen', '', NULL, 'https://drive.google.com/drive/folders/1iubck4XC7V5pFnpLjLd_7xje2u7BGV9S?usp=sharing', '2026-02-05 15:02:57', '2026-02-17 14:23:08'),
('PRJ-7dbdeeed', 32, 'নূর', 'SHAR758', 'Natok / Drama', '', '', 'Delivered', 2000.00, 0.00, 2000.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-18', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/drive/folders/1b24W2Gro2x8BTDA1Jsgzy8-tG1mo0a1e?usp=sharing', '2026-02-18 19:09:36', '2026-02-19 06:10:46'),
('PRJ-8ac7758c', 2, 'বড়জন POSTER-2', 'FAIZ760', 'Natok / Drama', 'Cast: Arosh Khan, Tonni Mahmid Trina, Shahiduzzaman Selim, Monira Mithu & Other\'s\nDirection: Faizul Kabir Rothi ', '', 'Delivered', 4000.00, 0.00, 4000.00, 0.00, 'Paid', 'Bank', '{\"method\":\"Bank\",\"bankName\":\"Astha\",\"accountNumber\":\"+880 1707-073346\",\"walletNumber\":\"\"}', '2026-02-05', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', NULL, 'https://drive.google.com/drive/folders/16T6lYyAE2xA5MyRR2yotJMKMHe_tTlB0?usp=sharing', '2026-02-05 15:08:42', '2026-02-14 09:59:13'),
('PRJ-95e874e8', 28, 'জীবন আমার থমকে গেছে রে', 'SHEI043', 'Music Video', '', '', 'Running', 1000.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-20', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', '', '2026-02-18 08:45:02', '2026-02-20 09:42:35'),
('PRJ-961bcb86', 22, 'কি মায়া POSTER-1', 'FAIZ760', 'Music Video', 'YT/P', '', 'Delivered', 1500.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-18', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/drive/folders/1CxHF1275lakLNgu60HE5Zs6Lc20bv1ui?usp=sharing', '2026-02-16 17:20:35', '2026-02-18 05:48:53'),
('PRJ-9f9e348f', 11, 'PORANER PAKHI', 'RAKI672', 'Music Video', 'Poster/YT', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-18', 1, 0, 0, 1, NULL, 'Moazzem Hossen', '', NULL, '', '2026-02-10 08:30:08', '2026-02-20 04:19:02'),
('PRJ-a893f2df', 16, 'Chupi Chupi', 'SKSA114', 'Music Video', 'P/YT/BS', '', 'Delivered', 2000.00, 0.00, 2000.00, 0.00, 'Paid', 'bKash', '{\"method\":\"bKash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"01553282320\"}', '2026-02-13', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', NULL, 'https://drive.google.com/drive/folders/1dPh8YxqkHyUp6Yh7vY1DTBl4ZWq-Rqb8?usp=sharing', '2026-02-13 07:01:20', '2026-02-13 07:04:04'),
('PRJ-ac7bb13d', 19, 'ভালবাসা ফিরে আসে POSTER', 'DEMO325', 'Natok / Drama', 'YT/P', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-14', 1, 0, 0, 0, NULL, 'Moazzem Hossen', 'Mh Creationx Studio', NULL, '', '2026-02-14 09:32:48', '2026-02-18 05:33:35'),
('PRJ-b4539fe1', 3, 'বড়জন POSTER-1', 'FAIZ760', 'Natok / Drama', 'Cast: Arosh Khan, Tonni Mahmid Trina, Shahiduzzaman Selim, Monira Mithu & Other\'s\nDirection: Faizul Kabir Rothi ', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', NULL, 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', NULL, NULL, '2026-02-05 15:11:32', '2026-02-20 04:17:37'),
('PRJ-b8318eb0', 8, 'শখের মানুষ All', 'RMRA690', 'Natok / Drama', 'More...', '', 'Delivered', 3000.00, 0.00, 3000.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-08', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', NULL, 'https://drive.google.com/drive/folders/1I8osyiAcpc3xbJ7KEK82fTpidhX50_j5?usp=sharing', '2026-02-08 21:49:13', '2026-02-17 14:23:08'),
('PRJ-c3e6ca23', 9, 'THABA POSTER 1', 'ZAHE124', 'Natok / Drama', 'Zaher Alvi', '', 'Delivered', 4000.00, 0.00, 4000.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-09', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', NULL, '', '2026-02-09 10:36:50', '2026-02-09 13:02:04'),
('PRJ-cb2d8789', 17, 'দেশী নির্বাচন', 'BHAI034', 'Funny Video', 'YT', '', 'Delivered', 700.00, 0.00, 700.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-14', 1, 0, 0, 0, NULL, '', '', NULL, 'https://drive.google.com/file/d/1VLS1KE9C0ogfd84aLuZUQ2hai_IG6MBd/view?usp=sharing', '2026-02-13 07:54:00', '2026-02-14 09:57:52'),
('PRJ-cc99bcc5', 23, 'টিকটকারের লিংক ভাইরাল', 'BHAI034', 'Funny Video', '', '', 'Delivered', 700.00, 0.00, 700.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-17', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/file/d/1oFzWZu3cM-jDpnKJyiW1q_lItjgm7JGg/view?usp=sharing', '2026-02-17 16:48:26', '2026-02-17 16:49:43'),
('PRJ-d57896d2', 14, 'আমি এমন একজন মানুষ পাইলাম না', 'GOUR342', 'Music Video', 'Singer..rajjob khan\nLyrics tone..sopon miah\nMusic..sajon khan ', '', 'Delivered', 1000.00, 0.00, 1000.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-12', 1, 0, 0, 0, NULL, '', '', NULL, 'https://drive.google.com/drive/folders/1F_WR_cVcTGqh_P3uwPHFVYzobRrCAeTZ?usp=sharing', '2026-02-12 09:58:23', '2026-02-17 16:43:29'),
('PRJ-de49b199', 6, 'বাবার স্বপ্ন', 'BHAI034', 'Funny Video', 'YT', '', 'Delivered', 700.00, 0.00, 700.00, 0.00, 'Paid', 'Cash', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-06', 1, 0, 0, 0, NULL, '', '', NULL, 'https://drive.google.com/file/d/1oITQHKd_hlP29GrkQHaeab-5q2zmjcez/view?usp=sharing', '2026-02-06 07:40:33', '2026-02-14 07:26:34'),
('PRJ-e9bfed2d', 24, 'TVC Doelbd', 'DOEL464', 'Natok / Drama', '', '', 'Delivered', 12800.00, 3000.00, 3000.00, 0.00, 'Partial', 'None', '{\"method\":\"Cash\",\"bankName\":\"\",\"accountNumber\":\"\",\"walletNumber\":\"\"}', '2026-02-17', 1, 0, 0, 0, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/drive/folders/1zmTbUZS6-gQLpW8wnw51ic4VILIq4K-r?usp=sharing', '2026-02-17 17:05:14', '2026-02-20 15:41:47'),
('PRJ-f7542499', 26, 'কি মায়া POSTER-2', 'FAIZ760', 'Music Video', '', '', 'Delivered', 0.00, 0.00, 0.00, 0.00, 'Unpaid', 'None', NULL, '2026-02-18', 1, 0, 1, 1, NULL, 'Moazzem Hossen', '', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'https://drive.google.com/drive/folders/1CxHF1275lakLNgu60HE5Zs6Lc20bv1ui?usp=sharing', '2026-02-18 05:33:14', '2026-02-18 05:49:30'),
('PRJ-fa97287d', 10, 'Churi Cham Cham', 'RAKI672', 'Music Video', 'Director : Rakib Ahmmed \nDop : Yasin bin Ariyan', '', 'Delivered', 2000.00, 0.00, 0.00, 0.00, 'Unpaid', NULL, NULL, NULL, 1, 0, 1, 1, NULL, 'Noazzem Hossen', '', NULL, NULL, '2026-02-10 08:23:17', '2026-02-10 08:23:17');

-- --------------------------------------------------------

--
-- Table structure for table `project_images`
--

CREATE TABLE `project_images` (
  `id` int(11) NOT NULL,
  `project_id` varchar(20) NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'poster',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `project_images`
--

INSERT INTO `project_images` (`id`, `project_id`, `image_url`, `type`, `created_at`) VALUES
(35, 'PRJ-b4539fe1', '/uploads/projects/1770304262_d92667ee6931d4a5.jpg', 'poster', '2026-02-05 15:11:32'),
(42, 'PRJ-de49b199', '/uploads/projects/1770381090_ecd3140d14ece5e3.jpg', 'poster', '2026-02-06 12:32:38'),
(45, 'PRJ-513a86b6', '/uploads/projects/1770359813_00e3645cb0695919.png', 'poster', '2026-02-06 21:50:07'),
(46, 'PRJ-208c963c', '/uploads/projects/1770366117_9b0dd9aa13580995.jpg', 'poster', '2026-02-06 21:50:22'),
(51, 'PRJ-c3e6ca23', '/uploads/projects/1770633491_73a787e38bc0619c.jpg', 'poster', '2026-02-09 10:38:14'),
(52, 'PRJ-b8318eb0', '/uploads/projects/1770587451_2c5aa99eaa6f8e5a.jpg', 'poster', '2026-02-09 15:27:41'),
(53, 'PRJ-fa97287d', '/uploads/projects/1770711791_ae91fb5089118c1d.jpg', 'poster', '2026-02-10 08:23:17'),
(62, 'PRJ-d57896d2', '/uploads/projects/1770890261_1c50a7b680dda498.jpg', 'poster', '2026-02-12 10:59:30'),
(65, 'PRJ-a893f2df', '/uploads/projects/1770965977_c3c9d5f022ad0dab.jpg', 'poster', '2026-02-13 07:04:04'),
(71, 'PRJ-50485094', '/uploads/projects/1771058505_9329505f465af3ed.jpg', 'poster', '2026-02-14 08:44:54'),
(73, 'PRJ-8ac7758c', '/uploads/projects/1770304169_b04633c39c1c6e08.jpg', 'poster', '2026-02-14 09:57:11'),
(74, 'PRJ-cb2d8789', '/uploads/projects/1770969221_14a7a4ed63179d19.jpg', 'poster', '2026-02-14 09:57:52'),
(76, 'PRJ-30f84505', '/uploads/projects/1771068807_3717534c76280f47.jpg', 'poster', '2026-02-14 11:33:43'),
(77, 'PRJ-5187edf7', '/uploads/projects/1770927491_020f366f77b1d575.jpg', 'poster', '2026-02-14 17:49:08'),
(82, 'PRJ-cc99bcc5', '/uploads/projects/1771346785_e6fc223b3e5da8f8.jpg', 'poster', '2026-02-17 16:49:43'),
(87, 'PRJ-03b646be', '/uploads/projects/1770720494_24acbb7eb56e971d.jpg', 'poster', '2026-02-17 18:06:12'),
(88, 'PRJ-0c2012df', '/uploads/projects/1770720252_40f1f3722fa23831.jpg', 'poster', '2026-02-17 18:06:27'),
(89, 'PRJ-5eba46b7', '/uploads/projects/1770303775_3484d4581fe9d3e3.jpg', 'poster', '2026-02-17 18:48:20'),
(91, 'PRJ-ac7bb13d', '/uploads/projects/1771061604_7e7f79b497d1520d.jpg', 'poster', '2026-02-18 05:33:35'),
(92, 'PRJ-9f9e348f', '/uploads/projects/1770712148_44de438e38ed1524.jpg', 'poster', '2026-02-18 05:34:01'),
(94, 'PRJ-f7542499', '/uploads/projects/1771392787_baa10a8c1a21514a.jpg', 'poster', '2026-02-18 05:49:30'),
(97, 'PRJ-2dd6504b', '/uploads/projects/1771398875_60ee55be9574576b.jpg', 'poster', '2026-02-18 07:14:39'),
(99, 'PRJ-0ecd50d4', '/uploads/projects/1771403736_9a11e4ee4dc6d179.jpg', 'poster', '2026-02-18 08:36:41'),
(117, 'PRJ-961bcb86', '/uploads/projects/1771262435_749156074359c5e1.jpg', 'poster', '2026-02-18 21:34:04'),
(118, 'PRJ-0ee1acac', '/uploads/projects/1770366074_65f9d9248dc147de.jpg', 'poster', '2026-02-18 21:36:54'),
(124, 'PRJ-7dbdeeed', '/uploads/projects/1771449159_a5b3e58bdac9a3c0.jpeg', 'poster', '2026-02-19 07:05:16'),
(125, 'PRJ-7dbdeeed', '/uploads/projects/1771484700_da488cfe60e7b4ce.jpeg', 'youtube', '2026-02-19 07:05:16'),
(126, 'PRJ-7dbdeeed', '/uploads/projects/1771484707_250997ddbdf2c0e4.jpeg', 'facebook', '2026-02-19 07:05:16'),
(127, 'PRJ-7dbdeeed', '/uploads/projects/1771484713_9e1578c38708dd84.jpeg', 'custom', '2026-02-19 07:05:16'),
(134, 'PRJ-95e874e8', '/uploads/projects/1771404280_6dcad503c6752b9c.jpg', 'poster', '2026-02-20 09:42:35'),
(139, 'PRJ-4ae219fb', '/uploads/projects/1771410576_77b934839160fe5a.jpg', 'poster', '2026-02-20 13:53:10'),
(140, 'PRJ-e9bfed2d', '/uploads/projects/1771347898_cba1f9f902448799.jpg', 'poster', '2026-02-20 15:41:47');

-- --------------------------------------------------------

--
-- Table structure for table `trusted_devices`
--

CREATE TABLE `trusted_devices` (
  `id` int(11) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `device_fingerprint` varchar(64) NOT NULL,
  `device_name` varchar(255) NOT NULL,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','Team') NOT NULL DEFAULT 'Team',
  `avatar` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `avatar`, `is_active`, `created_at`, `updated_at`) VALUES
('8188082f-0d77-11f1-a292-9c6b0053504c', 'darkhacker19684@gmail.com', 'darkhacker19684@gmail.com', '$2y$10$S5YKZ2IUwzIkOXnwKsPiZu2GbBQrAGgpASUzsjWo81Kv77tSR9CPy', 'Admin', NULL, 1, '2026-02-19 09:43:50', '2026-02-20 03:58:21'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'Mh Creation X', 'mhcreationx@gmail.com', '$2y$10$iSC/ELFeePwOcuxxEDhxougptXusNMOwBpIGBBfGFQchoOdnWoa2W', 'Admin', NULL, 1, '2026-02-02 09:12:08', '2026-02-05 18:50:41'),
('d0b4e037-0e3a-11f1-8a59-9c6b0053504c', 'mahin', 'mahin@11', '$2y$10$ui4hrTnAzkPbu.rZ5Ky35uSH5J/1QXZc5ktOo9mQW.akSRnA3tLvO', 'Team', NULL, 1, '2026-02-20 09:01:59', '2026-02-20 09:01:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`),
  ADD KEY `idx_audit_project_id` (`project_id`),
  ADD KEY `idx_audit_customer_id` (`customer_id`),
  ADD KEY `idx_audit_actor` (`actor_type`,`actor_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customers_profile_image_url` (`profile_image_url`),
  ADD KEY `idx_customers_created_by` (`created_by`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date` (`date`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ip_address` (`ip_address`,`attempt_time`),
  ADD KEY `email` (`email`,`attempt_time`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `status` (`status`),
  ADD KEY `payment_status` (`payment_status`),
  ADD KEY `idx_show_in_landing` (`show_in_landing`),
  ADD KEY `idx_projects_created_by` (`created_by`);

--
-- Indexes for table `project_images`
--
ALTER TABLE `project_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `trusted_devices`
--
ALTER TABLE `trusted_devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_device_unique` (`user_id`,`device_fingerprint`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=631;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `project_images`
--
ALTER TABLE `project_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `trusted_devices`
--
ALTER TABLE `trusted_devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `project_images`
--
ALTER TABLE `project_images`
  ADD CONSTRAINT `project_images_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `trusted_devices`
--
ALTER TABLE `trusted_devices`
  ADD CONSTRAINT `trusted_devices_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
