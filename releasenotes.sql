-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: sql32.jnb2.host-h.net
-- Generation Time: Apr 27, 2018 at 10:16 AM
-- Server version: 10.0.34-MariaDB-1~wheezy
-- PHP Version: 5.6.33-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `releasenotes`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `type` varchar(80) NOT NULL,
  `ordering` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `type`, `ordering`) VALUES
(1, 'Front Office', 1),
(2, 'Modelling', 2),
(3, 'Release Notes', 3);

-- --------------------------------------------------------

--
-- Table structure for table `logBinaries`
--

CREATE TABLE `logBinaries` (
  `id` int(11) NOT NULL,
  `log` int(11) NOT NULL,
  `desc` varchar(400) NOT NULL,
  `content` blob NOT NULL,
  `fileName` varchar(400) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `release` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `desc` varchar(2000) NOT NULL,
  `solution` varchar(2000) NOT NULL,
  `code` varchar(100) NOT NULL,
  `isopen` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `release`, `type`, `category`, `title`, `desc`, `solution`, `code`, `isopen`) VALUES
(1, 1, 1, 1, '46068', 'Asset Transfer out of Mutual funds', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Always uses the net opening Market Value</li><li>Exclude Management Fees = True</li><li>Gross closing Market Value is used if FeeBasis = Accrued</li></ul>', '', 0),
(2, 1, 1, 1, '46069', 'This is a sample log', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Sample log 1</li><li>Sample log 2</li><li>Sample log 3</li></ul>', '', 0),
(3, 1, 1, 1, '46070', 'Another Sample title comes here', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Sample log 1</li><li>Sample log 2</li><li>Sample log 3</li></ul>', '', 0),
(4, 1, 2, 2, '46071', 'Deadlocks error message is incorrect', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Sample log 1</li><li>Sample log 2</li><li>Sample log 3</li></ul>', '', 0),
(5, 2, 1, 3, '46073', 'Other random errors that occurred', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Sample log 1</li><li>Sample log 2</li><li>Sample log 3</li></ul>', '', 0),
(6, 2, 2, 3, '46074', 'More sample data here', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Sample log 1</li><li>Sample log 2</li><li>Sample log 3</li></ul>', '', 0),
(7, 2, 3, 2, '46075', 'Extra Sample data', 'The sub-period TWRR formula has been updated with the following changes<br><ul><li>Sample log 1</li><li>Sample log 2</li><li>Sample log 3</li></ul>', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `releases`
--

CREATE TABLE `releases` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `ordering` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `releases`
--

INSERT INTO `releases` (`id`, `name`, `ordering`) VALUES
(1, '0.9', 1),
(2, '1.0', 2),
(3, '1.5', 3),
(4, '1.6', 4),
(8, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `types`
--

CREATE TABLE `types` (
  `id` int(11) NOT NULL,
  `type` varchar(80) NOT NULL,
  `ordering` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `types`
--

INSERT INTO `types` (`id`, `type`, `ordering`) VALUES
(1, 'Features', 1),
(2, 'Enhancements', 2),
(3, 'Resolved Issues', 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categoryOrder` (`ordering`);

--
-- Indexes for table `logBinaries`
--
ALTER TABLE `logBinaries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logID` (`log`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `releaseID` (`release`),
  ADD KEY `typeID` (`type`),
  ADD KEY `categoryID` (`category`);

--
-- Indexes for table `releases`
--
ALTER TABLE `releases`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `releases`
--
ALTER TABLE `releases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `types`
--
ALTER TABLE `types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `logBinaries`
--
ALTER TABLE `logBinaries`
  ADD CONSTRAINT `logbinaries_ibfk_1` FOREIGN KEY (`log`) REFERENCES `logs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`type`) REFERENCES `types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `logs_ibfk_2` FOREIGN KEY (`release`) REFERENCES `releases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `logs_ibfk_3` FOREIGN KEY (`category`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
