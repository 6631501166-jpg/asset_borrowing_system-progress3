-- XAMPP-Lite
-- version 8.4.6
-- https://xampplite.sf.net/
--
-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 05, 2025 at 11:05 PM
-- Server version: 11.4.5-MariaDB-log
-- PHP Version: 8.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `asset_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `asset`
--

CREATE TABLE `asset` (
  `asset_id` int(11) NOT NULL,
  `asset_code` varchar(50) NOT NULL,
  `asset_name` varchar(200) NOT NULL,
  `category_id` int(11) NOT NULL,
  `status` enum('available','pending','borrowed','maintenance','disabled') DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `asset`
--

INSERT INTO `asset` (`asset_id`, `asset_code`, `asset_name`, `category_id`, `status`, `created_at`) VALUES
(7, 'Mac-1', 'Macbook Pro M1', 1, 'available', '2025-11-05 20:55:43'),
(8, 'Mac-2', 'Macbook Pro', 1, 'available', '2025-11-05 20:55:43'),
(9, 'Mac-4', 'Macbook Air M2', 1, 'pending', '2025-11-05 20:55:43'),
(10, 'iPad-1', 'iPad Pro 12.9', 2, 'pending', '2025-11-05 20:55:43'),
(11, 'iPad-2', 'iPad Air', 2, 'available', '2025-11-05 20:55:43'),
(12, 'iPad-3', 'iPad Mini', 2, 'available', '2025-11-05 20:55:43'),
(13, 'PS-1', 'PlayStation 5', 3, 'available', '2025-11-05 20:55:43'),
(14, 'PS-2', 'PlayStation 5 Digital', 3, 'available', '2025-11-05 20:55:43'),
(15, 'PS-3', 'PlayStation 4 Pro', 3, 'available', '2025-11-05 20:55:43'),
(16, 'VR-1', 'Meta Quest 3', 4, 'available', '2025-11-05 20:55:43'),
(17, 'VR-2', 'PlayStation VR2', 4, 'available', '2025-11-05 20:55:43'),
(18, 'VR-3', 'HTC Vive Pro', 4, 'available', '2025-11-05 20:55:43'),
(19, 'Mac-3', 'Macbook Pro', 1, 'maintenance', '2025-11-05 20:57:03');

-- --------------------------------------------------------

--
-- Table structure for table `borrowing`
--

CREATE TABLE `borrowing` (
  `borrowing_id` int(11) NOT NULL,
  `borrower_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `approver_id` int(11) DEFAULT NULL,
  `status` enum('pending','approved','borrowed','returned','rejected','cancelled') DEFAULT 'pending',
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `returned_at` datetime DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrowing`
--

INSERT INTO `borrowing` (`borrowing_id`, `borrower_id`, `asset_id`, `approver_id`, `status`, `borrow_date`, `return_date`, `returned_at`, `approved_at`, `created_at`) VALUES
(5, 5, 9, NULL, 'pending', '2025-11-06', '2025-11-13', NULL, NULL, '2025-11-05 22:09:45'),
(6, 9, 10, NULL, 'pending', '2025-11-06', '2025-11-13', NULL, NULL, '2025-11-05 22:13:20');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `name`, `image`, `is_active`, `created_at`) VALUES
(1, 'Macbook', 'macbook.png', 1, '2025-11-05 15:38:57'),
(2, 'iPad', 'ipad.png', 1, '2025-11-05 15:38:57'),
(3, 'Playstation', 'playstation.png', 1, '2025-11-05 15:38:57'),
(4, 'VR Headset', 'vr.png', 1, '2025-11-05 15:38:57');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `uid` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `ph_num` varchar(20) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `profile_img` varchar(255) DEFAULT 'default.png',
  `role` enum('student','admin','lecturer') DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`uid`, `email`, `password`, `first_name`, `last_name`, `ph_num`, `username`, `profile_img`, `role`, `created_at`) VALUES
(1, 'admin@example.com', '$argon2id$v=19$m=19456,t=2,p=1$w1Gwh8JM0JNpRUy+gn+O2A$qzv+7U24N9NALH4v7Fy71aS/C+ohQ6T110WfkhqX7h0', 'Admin', 'User', NULL, 'admin', 'default.png', 'admin', '2025-11-05 15:38:57'),
(2, 'john.doe@example.com', '$argon2id$v=19$m=19456,t=2,p=1$vgPooYtzWM6/fq/VgdT+iQ$Wt9Kuj/XoSOU+JTiUf3TcMuKUwaBjpPQi7YFRTJ7IxU', 'John', 'Doe', '+1234567890', 'johndoe', 'default.png', 'student', '2025-11-05 15:39:57'),
(3, 'test1762357273@example.com', '$argon2id$v=19$m=19456,t=2,p=1$UzW5ENvxbZOvej05ICj3Lg$X2pEook9YlU60A3rzKtAFkwsLEBI2lWYKXJj2hYXKDg', 'Test', 'User', NULL, 'testuser1762357273', 'default.png', 'student', '2025-11-05 15:41:13'),
(4, 'iptest@example.com', '$argon2id$v=19$m=19456,t=2,p=1$v1t5K1IfvGHoQVMxcRwn5w$BhJCj1HDkxfo1V8olqQHeglmNDIW4Vi2ae1zGdtnKkg', 'IP', 'Test', NULL, 'iptest', 'default.png', 'student', '2025-11-05 15:47:34'),
(5, 'swan2923@gmail.com', '$argon2id$v=19$m=19456,t=2,p=1$Z4qZRri1oR4mGonhSd/sEw$KEAzpZHpx0hF7RFmLqpa0RFrL3isEh4RAdmt5WvBq2Q', 'SWAN', 'HTET', '835087266', 'LouisCore', 'default.png', 'student', '2025-11-05 16:49:37'),
(8, 'boomz181121@gmail.com', '$argon2id$v=19$m=19456,t=2,p=1$+/mLZiWrnYZVCrELBIaJJA$KoZb67yCRkKe9TGBIEjH2TldhDU5PcSuu4MSOKNNjjw', 'boom', 'z', '639850175', 'boomz', 'default.png', 'student', '2025-11-05 16:57:32'),
(9, 'user@gmail.com', '$argon2id$v=19$m=19456,t=2,p=1$jTmh5C1RexUbyoy19gFJOA$8SA0+tQdAun//N+eArPlo1c55aKpjWzGd48aQHml/o8', 'Test', 'User', NULL, 'user', 'default.png', 'student', '2025-11-05 17:50:04'),
(10, 'minmaung211200@gmail.com', '$argon2id$v=19$m=19456,t=2,p=1$e0knPlRbUdU3n2yjZ4J/Jw$PRne5kteYdfjGe4ODOS/DqG2KuAkJNZJiRmOW05aA8o', 'Min Maung', 'Maung', '0619328188', 'minmaung21', 'default.png', 'student', '2025-11-05 18:23:19'),
(11, 'nickyoung21@gmail.com', '$argon2id$v=19$m=19456,t=2,p=1$fUl1AOkd9naOPqR0OKo/ZQ$1dIIaSwcAeanoGauf470V0d315AZDQAtTb+Pu0E3lKM', 'Nick', 'Young', '0123456789', 'nickyoung01', 'default.png', 'student', '2025-11-05 18:29:21');

-- --------------------------------------------------------

-- New table for lecturer_profile
CREATE TABLE IF NOT EXISTS `lecturer_profile` (
  `lecturer_id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL UNIQUE,
  `department` varchar(100) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`lecturer_id`),
  CONSTRAINT `fk_lecturer_user` FOREIGN KEY (`uid`) REFERENCES `users` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- New table for approval history
CREATE TABLE IF NOT EXISTS `approval_history` (
  `approval_id` int(11) NOT NULL AUTO_INCREMENT,
  `borrowing_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `action` enum('approved','rejected','cancelled') NOT NULL,
  `action_date` datetime NOT NULL DEFAULT current_timestamp(),
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`approval_id`),
  CONSTRAINT `fk_approval_borrowing` FOREIGN KEY (`borrowing_id`) REFERENCES `borrowing` (`borrowing_id`),
  CONSTRAINT `fk_approval_lecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

-- Indexes for dumped tables
--

-- Indexes for table `asset`
ALTER TABLE `asset`
  ADD PRIMARY KEY (`asset_id`),
  ADD UNIQUE KEY `asset_code` (`asset_code`),
  ADD KEY `category_id` (`category_id`);

-- Indexes for table `borrowing`
ALTER TABLE `borrowing`
  ADD PRIMARY KEY (`borrowing_id`),
  ADD KEY `borrower_id` (`borrower_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `approver_id` (`approver_id`);

-- Indexes for table `category`
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

-- Indexes for table `users`
ALTER TABLE `users`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

-- Indexes for table `lecturer_profile`
ALTER TABLE `lecturer_profile`
  ADD UNIQUE KEY `uid` (`uid`);

-- Indexes for table `approval_history`
ALTER TABLE `approval_history`
  ADD KEY `borrowing_id` (`borrowing_id`),
  ADD KEY `lecturer_id` (`lecturer_id`);

-- --------------------------------------------------------

-- AUTO_INCREMENT for dumped tables
--

ALTER TABLE `asset`
  MODIFY `asset_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

ALTER TABLE `borrowing`
  MODIFY `borrowing_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `users`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

ALTER TABLE `lecturer_profile`
  MODIFY `lecturer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `approval_history`
  MODIFY `approval_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

-- --------------------------------------------------------

-- Constraints for dumped tables
--

ALTER TABLE `asset`
  ADD CONSTRAINT `asset_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`);

ALTER TABLE `borrowing`
  ADD CONSTRAINT `borrowing_ibfk_1` FOREIGN KEY (`borrower_id`) REFERENCES `users` (`uid`),
  ADD CONSTRAINT `borrowing_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`asset_id`),
  ADD CONSTRAINT `borrowing_ibfk_3` FOREIGN KEY (`approver_id`) REFERENCES `users` (`uid`);

ALTER TABLE `lecturer_profile`
  ADD CONSTRAINT `fk_lecturer_user` FOREIGN KEY (`uid`) REFERENCES `users` (`uid`);

ALTER TABLE `approval_history`
  ADD CONSTRAINT `fk_approval_borrowing` FOREIGN KEY (`borrowing_id`) REFERENCES `borrowing` (`borrowing_id`),
  ADD CONSTRAINT `fk_approval_lecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`uid`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
