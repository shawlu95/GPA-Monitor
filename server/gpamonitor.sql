-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Nov 10, 2018 at 06:37 PM
-- Server version: 5.6.38
-- PHP Version: 7.2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gpamonitor`
--
CREATE DATABASE IF NOT EXISTS `gpamonitor` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `gpamonitor`;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `grade` enum('A','A-','B+','B','B-','C+','C','C-','D+','D','D-','P','F') NOT NULL,
  `credit` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `term` enum('Fall','J-term','Spring','Summer') NOT NULL,
  `year` enum('Freshman','Sophomore','Junior','Senior') NOT NULL,
  `major` tinyint(1) NOT NULL DEFAULT '0',
  `majorStr` varchar(50) NOT NULL DEFAULT 'None',
  `userID` varchar(50) NOT NULL,
  `created` datetime NOT NULL,
  `lastModified` datetime NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `grade`, `credit`, `name`, `term`, `year`, `major`, `majorStr`, `userID`, `created`, `lastModified`, `deleted`) VALUES
(314, 'A', 4, 'Calculus with Application', 'Fall', 'Freshman', 0, 'None', 'developer', '2016-08-31 12:37:25', '2016-10-08 06:41:15', 0),
(427, 'B', 4, 'Ordinary Differential Equation', 'Fall', 'Sophomore', 0, 'None', 'developer', '2016-09-03 18:28:25', '2016-10-08 06:41:26', 0),
(430, 'A', 4, 'Discrete Math', 'Fall', 'Freshman', 0, 'None', 'developer', '2016-09-03 18:32:12', '2016-10-08 06:41:40', 0),
(431, 'B+', 4, 'Linear Algebra', 'Spring', 'Freshman', 0, 'None', 'developer', '2016-09-03 18:32:28', '2016-10-08 06:41:10', 0);

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL,
  `cmd` varchar(20) NOT NULL,
  `err` int(4) NOT NULL,
  `time_stamp` datetime NOT NULL,
  `userID` varchar(50) NOT NULL,
  `log` text NOT NULL,
  `installationID` varchar(100) NOT NULL,
  `sessionID` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`id`, `cmd`, `err`, `time_stamp`, `userID`, `log`, `installationID`, `sessionID`) VALUES
(966, 'signup', 0, '2016-08-31 12:42:14', 'developer', 'Signup success.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '285'),
(967, 'enter', 0, '2016-08-31 12:42:29', 'developer', 'Became active.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '286'),
(968, 'sync', 0, '2016-08-31 12:42:29', 'developer', 'Became active.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '285'),
(969, 'enter', 0, '2016-08-31 12:43:21', 'developer', 'Became active.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '287'),
(970, 'sync', 0, '2016-08-31 12:43:21', 'developer', 'Became active.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '287'),
(971, 'update', 0, '2016-08-31 12:43:27', 'developer', 'Updated course.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '287'),
(972, 'update', 0, '2016-08-31 12:43:33', 'developer', 'Updated course.', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '287'),
(973, 'enter', 0, '2016-08-31 12:45:28', 'developer', 'Became active.', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '288'),
(974, 'sync', 0, '2016-08-31 12:45:28', 'developer', 'Became active.', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '288'),
(975, 'logout', 0, '2016-08-31 12:45:33', 'developer', 'User logout.', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '288'),
(986, 'login', 0, '2016-08-31 12:48:21', 'developer', 'Login success. ', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '290'),
(2486, 'enter', 0, '2016-08-31 23:56:10', 'developer', 'Became active.', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '1032'),
(2487, 'sync', 0, '2016-08-31 23:56:10', 'developer', 'Became active.', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '290'),
(2488, 'logout', 0, '2016-08-31 23:56:15', 'developer', 'User logout.', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '1032'),
(3367, 'login', 0, '2016-09-03 18:27:03', 'developer', 'Login success. ', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3368, 'update', 0, '2016-09-03 18:27:27', 'DEVELOPER', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3369, 'update', 0, '2016-09-03 18:27:48', 'DEVELOPER', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3370, 'create', 0, '2016-09-03 18:28:25', 'DEVELOPER', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3371, 'create', 0, '2016-09-03 18:29:13', 'DEVELOPER', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3372, 'logout', 0, '2016-09-03 18:29:39', 'DEVELOPER', 'User logout.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3373, 'login', 0, '2016-09-03 18:29:47', 'developer', 'Login success. ', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3374, 'update', 0, '2016-09-03 18:30:00', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3375, 'update', 0, '2016-09-03 18:30:10', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3376, 'update', 0, '2016-09-03 18:30:23', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3377, 'logout', 0, '2016-09-03 18:30:27', 'developer', 'User logout.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3378, 'login', 0, '2016-09-03 18:30:32', 'developer', 'Login success. ', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3379, 'create', 0, '2016-09-03 18:31:11', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3380, 'update', 0, '2016-09-03 18:31:18', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3381, 'update', 0, '2016-09-03 18:31:35', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3382, 'create', 0, '2016-09-03 18:32:12', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3383, 'create', 0, '2016-09-03 18:32:28', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3384, 'update', 0, '2016-09-03 18:32:37', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3385, 'create', 0, '2016-09-03 18:33:07', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3386, 'update', 0, '2016-09-03 18:33:12', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3387, 'create', 0, '2016-09-03 18:34:17', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3388, 'create', 0, '2016-09-03 18:34:30', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3389, 'create', 0, '2016-09-03 18:34:47', 'developer', 'Inserted course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3390, 'update', 0, '2016-09-03 18:35:02', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(3391, 'update', 0, '2016-09-03 18:35:17', 'developer', 'Updated course.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(4536, 'enter', 0, '2016-10-07 08:37:12', 'developer', 'Became active.', '0625FF57-9AFB-4618-9E21-D5904895D796', '1658'),
(4537, 'sync', 0, '2016-10-07 08:37:13', 'developer', 'Became active.', '0625FF57-9AFB-4618-9E21-D5904895D796', '815'),
(4538, 'enter', 0, '2016-10-07 08:45:11', 'developer', 'Became active.', '0625FF57-9AFB-4618-9E21-D5904895D796', '1659'),
(4539, 'sync', 0, '2016-10-07 08:45:11', 'developer', 'Became active.', '0625FF57-9AFB-4618-9E21-D5904895D796', '1658'),
(4560, 'login', 0, '2016-10-08 05:23:33', 'developer', 'Login success. ', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666'),
(4561, 'logout', 0, '2016-10-08 05:23:40', 'developer', 'User logout.', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666'),
(4562, 'login', 0, '2016-10-08 05:23:49', 'developer', 'Login success. ', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666'),
(4563, 'update', 0, '2016-10-08 06:41:10', 'developer', 'Updated course.', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666'),
(4564, 'update', 0, '2016-10-08 06:41:15', 'developer', 'Updated course.', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666'),
(4565, 'update', 0, '2016-10-08 06:41:26', 'developer', 'Updated course.', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666'),
(4566, 'update', 0, '2016-10-08 06:41:40', 'developer', 'Updated course.', 'BCAB1974-2F43-4A2C-A796-D0764394F1B3', '1666');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `installationID` varchar(100) NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `userID`, `installationID`, `start`, `end`) VALUES
(285, 'developer', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '2016-08-31 12:40:46', '0000-00-00 00:00:00'),
(286, 'developer', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '2016-08-31 12:42:29', '0000-00-00 00:00:00'),
(287, 'developer', '67B2DA4A-175D-4B71-84C3-E1E8A081230E', '2016-08-31 12:43:21', '0000-00-00 00:00:00'),
(288, 'developer', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '2016-08-31 12:45:28', '0000-00-00 00:00:00'),
(290, 'developer', '48A58820-55D6-4EFC-97FF-9B4E93816C0B', '2016-08-31 12:47:54', '0000-00-00 00:00:00'),
(815, 'developer', '0625FF57-9AFB-4618-9E21-D5904895D796', '2016-08-31 22:03:10', '0000-00-00 00:00:00'),
(1658, 'developer', '0625FF57-9AFB-4618-9E21-D5904895D796', '2016-10-07 08:37:12', '0000-00-00 00:00:00'),
(1659, 'developer', '0625FF57-9AFB-4618-9E21-D5904895D796', '2016-10-07 08:45:11', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `hashed_password` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `userID`, `hashed_password`) VALUES
(37, 'developer', '$2y$10$Yjk3ZTc3OWVlODRjZWY5Mup.nQUY6NpZrCNjJ07Yr0f5MeOha8zOa');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1534;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9583;

--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2756;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
