-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 16, 2025 at 04:28 AM
-- Server version: 11.4.8-MariaDB
-- PHP Version: 8.3.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ngla4195_safari`
--

-- --------------------------------------------------------

--
-- Table structure for table `trajets`
--

CREATE TABLE `trajets` (
  `id` int(11) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `nom` varchar(100) NOT NULL,
  `distance_totale` decimal(10,2) DEFAULT NULL,
  `duree_estimee` varchar(50) DEFAULT NULL,
  `statut` enum('actif','inactif') DEFAULT 'actif',
  `latitude_deprte` decimal(10,8) DEFAULT NULL,
  `longitude_depart` decimal(11,8) DEFAULT NULL,
  `latitude_arrivee` decimal(10,8) DEFAULT NULL,
  `longitude_arrivee` decimal(11,8) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `trajets`
--

INSERT INTO `trajets` (`id`, `code`, `nom`, `distance_totale`, `duree_estimee`, `statut`, `latitude_deprte`, `longitude_depart`, `latitude_arrivee`, `longitude_arrivee`, `date_creation`) VALUES
(7, NULL, 'KAPELA - CLINIC NGALIEMA', 27.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 14:08:42'),
(8, NULL, 'UPN - CAMPUS (TRAFIC)', 15.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 14:10:58'),
(9, '014', 'MASINA Q3 - PLACE DES EVOLUEE', 30.00, '35', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 14:21:14'),
(11, NULL, 'LEMBA - HOTEL DES POSTES', 3.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 17:02:55'),
(12, 'TRJ2510116931', 'UPN - GARE CENTRALE', 30.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-11 05:15:57'),
(13, NULL, 'NGIRI NGIRI - GARE CENTRAL', 15.00, NULL, 'actif', NULL, NULL, NULL, NULL, '2025-10-11 05:22:07'),
(14, NULL, 'MASINA Q1 - BATETELA', 26.00, NULL, 'actif', NULL, NULL, NULL, NULL, '2025-10-11 05:24:40'),
(15, NULL, 'KISANGANI - KINMAZIERE', 30.00, NULL, 'actif', NULL, NULL, NULL, NULL, '2025-10-15 16:44:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `trajets`
--
ALTER TABLE `trajets`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `trajets`
--
ALTER TABLE `trajets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
