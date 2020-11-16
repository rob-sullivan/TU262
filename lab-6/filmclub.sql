-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2020 at 10:18 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `filmclub`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `MemberId` int(11) NOT NULL,
  `ShowTime` int(11) NOT NULL,
  `ExtraCharge` char(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `film`
--

CREATE TABLE `film` (
  `FilmId` int(11) NOT NULL,
  `Title` char(18) DEFAULT NULL,
  `Kind` char(18) DEFAULT NULL,
  `FilmDate` char(18) DEFAULT NULL,
  `Director` char(18) DEFAULT NULL,
  `Distributor` char(18) DEFAULT NULL,
  `RentalPrice` char(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `MemberId` int(11) NOT NULL,
  `TotalRes` char(18) DEFAULT NULL,
  `Address` char(18) DEFAULT NULL,
  `Street` char(18) DEFAULT NULL,
  `City` char(18) DEFAULT NULL,
  `CountryState` char(18) DEFAULT NULL,
  `Children` char(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `performance`
--

CREATE TABLE `performance` (
  `ShowTime` int(11) NOT NULL,
  `NumShowed` int(11) DEFAULT NULL,
  `Status` char(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `performer`
--

CREATE TABLE `performer` (
  `PerformerId` char(18) NOT NULL,
  `Name` char(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `reserves`
--

CREATE TABLE `reserves` (
  `FilmId` int(11) NOT NULL,
  `MemberId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `shows`
--

CREATE TABLE `shows` (
  `ShowTime` int(11) NOT NULL,
  `FilmId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `starsin`
--

CREATE TABLE `starsin` (
  `FilmId` int(11) NOT NULL,
  `PerformerId` char(18) NOT NULL,
  `FilmRole` char(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`MemberId`,`ShowTime`),
  ADD KEY `R_2` (`ShowTime`);

--
-- Indexes for table `film`
--
ALTER TABLE `film`
  ADD PRIMARY KEY (`FilmId`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`MemberId`);

--
-- Indexes for table `performance`
--
ALTER TABLE `performance`
  ADD PRIMARY KEY (`ShowTime`);

--
-- Indexes for table `performer`
--
ALTER TABLE `performer`
  ADD PRIMARY KEY (`PerformerId`);

--
-- Indexes for table `reserves`
--
ALTER TABLE `reserves`
  ADD PRIMARY KEY (`FilmId`,`MemberId`),
  ADD KEY `R_31` (`MemberId`);

--
-- Indexes for table `shows`
--
ALTER TABLE `shows`
  ADD PRIMARY KEY (`ShowTime`,`FilmId`),
  ADD KEY `R_4` (`FilmId`);

--
-- Indexes for table `starsin`
--
ALTER TABLE `starsin`
  ADD PRIMARY KEY (`FilmId`,`PerformerId`),
  ADD KEY `R_28` (`PerformerId`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `R_1` FOREIGN KEY (`MemberId`) REFERENCES `member` (`MemberId`),
  ADD CONSTRAINT `R_2` FOREIGN KEY (`ShowTime`) REFERENCES `performance` (`ShowTime`);

--
-- Constraints for table `reserves`
--
ALTER TABLE `reserves`
  ADD CONSTRAINT `R_30` FOREIGN KEY (`FilmId`) REFERENCES `film` (`FilmId`),
  ADD CONSTRAINT `R_31` FOREIGN KEY (`MemberId`) REFERENCES `member` (`MemberId`);

--
-- Constraints for table `shows`
--
ALTER TABLE `shows`
  ADD CONSTRAINT `R_3` FOREIGN KEY (`ShowTime`) REFERENCES `performance` (`ShowTime`),
  ADD CONSTRAINT `R_4` FOREIGN KEY (`FilmId`) REFERENCES `film` (`FilmId`);

--
-- Constraints for table `starsin`
--
ALTER TABLE `starsin`
  ADD CONSTRAINT `R_28` FOREIGN KEY (`PerformerId`) REFERENCES `performer` (`PerformerId`),
  ADD CONSTRAINT `R_29` FOREIGN KEY (`FilmId`) REFERENCES `film` (`FilmId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
