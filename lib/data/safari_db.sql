-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 16, 2025 at 03:22 AM
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
-- Table structure for table `affectations_equipe`
--

CREATE TABLE `affectations_equipe` (
  `id` int(11) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `membre_id` int(11) NOT NULL,
  `role` enum('chauffeur','controleur','receveur','autre') NOT NULL,
  `statut` enum('actif','remplace','absent') DEFAULT 'actif',
  `date_affectation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `affectations_equipe`
--

INSERT INTO `affectations_equipe` (`id`, `shift_id`, `membre_id`, `role`, `statut`, `date_affectation`) VALUES
(1, 1, 10, 'chauffeur', 'actif', '2025-10-08 21:43:29'),
(2, 1, 12, 'controleur', 'actif', '2025-10-08 21:43:29'),
(3, 1, 15, 'receveur', 'actif', '2025-10-08 21:43:29');

-- --------------------------------------------------------

--
-- Table structure for table `alertes`
--

CREATE TABLE `alertes` (
  `id` int(11) NOT NULL,
  `type_alerte` enum('critical','warning','info','success') NOT NULL,
  `titre` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `bus_id` int(11) DEFAULT NULL,
  `membre_id` int(11) DEFAULT NULL,
  `statut` enum('nouveau','en_cours','resolu') DEFAULT 'nouveau',
  `priorite` enum('haute','moyenne','basse') DEFAULT 'moyenne',
  `localisation` varchar(200) DEFAULT NULL,
  `date_alerte` datetime DEFAULT current_timestamp(),
  `date_resolution` datetime DEFAULT NULL,
  `resolu_par` int(11) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `alertes`
--

INSERT INTO `alertes` (`id`, `type_alerte`, `titre`, `message`, `bus_id`, `membre_id`, `statut`, `priorite`, `localisation`, `date_alerte`, `date_resolution`, `resolu_par`, `date_creation`) VALUES
(1, 'critical', 'Bus #421 - Panne mécanique', 'Problème moteur détecté. Bus en panne sur la Ligne 2. Dépanneuse en route. Passagers transférés.', 1, NULL, 'en_cours', 'haute', 'Route de Matadi', '2025-10-11 20:41:47', NULL, NULL, '2025-10-11 21:26:47'),
(2, 'critical', 'Bus #208 - Accident signalé', 'Accident mineur signalé. Bus immobilisé au niveau de Lemba. Aucun blessé. Intervention requise.', 3, NULL, 'en_cours', 'haute', 'Lemba, Kinshasa', '2025-10-11 21:11:47', NULL, NULL, '2025-10-11 21:26:47'),
(3, 'critical', 'Bus #315 - Document expiré', 'Assurance expirée depuis 3 jours. Bus suspendu automatiquement. Renouvellement urgent requis.', 2, NULL, 'en_cours', 'haute', NULL, '2025-10-11 19:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(4, 'warning', 'Bus #156 - Contrôle technique à renouveler', 'Le contrôle technique expire dans 7 jours. Planifier le renouvellement avant le 14/10/2025.', 4, NULL, 'nouveau', 'moyenne', NULL, '2025-10-10 21:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(5, 'warning', 'Bus #512 - Niveau de carburant bas', 'Niveau de carburant à 15%. Ravitaillement recommandé avant le prochain trajet.', 6, NULL, 'nouveau', 'moyenne', NULL, '2025-10-11 18:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(6, 'warning', 'Équipe incomplète - Bus #642', 'Pas de receveur affecté pour le shift de demain 06:00-14:00. Affectation urgente requise.', 10, NULL, 'nouveau', 'haute', NULL, '2025-10-11 15:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(7, 'info', 'Bus #238 - Autorisé à reprendre le service', 'Réparations terminées. Contrôle qualité validé. Le bus est autorisé à reprendre le service.', 7, NULL, 'en_cours', 'basse', NULL, '2025-10-11 16:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(8, 'info', 'Nouveau chauffeur affecté - Bus #310', 'Grace Lumbu a été affectée comme chauffeur principal du Bus #310. Formation complétée avec succès.', 8, NULL, 'resolu', 'basse', NULL, '2025-10-10 21:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(9, 'info', 'Maintenance préventive programmée - Bus #156', 'Maintenance préventive programmée pour le 10/10/2025. Durée estimée: 4 heures. Bus de remplacement assigné.', 4, NULL, 'nouveau', 'moyenne', NULL, '2025-10-10 21:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(10, 'success', 'Bus #421 - Réparation terminée', 'La réparation du système de freinage a été complétée avec succès. Le bus est prêt à reprendre le service.', 1, NULL, 'resolu', 'basse', NULL, '2025-10-09 21:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(11, 'success', 'Formation sécurité complétée', 'Tous les chauffeurs ont complété la formation sécurité obligatoire. Certificats délivrés.', NULL, NULL, 'resolu', 'basse', NULL, '2025-10-08 21:26:47', NULL, NULL, '2025-10-11 21:26:47'),
(12, 'warning', 'Bus #175 - Pneus à remplacer', 'L\'usure des pneus avant dépasse 80%. Remplacement recommandé dans les 48 heures.', 9, NULL, 'nouveau', 'moyenne', NULL, '2025-10-11 13:26:47', NULL, NULL, '2025-10-11 21:26:47');

-- --------------------------------------------------------

--
-- Table structure for table `alertes_historique`
--

CREATE TABLE `alertes_historique` (
  `id` int(11) NOT NULL,
  `alerte_id` int(11) NOT NULL,
  `action` enum('traiter','resoudre','ignorer') NOT NULL,
  `type_traitement` varchar(100) DEFAULT NULL,
  `solution` varchar(100) DEFAULT NULL,
  `raison` varchar(100) DEFAULT NULL,
  `commentaire` text DEFAULT NULL,
  `traite_par` int(11) DEFAULT NULL,
  `date_action` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alertes_historique`
--

INSERT INTO `alertes_historique` (`id`, `alerte_id`, `action`, `type_traitement`, `solution`, `raison`, `commentaire`, `traite_par`, `date_action`) VALUES
(1, 1, 'traiter', 'intervention_technique', NULL, NULL, 'un pneu crever remplacer', NULL, '2025-10-11 22:27:30');

-- --------------------------------------------------------

--
-- Table structure for table `arrets`
--

CREATE TABLE `arrets` (
  `id` int(11) NOT NULL,
  `trajet_id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `distance_avec_debut` int(11) NOT NULL,
  `temps_arret` int(11) DEFAULT 0,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `arrets`
--

INSERT INTO `arrets` (`id`, `trajet_id`, `nom`, `distance_avec_debut`, `temps_arret`, `date_creation`) VALUES
(1, 1, 'arret Don bosco', 3, 10, '2025-10-10 13:09:40'),
(2, 13, 'Ngiri Ngiri', 1, 3, '2025-10-11 05:22:07'),
(3, 14, 'BIA', 3, 10, '2025-10-11 05:24:40'),
(4, 14, '17eme Rue', 9, 14, '2025-10-11 05:24:40'),
(5, 14, '15eme Rue', 13, 17, '2025-10-11 05:24:40'),
(6, 12, 'Bobozo', 2, 3, '2025-10-11 05:25:30'),
(7, 15, 'Kingasani 01 27', 0, 1, '2025-10-15 16:44:18'),
(8, 15, 'De la plaine', 1, 10, '2025-10-15 16:44:18'),
(9, 15, 'Tuana', 3, 20, '2025-10-15 16:44:18'),
(10, 15, 'Masina Q3 07 08 31', 6, 10, '2025-10-15 16:44:18'),
(11, 14, '14eme Rue', 15, 20, '2025-10-15 17:56:19'),
(12, 14, 'UZAM', 18, 25, '2025-10-15 17:56:19'),
(13, 13, 'Movenda', 3, 7, '2025-10-15 18:01:33'),
(14, 13, 'Rue Bolafa', 6, 14, '2025-10-15 18:01:33'),
(15, 13, 'Lukandu', 8, 16, '2025-10-15 18:01:33'),
(16, 13, 'Force', 9, 17, '2025-10-15 18:01:33'),
(17, 12, 'Kananga', 4, 6, '2025-10-15 18:05:22'),
(18, 12, 'Ecole Tome', 6, 8, '2025-10-15 18:05:22'),
(19, 12, 'Peloustore', 8, 10, '2025-10-15 18:05:22'),
(20, 12, 'Maternite', 10, 13, '2025-10-15 18:05:22'),
(21, 11, 'Kama', 3, 3, '2025-10-15 18:10:38'),
(22, 11, 'Tumba', 4, 5, '2025-10-15 18:10:38'),
(23, 11, 'Kilubi', 6, 7, '2025-10-15 18:10:38'),
(24, 11, 'Botango', 8, 9, '2025-10-15 18:10:38'),
(25, 11, 'Bakali', 10, 12, '2025-10-15 18:10:38'),
(26, 9, 'Bekatef', 3, 3, '2025-10-15 18:20:44'),
(27, 9, 'Kutu 1', 5, 5, '2025-10-15 18:20:44'),
(28, 9, 'Marche de la liberte', 8, 10, '2025-10-15 18:20:44'),
(29, 9, 'Hop mudombo', 10, 13, '2025-10-15 18:20:44'),
(30, 9, 'Tribunal', 12, 15, '2025-10-15 18:20:44'),
(31, 8, 'Kingu', 1, 2, '2025-10-15 18:26:00'),
(32, 8, 'Zappe', 3, 4, '2025-10-15 18:26:00'),
(33, 8, 'Badiandingi', 6, 8, '2025-10-15 18:26:00'),
(34, 8, 'Entree du camp', 9, 11, '2025-10-15 18:26:00'),
(35, 8, 'Libulu', 12, 14, '2025-10-15 18:26:00'),
(36, 7, 'Niemba', 2, 3, '2025-10-15 18:31:30'),
(37, 7, 'Wasta', 4, 6, '2025-10-15 18:31:30'),
(38, 7, 'Hopital', 6, 8, '2025-10-15 18:31:30'),
(39, 7, 'Poko', 9, 10, '2025-10-15 18:31:30'),
(40, 7, 'Commune', 13, 13, '2025-10-15 18:31:30');

-- --------------------------------------------------------

--
-- Table structure for table `billets`
--

CREATE TABLE `billets` (
  `id` int(11) NOT NULL,
  `numero_billet` varchar(50) NOT NULL,
  `qr_code` varchar(255) DEFAULT NULL,
  `trajet_id` int(11) NOT NULL,
  `tarif_id` int(11) NOT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `bus_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `arret_depart` varchar(100) NOT NULL,
  `arret_arrivee` varchar(100) NOT NULL,
  `date_voyage` date NOT NULL,
  `heure_depart` time DEFAULT NULL,
  `siege_numero` varchar(10) DEFAULT NULL,
  `prix_paye` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `statut_billet` enum('reserve','paye','utilise','annule','expire') DEFAULT 'reserve',
  `mode_paiement` enum('especes','mobile_money','carte_bancaire','autre') DEFAULT 'especes',
  `reference_paiement` varchar(100) DEFAULT NULL,
  `vendu_par` int(11) DEFAULT NULL,
  `point_vente` varchar(100) DEFAULT NULL,
  `date_achat` datetime DEFAULT current_timestamp(),
  `date_utilisation` datetime DEFAULT NULL,
  `date_annulation` datetime DEFAULT NULL,
  `motif_annulation` text DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `billets`
--

INSERT INTO `billets` (`id`, `numero_billet`, `qr_code`, `trajet_id`, `tarif_id`, `shift_id`, `bus_id`, `client_id`, `arret_depart`, `arret_arrivee`, `date_voyage`, `heure_depart`, `siege_numero`, `prix_paye`, `devise`, `statut_billet`, `mode_paiement`, `reference_paiement`, `vendu_par`, `point_vente`, `date_achat`, `date_utilisation`, `date_annulation`, `motif_annulation`, `date_creation`) VALUES
(1, 'BT-2025-001234', NULL, 1, 1, NULL, NULL, 1, 'Kinshasa Centre', 'Matadi Port', '2025-10-12', '08:00:00', NULL, 5000.00, 'CDF', 'paye', 'mobile_money', NULL, NULL, NULL, '2025-10-12 14:30:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(2, 'BT-2025-001235', NULL, 1, 1, NULL, NULL, 3, 'Kinshasa Centre', 'Matadi Port', '2025-10-12', '10:00:00', NULL, 5000.00, 'CDF', 'paye', 'carte_bancaire', NULL, NULL, NULL, '2025-10-12 15:30:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(3, 'BT-2025-001236', NULL, 2, 2, NULL, NULL, 5, 'Kinshasa Centre', 'Kikwit', '2025-10-12', '14:00:00', NULL, 4000.00, 'CDF', 'paye', 'especes', NULL, NULL, NULL, '2025-10-12 16:00:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(4, 'RES-2025-00456', NULL, 1, 1, NULL, NULL, 2, 'Kinshasa Centre', 'Matadi Port', '2025-10-13', '06:00:00', NULL, 5000.00, 'CDF', 'reserve', 'mobile_money', NULL, NULL, NULL, '2025-10-12 13:30:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(5, 'RES-2025-00457', NULL, 3, 3, NULL, NULL, 4, 'Kinshasa Centre', 'Lubumbashi', '2025-10-13', '08:00:00', NULL, 7000.00, 'CDF', 'reserve', 'especes', NULL, NULL, NULL, '2025-10-12 14:30:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(6, 'BT-2025-001237', NULL, 1, 1, NULL, NULL, 1, 'Kinshasa Centre', 'Matadi Port', '2025-10-11', '08:00:00', NULL, 5000.00, 'CDF', 'utilise', 'mobile_money', NULL, NULL, NULL, '2025-10-11 16:30:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(7, 'BT-2025-001238', NULL, 2, 2, NULL, NULL, 3, 'Kinshasa Centre', 'Kikwit', '2025-10-11', '10:00:00', NULL, 4000.00, 'CDF', 'utilise', 'especes', NULL, NULL, NULL, '2025-10-11 16:30:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(8, 'BT-2025-001239', NULL, 1, 1, NULL, NULL, 2, 'Kinshasa Centre', 'Matadi Port', '2025-10-12', '12:00:00', NULL, 5000.00, 'CDF', 'paye', 'mobile_money', NULL, NULL, NULL, '2025-10-12 15:45:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(9, 'BT-2025-001240', NULL, 3, 3, NULL, NULL, 4, 'Kinshasa Centre', 'Lubumbashi', '2025-10-12', '15:00:00', NULL, 7000.00, 'CDF', 'paye', 'carte_bancaire', NULL, NULL, NULL, '2025-10-12 16:10:49', NULL, NULL, NULL, '2025-10-12 16:30:49'),
(10, 'BT-2025-001241', NULL, 2, 2, NULL, NULL, 5, 'Kinshasa Centre', 'Kikwit', '2025-10-12', '16:00:00', NULL, 4000.00, 'CDF', 'paye', 'especes', NULL, NULL, NULL, '2025-10-12 16:20:49', NULL, NULL, NULL, '2025-10-12 16:30:49');

-- --------------------------------------------------------

--
-- Table structure for table `bus`
--

CREATE TABLE `bus` (
  `id` int(11) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `immatriculation` varchar(50) NOT NULL,
  `marque` varchar(50) DEFAULT NULL,
  `modele` varchar(50) DEFAULT NULL,
  `annee` int(11) DEFAULT NULL,
  `capacite` int(11) DEFAULT NULL,
  `kilometrage` int(11) DEFAULT 0,
  `ligne_affectee` varchar(100) DEFAULT '',
  `statut` enum('actif','maintenance','panne','inactif') DEFAULT 'actif',
  `modules` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `derniere_activite` datetime DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bus`
--

INSERT INTO `bus` (`id`, `numero`, `immatriculation`, `marque`, `modele`, `annee`, `capacite`, `kilometrage`, `ligne_affectee`, `statut`, `modules`, `notes`, `derniere_activite`, `latitude`, `longitude`, `date_creation`) VALUES
(1, '421', 'KIN-1234-AB', 'Mercedes', 'Sprinter', 2022, 50, 125450, '8', 'actif', 'datcha,wifi,pos', '', '2025-10-15 18:35:52', -4.33091979, 15.27416397, '2025-10-08 17:23:37'),
(2, '315', 'KIN-5678-CD', 'Toyota', 'Coaster', 2021, 45, 98320, '14', 'actif', 'datcha,gps', '', '2025-10-15 18:35:15', -4.36482077, 15.29580424, '2025-10-08 17:23:37'),
(3, '208', 'KIN-9012-EF', 'Isuzu', 'NPR', 2020, 40, 156780, '8', 'maintenance', 'datcha,camera', 'Révision moteur en cours', '2025-10-15 18:35:36', -4.35491650, 15.28040478, '2025-10-08 17:23:37'),
(4, '156', 'KIN-3456-GH', 'Mercedes', 'Sprinter', 2023, 50, 45200, '3', 'actif', 'datcha,wifi,pos,gps,camera', '', '2025-01-08 08:15:00', -4.36162660, 15.29305269, '2025-10-08 17:23:37'),
(5, '089', 'KIN-7890-IJ', 'Toyota', 'Hiace', 2019, 35, 187650, '1', 'panne', 'datcha', 'Problème de transmission', '2025-01-06 14:20:00', -4.27825676, 15.27195812, '2025-10-08 17:23:37'),
(6, '512', 'KIN-2468-KL', 'Hyundai', 'County', 2023, 45, 32100, '4', 'actif', 'datcha,wifi,gps', '', '2025-01-08 08:30:00', -4.33383911, 15.35733008, '2025-10-08 17:23:37'),
(7, '238', 'KIN-1357-MN', 'Mercedes', 'Sprinter', 2021, 50, 112890, '4', 'actif', 'datcha,wifi,pos,camera', '', '2025-01-08 08:25:00', -4.34023224, 15.26924853, '2025-10-08 17:23:37'),
(8, '310', 'KIN-9753-OP', 'Toyota', 'Coaster', 2020, 45, 143560, '4', 'actif', 'datcha,gps', '', '2025-01-08 08:20:00', -4.36146061, 15.32735135, '2025-10-08 17:23:37'),
(9, '175', 'KIN-4682-QR', 'Isuzu', 'NPR', 2022, 40, 67890, '1', 'inactif', 'datcha', 'En attente d\'affectation', '2025-01-04 16:00:00', NULL, NULL, '2025-10-08 17:23:37'),
(10, '642', 'KIN-8520-ST', 'Mercedes', 'Sprinter', 2024, 55, 12500, '1', 'actif', 'datcha,wifi,pos,gps,camera', 'Nouveau véhicule - Équipement complet', '2025-01-08 08:35:00', -4.30726142, 15.32403885, '2025-10-08 17:23:37'),
(11, '012', 'KIN-7855-TT', 'Mercedes', 'Sprinter', 2015, 50, 80000, '13', 'actif', 'datcha,wifi,pos,gps,camera', 'Nouveau véhicule - Équipement complet', '2025-10-15 18:36:12', -4.28642147, 15.33817610, '2025-10-08 17:32:58'),
(12, '001', 'AR-14452314-AZ', 'Hunda forgonette', 'GTY 147', 2018, 45, 12000, '14', 'actif', 'datcha,camera', '-', '2025-10-15 18:36:36', -4.27825509, 15.33659625, '2025-10-10 22:04:20'),
(14, '002', 'AR-14452314-AS', 'Hunda forgonette', 'GTY 147', 2018, 45, 105000, '11', 'actif', 'gps,camera', '-', '2025-10-15 18:34:47', -4.31065347, 15.27934388, '2025-10-10 22:06:09'),
(15, '003', 'KIN-54855-AX', 'Toyota', 'Coaster', 2021, 45, 12, '8', 'actif', 'datcha,wifi', '-', '2025-10-11 00:06:09', -4.29972017, 15.30576753, '2025-10-10 22:23:20'),
(16, '004', 'KIN-577855-AX', 'Toyota', 'Coaster', 2021, 45, 12, '15', 'actif', 'datcha,wifi,pos,gps,camera', '-', '2025-10-15 16:47:20', -4.30040186, 15.32308814, '2025-10-10 22:25:02'),
(17, '005', 'LSH-478961-AB', 'Mercedes', 'Sprinter', 2019, 50, 3000, '15', 'actif', 'datcha,wifi,pos,gps', 'Nouveau vehicule sans carte rose', '2025-10-15 18:34:24', -4.31175373, 15.31436694, '2025-10-10 22:40:12'),
(18, '006', 'LSH-4774451-AB', 'Karsan', 'e-ATA', 2025, 135, 150, '7', 'panne', 'datcha,wifi,pos,gps,camera', 'Ce bus embarque jusqu\'à 449 kWh d\'énergie dans des batteries lithium-fer-phosphate (LFP). L\'autonomie annoncée est de 450 km (rechargement complet en 3h10).', '2025-10-15 18:34:02', -4.32130409, 15.29277870, '2025-10-10 23:12:15');

-- --------------------------------------------------------

--
-- Table structure for table `caisses`
--

CREATE TABLE `caisses` (
  `id` int(11) NOT NULL,
  `point_vente_id` int(11) NOT NULL,
  `numero_caisse` varchar(20) NOT NULL,
  `operateur_id` int(11) DEFAULT NULL,
  `date_ouverture` datetime NOT NULL,
  `date_fermeture` datetime DEFAULT NULL,
  `montant_initial` decimal(10,2) DEFAULT 0.00,
  `montant_final` decimal(10,2) DEFAULT NULL,
  `total_ventes` decimal(10,2) DEFAULT 0.00,
  `total_especes` decimal(10,2) DEFAULT 0.00,
  `total_mobile_money` decimal(10,2) DEFAULT 0.00,
  `total_carte` decimal(10,2) DEFAULT 0.00,
  `nombre_billets_vendus` int(11) DEFAULT 0,
  `statut_caisse` enum('ouverte','fermee','suspendue') DEFAULT 'ouverte',
  `ecart` decimal(10,2) DEFAULT 0.00,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cartes_prepayees`
--

CREATE TABLE `cartes_prepayees` (
  `id` int(11) NOT NULL,
  `numero_carte` varchar(50) NOT NULL,
  `code_pin` varchar(255) DEFAULT NULL,
  `qr_code` varchar(255) DEFAULT NULL,
  `type_carte` enum('standard','etudiant','entreprise','senior','vip') DEFAULT 'standard',
  `nom_titulaire` varchar(100) NOT NULL,
  `telephone_titulaire` varchar(20) NOT NULL,
  `email_titulaire` varchar(100) DEFAULT NULL,
  `entreprise_nom` varchar(100) DEFAULT NULL,
  `entreprise_id` varchar(50) DEFAULT NULL,
  `ecole_nom` varchar(100) DEFAULT NULL,
  `numero_etudiant` varchar(50) DEFAULT NULL,
  `solde_actuel` decimal(10,2) DEFAULT 0.00,
  `devise` varchar(10) DEFAULT 'CDF',
  `statut_carte` enum('active','bloquee','expiree','perdue','desactivee') DEFAULT 'active',
  `date_activation` date DEFAULT NULL,
  `date_expiration` date DEFAULT NULL,
  `plafond_journalier` decimal(10,2) DEFAULT NULL,
  `reduction_pourcentage` decimal(5,2) DEFAULT 0.00,
  `photo_titulaire` varchar(255) DEFAULT NULL,
  `document_justificatif` varchar(255) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `nom` varchar(50) DEFAULT NULL,
  `prenom` varchar(50) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `nom`, `prenom`, `telephone`, `email`, `date_creation`) VALUES
(0, 'Mukendi', 'Jean', '+243 812 345 678', 'jean.mukendi@email.com', '2025-10-12 15:30:49');

-- --------------------------------------------------------

--
-- Table structure for table `colis`
--

CREATE TABLE `colis` (
  `id` int(11) NOT NULL,
  `numero_colis` varchar(50) NOT NULL,
  `code_suivi` varchar(50) NOT NULL,
  `qr_code` varchar(255) DEFAULT NULL,
  `expediteur_nom` varchar(100) NOT NULL,
  `expediteur_telephone` varchar(20) NOT NULL,
  `expediteur_email` varchar(100) DEFAULT NULL,
  `expediteur_adresse` text DEFAULT NULL,
  `destinataire_nom` varchar(100) NOT NULL,
  `destinataire_telephone` varchar(20) NOT NULL,
  `destinataire_email` varchar(100) DEFAULT NULL,
  `destinataire_adresse` text DEFAULT NULL,
  `arret_depart` varchar(100) NOT NULL,
  `arret_arrivee` varchar(100) NOT NULL,
  `bus_id` int(11) DEFAULT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `date_expedition` date NOT NULL,
  `date_livraison_prevue` date DEFAULT NULL,
  `date_livraison_effective` datetime DEFAULT NULL,
  `description_colis` text NOT NULL,
  `poids` decimal(10,2) DEFAULT NULL,
  `dimensions` varchar(50) DEFAULT NULL,
  `valeur_declaree` decimal(10,2) DEFAULT NULL,
  `fragile` tinyint(1) DEFAULT 0,
  `type_colis` enum('standard','fragile','express','volumineux','precieux') DEFAULT 'standard',
  `prix_transport` decimal(10,2) NOT NULL,
  `assurance` decimal(10,2) DEFAULT 0.00,
  `montant_total` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `mode_paiement` enum('especes','mobile_money','carte_bancaire','autre') DEFAULT 'especes',
  `reference_paiement` varchar(100) DEFAULT NULL,
  `statut_colis` enum('enregistre','en_transit','arrive','livre','retourne','perdu') DEFAULT 'enregistre',
  `statut_paiement` enum('non_paye','paye','rembourse') DEFAULT 'non_paye',
  `signature_destinataire` text DEFAULT NULL,
  `photo_colis` varchar(255) DEFAULT NULL,
  `recu_path` varchar(255) DEFAULT NULL,
  `observations` text DEFAULT NULL,
  `enregistre_par` int(11) DEFAULT NULL,
  `livre_par` int(11) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `documents_bus`
--

CREATE TABLE `documents_bus` (
  `id` int(11) NOT NULL,
  `bus_id` int(11) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `statut` enum('valide','expire','bientot') DEFAULT 'valide',
  `date_emission` date DEFAULT NULL,
  `date_expiration` date DEFAULT NULL,
  `fichier_path` varchar(255) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp(),
  `date_modification` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `documents_bus`
--

INSERT INTO `documents_bus` (`id`, `bus_id`, `designation`, `statut`, `date_emission`, `date_expiration`, `fichier_path`, `date_creation`, `date_modification`) VALUES
(1, 1, 'Assurance', 'valide', '2024-01-15', '2025-12-15', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(2, 1, 'Contrôle technique', 'valide', '2024-02-20', '2025-08-20', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(3, 1, 'Carte grise', 'valide', '2022-03-10', '2027-03-10', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(4, 1, 'Vignette', 'bientot', '2024-01-01', '2025-01-25', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(5, 2, 'Assurance', 'valide', '2024-03-01', '2025-11-01', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(6, 2, 'Contrôle technique', 'valide', '2024-04-15', '2025-10-15', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(7, 2, 'Carte grise', 'valide', '2021-05-20', '2026-05-20', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(8, 2, 'Vignette', 'valide', '2024-01-01', '2025-12-31', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(9, 4, 'Assurance', 'valide', '2023-12-01', '2025-12-01', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(10, 4, 'Contrôle technique', 'valide', '2024-06-10', '2025-12-10', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(11, 4, 'Carte grise', 'valide', '2023-01-15', '2028-01-15', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(12, 4, 'Vignette', 'valide', '2024-01-01', '2025-12-31', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(13, 6, 'Assurance', 'valide', '2023-11-20', '2025-11-20', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(14, 6, 'Contrôle technique', 'valide', '2024-05-10', '2025-11-10', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(15, 6, 'Carte grise', 'valide', '2023-02-15', '2028-02-15', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(16, 6, 'Vignette', 'valide', '2024-01-01', '2025-12-31', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(17, 10, 'Assurance', 'valide', '2024-01-05', '2026-01-05', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(18, 10, 'Contrôle technique', 'valide', '2024-01-10', '2025-07-10', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(19, 10, 'Carte grise', 'valide', '2024-01-01', '2029-01-01', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(20, 10, 'Vignette', 'valide', '2024-01-01', '2025-12-31', NULL, '2025-10-08 17:23:37', '2025-10-08 17:23:37'),
(21, 11, 'Assurance', 'valide', '2024-01-15', '2025-12-15', NULL, '2025-10-08 17:32:58', '2025-10-08 17:32:58'),
(22, 11, 'Contrôle technique', 'valide', '2024-02-20', '2025-08-20', NULL, '2025-10-08 17:32:58', '2025-10-08 17:32:58'),
(23, 11, 'Carte grise', 'valide', '2022-03-10', '2027-03-10', NULL, '2025-10-08 17:32:58', '2025-10-08 17:32:58'),
(24, 11, 'Vignette', 'bientot', '2024-01-01', '2025-01-25', NULL, '2025-10-08 17:32:58', '2025-10-08 17:32:58');

-- --------------------------------------------------------

--
-- Table structure for table `equipe_bord`
--

CREATE TABLE `equipe_bord` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `matricule` varchar(50) DEFAULT NULL,
  `poste` enum('chauffeur','controleur','receveur','mecanicien','administratif') NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `adresse` text DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `bus_affecte` varchar(20) DEFAULT NULL,
  `statut` enum('actif','conge','suspendu','inactif') DEFAULT 'actif',
  `date_embauche` date DEFAULT NULL,
  `type_contrat` enum('cdi','cdd','stage','interim') DEFAULT 'cdi',
  `salaire` decimal(10,2) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `equipe_bord`
--

INSERT INTO `equipe_bord` (`id`, `nom`, `matricule`, `poste`, `telephone`, `email`, `adresse`, `date_naissance`, `bus_affecte`, `statut`, `date_embauche`, `type_contrat`, `salaire`, `photo`, `notes`, `date_creation`) VALUES
(1, 'Jean-Pierre Mukendi', 'EMP-2025-001', 'chauffeur', '+243 812 345 678', 'jp.mukendi@safari.cd', NULL, NULL, '421', 'actif', '2020-03-15', 'cdi', NULL, NULL, '5 ans d\'expérience', '2025-10-08 17:23:37'),
(2, 'Marie Tshala', 'EMP-2025-002', 'chauffeur', '+243 823 456 789', 'm.tshala@safari.cd', NULL, NULL, '315', 'actif', '2019-06-20', 'cdi', NULL, NULL, 'Excellente conductrice', '2025-10-08 17:23:37'),
(3, 'Paul Kabongo', 'EMP-2025-003', 'chauffeur', '+243 834 567 890', 'p.kabongo@safari.cd', NULL, NULL, '156', 'actif', '2021-01-10', 'cdi', NULL, NULL, '', '2025-10-08 17:23:37'),
(4, 'Sarah Mbuyi', 'EMP-2025-004', 'chauffeur', '+243 845 678 901', 's.mbuyi@safari.cd', NULL, NULL, '512', 'actif', '2022-08-05', 'cdi', NULL, NULL, '', '2025-10-08 17:23:37'),
(5, 'David Nsimba', 'EMP-2025-005', 'chauffeur', '+243 856 789 012', 'd.nsimba@safari.cd', NULL, NULL, '238', 'actif', '2020-11-12', 'cdi', NULL, NULL, '', '2025-10-08 17:23:37'),
(6, 'Grace Lumbu', 'EMP-2025-006', 'chauffeur', '+243 867 890 123', 'g.lumbu@safari.cd', NULL, NULL, '310', 'actif', '2021-04-18', 'cdi', NULL, NULL, '', '2025-10-08 17:23:37'),
(7, 'Patrick Kalonji', 'EMP-2025-007', 'chauffeur', '+243 878 901 234', 'p.kalonji@safari.cd', NULL, NULL, '642', 'actif', '2023-12-01', 'cdi', NULL, NULL, 'Nouveau chauffeur', '2025-10-08 17:23:37'),
(8, 'Alice Kabila', 'EMP-2025-008', 'receveur', '+243 889 012 345', 'a.kabila@safari.cd', NULL, NULL, '421', 'actif', '2020-05-10', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(9, 'Bob Tshisekedi', 'EMP-2025-009', 'receveur', '+243 890 123 456', 'b.tshisekedi@safari.cd', NULL, NULL, '315', 'actif', '2019-09-15', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(10, 'Claire Mwamba', 'EMP-2025-010', 'receveur', '+243 801 234 567', 'c.mwamba@safari.cd', NULL, NULL, '156', 'actif', '2021-02-20', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(11, 'Daniel Kasongo', 'EMP-2025-011', 'receveur', '+243 812 345 678', 'd.kasongo@safari.cd', NULL, NULL, '512', 'actif', '2022-10-05', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(12, 'Emma Nkulu', 'EMP-2025-012', 'receveur', '+243 823 456 789', 'e.nkulu@safari.cd', NULL, NULL, '238', 'actif', '2020-12-15', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(13, 'Frank Ilunga', 'EMP-2025-013', 'receveur', '+243 834 567 890', 'f.ilunga@safari.cd', NULL, NULL, '310', 'actif', '2021-06-25', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(14, 'Grace Mutombo', 'EMP-2025-014', 'receveur', '+243 845 678 901', 'g.mutombo@safari.cd', NULL, NULL, '642', 'actif', '2024-01-05', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(15, 'Henri Kalala', 'EMP-2025-015', 'controleur', '+243 856 789 012', 'h.kalala@safari.cd', NULL, NULL, '421', 'actif', '2020-04-12', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(16, 'Irene Mulamba', 'EMP-2025-016', 'controleur', '+243 867 890 123', 'i.mulamba@safari.cd', NULL, NULL, '315', 'actif', '2019-08-20', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(17, 'Joseph Kanda', 'EMP-2025-017', 'controleur', '+243 878 901 234', 'j.kanda@safari.cd', NULL, NULL, '156', 'actif', '2021-03-15', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(18, 'Karen Mbala', 'EMP-2025-018', 'controleur', '+243 889 012 345', 'k.mbala@safari.cd', NULL, NULL, '512', 'actif', '2022-09-10', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(19, 'Louis Nzeza', 'EMP-2025-019', 'controleur', '+243 890 123 456', 'l.nzeza@safari.cd', NULL, NULL, '238', 'actif', '2020-10-18', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(20, 'Marie Kabongo', 'EMP-2025-020', 'controleur', '+243 801 234 567', 'm.kabongo@safari.cd', NULL, NULL, '310', 'actif', '2021-05-22', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(21, 'Nathan Tshimanga', 'EMP-2025-021', 'controleur', '+243 812 345 678', 'n.tshimanga@safari.cd', NULL, NULL, '642', 'actif', '2023-12-10', 'cdi', NULL, NULL, NULL, '2025-10-08 17:23:37'),
(22, 'Deflobert Kisongole', 'EMP-2025-022', 'chauffeur', '+243 812 345 678', 'deflo.kisongole@safari.cd', NULL, NULL, '012', 'actif', '2020-03-15', 'cdi', NULL, NULL, '5 ans d\'expérience', '2025-10-08 17:32:58'),
(23, 'Jemima Kabila', 'EMP-2025-023', 'receveur', '+243 889 012 345', 'a.kabila@safari.cd', NULL, NULL, '006', 'actif', '2020-05-10', 'cdi', NULL, NULL, NULL, '2025-10-08 17:32:58'),
(24, 'Janvier Zamunda', 'EMP-2025-024', 'controleur', '+243 856 789 012', 'h.kalala@safari.cd', NULL, NULL, '012', 'actif', '2020-04-12', 'cdi', NULL, NULL, NULL, '2025-10-08 17:32:58'),
(25, 'Kasongo mbondo', 'EMP-2025-025', 'chauffeur', '+243 815 112 000', 'k.mbondo@safari.cd', 'AV GALAXIE N05 GOLF MAISHA', '1992-03-04', '006', 'actif', '2025-10-11', 'cdi', 145000.00, NULL, 'il boss bien', '2025-10-11 00:02:08'),
(26, 'Capitaine America', 'EMP-2025-026', 'controleur', '+243 971 000 000', 'c.ameroca@safari.cd', NULL, NULL, NULL, 'actif', '2025-10-11', 'cdi', 55000.00, NULL, NULL, '2025-10-11 00:03:24'),
(27, 'Mputu herge', 'EMP-2025-027', 'receveur', '+243 974 111 111', 'mputuherge@safari.cd', NULL, NULL, '006', 'suspendu', '2025-10-11', 'cdi', 650000.00, NULL, NULL, '2025-10-11 00:06:10'),
(28, 'Kyle Masangu', 'EMP-2025-028', 'administratif', '+243971342218', 'kylechrismk243@gmail.com', 'Inconnue mais a Lubumbashi', '1996-06-22', NULL, 'actif', '2025-10-11', 'cdi', 1200000.00, NULL, NULL, '2025-10-11 04:11:09'),
(29, 'Newton Isaac', 'EMP-2025-029', 'mecanicien', '+24397445864', 'isaacnewt@gmail.com', 'Anglande inconnue', '1993-02-11', NULL, 'actif', '2025-10-11', 'cdi', 3000000.00, NULL, 'Lorem ipsum', '2025-10-11 04:55:04');

-- --------------------------------------------------------

--
-- Table structure for table `incidents_location`
--

CREATE TABLE `incidents_location` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `type_incident` enum('accident','panne','retard','annulation','dommage','autre') NOT NULL,
  `description` text NOT NULL,
  `gravite` enum('mineure','moyenne','grave') DEFAULT 'mineure',
  `cout_reparation` decimal(10,2) DEFAULT NULL,
  `responsable` enum('client','entreprise','tiers','indetermine') DEFAULT NULL,
  `photos` text DEFAULT NULL,
  `rapport_path` varchar(255) DEFAULT NULL,
  `date_incident` datetime NOT NULL,
  `date_resolution` datetime DEFAULT NULL,
  `statut_incident` enum('ouvert','en_cours','resolu','clos') DEFAULT 'ouvert',
  `notes` text DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations_bus`
--

CREATE TABLE `locations_bus` (
  `id` int(11) NOT NULL,
  `numero_location` varchar(50) NOT NULL,
  `bus_id` int(11) NOT NULL,
  `client_nom` varchar(100) NOT NULL,
  `client_telephone` varchar(20) NOT NULL,
  `client_email` varchar(100) DEFAULT NULL,
  `client_adresse` text DEFAULT NULL,
  `client_type` enum('particulier','entreprise','association','autre') DEFAULT 'particulier',
  `entreprise_nom` varchar(100) DEFAULT NULL,
  `entreprise_nif` varchar(50) DEFAULT NULL,
  `type_location` enum('horaire','journaliere','hebdomadaire','mensuelle','evenement') NOT NULL,
  `date_debut` datetime NOT NULL,
  `date_fin` datetime NOT NULL,
  `duree_heures` int(11) DEFAULT NULL,
  `duree_jours` int(11) DEFAULT NULL,
  `destination` text DEFAULT NULL,
  `itineraire` text DEFAULT NULL,
  `nombre_passagers` int(11) DEFAULT NULL,
  `avec_chauffeur` tinyint(1) DEFAULT 1,
  `chauffeur_id` int(11) DEFAULT NULL,
  `avec_carburant` tinyint(1) DEFAULT 0,
  `kilometrage_debut` int(11) DEFAULT NULL,
  `kilometrage_fin` int(11) DEFAULT NULL,
  `tarif_horaire` decimal(10,2) DEFAULT NULL,
  `tarif_journalier` decimal(10,2) DEFAULT NULL,
  `montant_total` decimal(10,2) NOT NULL,
  `montant_caution` decimal(10,2) DEFAULT 0.00,
  `montant_paye` decimal(10,2) DEFAULT 0.00,
  `montant_restant` decimal(10,2) DEFAULT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `statut_location` enum('demande','confirmee','en_cours','terminee','annulee') DEFAULT 'demande',
  `mode_paiement` enum('especes','mobile_money','carte_bancaire','virement','cheque','autre') DEFAULT NULL,
  `reference_paiement` varchar(100) DEFAULT NULL,
  `contrat_path` varchar(255) DEFAULT NULL,
  `piece_identite_path` varchar(255) DEFAULT NULL,
  `observations` text DEFAULT NULL,
  `creee_par` int(11) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `logs_activite`
--

CREATE TABLE `logs_activite` (
  `id` int(11) NOT NULL,
  `utilisateur_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `table_affectee` varchar(50) DEFAULT NULL,
  `enregistrement_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `departement` enum('PL','BT','RH') NOT NULL,
  `icone` varchar(50) DEFAULT NULL,
  `route` varchar(100) NOT NULL,
  `ordre` int(11) DEFAULT 0,
  `actif` tinyint(1) DEFAULT 1,
  `date_creation` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`id`, `code`, `nom`, `description`, `departement`, `icone`, `route`, `ordre`, `actif`, `date_creation`) VALUES
(1, 'pl_dashboard', 'Dashboard', 'Tableau de bord Planification', 'PL', 'home', 'dashboard_PL', 1, 1, '2025-10-08 15:07:12'),
(2, 'pl_gestion_bus', 'Gestion Bus', 'Gestion de la flotte de bus', 'PL', 'truck', 'gestion-bus', 2, 1, '2025-10-08 15:07:12'),
(3, 'pl_equipe_bord', 'Équipe de bord', 'Gestion des équipes de bord', 'PL', 'users', 'equipe-bord', 3, 1, '2025-10-08 15:07:12'),
(4, 'pl_trajets', 'Trajets', 'Gestion des trajets', 'PL', 'map', 'trajets', 4, 1, '2025-10-08 15:07:12'),
(5, 'pl_shifts', 'Gestion des services', 'Planification des shifts', 'PL', 'calendar', 'shifts', 5, 1, '2025-10-08 15:07:12'),
(6, 'pl_alertes', 'Alertes', 'Système d\'alertes', 'PL', 'bell', 'alerter', 6, 1, '2025-10-08 15:07:12'),
(7, 'pl_bi', 'Business Intelligence', 'Tableaux de bord et statistiques', 'PL', 'bar-chart-2', 'bi', 7, 1, '2025-10-08 15:07:12'),
(8, 'pl_parametres', 'Paramètres', 'Configuration du système', 'PL', 'settings', 'parametres', 8, 1, '2025-10-08 15:07:12'),
(9, 'bt_dashboard', 'Tableau de bord', 'Dashboard Billetterie', 'BT', 'home', 'billetterie', 1, 1, '2025-10-08 15:07:12'),
(10, 'bt_vente_billets', 'Vendre un billet', 'Vente de billets', 'BT', 'shopping-cart', 'vente-billets', 2, 1, '2025-10-08 15:07:12'),
(11, 'bt_reservation', 'Créer une réservation', 'Système de réservation', 'BT', 'calendar', 'reservation', 3, 1, '2025-10-08 15:07:12'),
(12, 'bt_historique', 'Historique', 'Historique des ventes', 'BT', 'list', 'historique', 4, 1, '2025-10-08 15:07:12'),
(13, 'bt_nouvelle_carte', 'Créer une carte', 'Création de cartes prépayées', 'BT', 'plus-circle', 'nouvelle-carte', 5, 1, '2025-10-08 15:07:12'),
(14, 'bt_cartes_prepayees', 'Liste des cartes', 'Gestion des cartes prépayées', 'BT', 'credit-card', 'cartes-prepayees', 6, 1, '2025-10-08 15:07:12'),
(15, 'bt_tarifs', 'Gestion de tarif', 'Configuration des tarifs', 'BT', 'tag', 'tarifs', 7, 1, '2025-10-08 15:07:12'),
(16, 'bt_canaux_vente', 'Canaux de vente', 'Gestion des canaux', 'BT', 'shopping-bag', 'canaux-vente', 8, 1, '2025-10-08 15:07:12'),
(17, 'bt_clients', 'Clients', 'Gestion des clients', 'BT', 'users', 'clients-bt', 9, 1, '2025-10-08 15:07:12'),
(18, 'bt_reclamations', 'Réclamations', 'Gestion des réclamations', 'BT', 'message-circle', 'reclamations', 10, 1, '2025-10-08 15:07:12'),
(19, 'bt_statistiques', 'Statistiques', 'Statistiques de vente', 'BT', 'bar-chart-2', 'statistiques-bt', 11, 1, '2025-10-08 15:07:12'),
(20, 'bt_locations', 'Gestion des locations', 'Location de véhicules', 'BT', 'truck', 'locations', 12, 1, '2025-10-08 15:07:12'),
(21, 'bt_historique_locations', 'Historique locations', 'Historique des locations', 'BT', 'clock', 'historique-locations', 13, 1, '2025-10-08 15:07:12'),
(22, 'rh_dashboard', 'Tableau de bord', 'Dashboard RH', 'RH', 'home', 'rh-dashboard', 1, 1, '2025-10-08 15:07:13'),
(23, 'rh_personnel', 'Gestion du personnel', 'Liste et gestion des employés', 'RH', 'users', 'personnel', 2, 1, '2025-10-08 15:07:13'),
(24, 'rh_nouveau_agent', 'Ajouter un agent', 'Recrutement d\'un nouvel agent', 'RH', 'user-plus', 'nouveau-agent', 3, 1, '2025-10-08 15:07:13'),
(25, 'rh_contrats', 'Gestion des contrats', 'Gestion des contrats de travail', 'RH', 'file-text', 'contrats', 4, 1, '2025-10-08 15:07:13');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `utilisateur_id` int(11) NOT NULL,
  `type_notification` varchar(50) NOT NULL,
  `titre` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `lien` varchar(255) DEFAULT NULL,
  `lu` tinyint(1) DEFAULT 0,
  `date_lecture` datetime DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `paiements_location`
--

CREATE TABLE `paiements_location` (
  `id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `type_paiement` enum('acompte','caution','solde','supplement','remboursement') NOT NULL,
  `montant` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `mode_paiement` enum('especes','mobile_money','carte_bancaire','virement','cheque','autre') NOT NULL,
  `reference_paiement` varchar(100) DEFAULT NULL,
  `operateur_mobile` varchar(50) DEFAULT NULL,
  `numero_telephone_paiement` varchar(20) DEFAULT NULL,
  `recu_numero` varchar(50) DEFAULT NULL,
  `recu_path` varchar(255) DEFAULT NULL,
  `effectue_par` int(11) DEFAULT NULL,
  `date_paiement` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parametres_systeme`
--

CREATE TABLE `parametres_systeme` (
  `id` int(11) NOT NULL,
  `cle` varchar(100) NOT NULL,
  `valeur` text DEFAULT NULL,
  `type_parametre` enum('string','number','boolean','json') DEFAULT 'string',
  `description_parametres` text DEFAULT NULL,
  `date_modification` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `parametres_systeme`
--

INSERT INTO `parametres_systeme` (`id`, `cle`, `valeur`, `type_parametre`, `description_parametres`, `date_modification`) VALUES
(1, 'nom_entreprise', 'Safari Transport', 'string', 'Nom de l\'entreprise', '2025-10-07 20:15:12'),
(2, 'email_contact', 'contact@safari.cd', 'string', 'Email de contact', '2025-10-07 20:15:12'),
(3, 'telephone', '+243 XXX XXX XXX', 'string', 'Numéro de téléphone', '2025-10-07 20:15:12'),
(4, 'fuseau_horaire', 'Africa/Kinshasa', 'string', 'Fuseau horaire', '2025-10-07 20:15:12'),
(5, 'langue', 'fr', 'string', 'Langue par défaut', '2025-10-07 20:15:12'),
(6, 'format_date', 'DD/MM/YYYY', 'string', 'Format de date', '2025-10-07 20:15:12');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `role` enum('admin','supervisor','operator','viewer') NOT NULL,
  `module_id` int(11) NOT NULL,
  `peut_voir` tinyint(1) DEFAULT 0,
  `peut_creer` tinyint(1) DEFAULT 0,
  `peut_modifier` tinyint(1) DEFAULT 0,
  `peut_supprimer` tinyint(1) DEFAULT 0,
  `date_creation` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `role`, `module_id`, `peut_voir`, `peut_creer`, `peut_modifier`, `peut_supprimer`, `date_creation`) VALUES
(1, 'admin', 16, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(2, 'admin', 14, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(3, 'admin', 17, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(4, 'admin', 9, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(5, 'admin', 12, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(6, 'admin', 21, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(7, 'admin', 20, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(8, 'admin', 13, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(9, 'admin', 18, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(10, 'admin', 11, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(11, 'admin', 19, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(12, 'admin', 15, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(13, 'admin', 10, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(14, 'admin', 6, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(15, 'admin', 7, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(16, 'admin', 1, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(17, 'admin', 3, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(18, 'admin', 2, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(19, 'admin', 8, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(20, 'admin', 5, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(21, 'admin', 4, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(22, 'admin', 25, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(23, 'admin', 22, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(24, 'admin', 24, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(25, 'admin', 23, 1, 1, 1, 1, '2025-10-08 15:07:13'),
(32, 'supervisor', 1, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(33, 'supervisor', 2, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(34, 'supervisor', 3, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(35, 'supervisor', 4, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(36, 'supervisor', 5, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(37, 'supervisor', 6, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(38, 'supervisor', 7, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(39, 'supervisor', 8, 0, 1, 1, 0, '2025-10-08 15:07:13'),
(47, 'supervisor', 9, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(48, 'supervisor', 10, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(49, 'supervisor', 11, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(50, 'supervisor', 12, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(51, 'supervisor', 13, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(52, 'supervisor', 14, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(53, 'supervisor', 15, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(54, 'supervisor', 16, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(55, 'supervisor', 17, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(56, 'supervisor', 18, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(57, 'supervisor', 19, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(58, 'supervisor', 20, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(59, 'supervisor', 21, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(62, 'supervisor', 22, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(63, 'supervisor', 23, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(64, 'supervisor', 24, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(65, 'supervisor', 25, 1, 1, 1, 0, '2025-10-08 15:07:13'),
(69, 'operator', 1, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(70, 'operator', 2, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(71, 'operator', 3, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(72, 'operator', 4, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(73, 'operator', 5, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(74, 'operator', 6, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(76, 'operator', 9, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(77, 'operator', 10, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(78, 'operator', 11, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(79, 'operator', 12, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(80, 'operator', 13, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(81, 'operator', 14, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(82, 'operator', 17, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(83, 'operator', 18, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(84, 'operator', 20, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(85, 'operator', 21, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(91, 'operator', 22, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(92, 'operator', 23, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(93, 'operator', 24, 1, 1, 0, 0, '2025-10-08 15:07:13'),
(94, 'viewer', 1, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(95, 'viewer', 2, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(96, 'viewer', 3, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(97, 'viewer', 4, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(98, 'viewer', 5, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(99, 'viewer', 6, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(100, 'viewer', 7, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(101, 'viewer', 9, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(102, 'viewer', 10, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(103, 'viewer', 11, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(104, 'viewer', 12, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(105, 'viewer', 13, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(106, 'viewer', 14, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(107, 'viewer', 17, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(108, 'viewer', 18, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(109, 'viewer', 19, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(110, 'viewer', 20, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(111, 'viewer', 21, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(116, 'viewer', 22, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(117, 'viewer', 23, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(118, 'viewer', 24, 1, 0, 0, 0, '2025-10-08 15:07:13'),
(119, 'viewer', 25, 1, 0, 0, 0, '2025-10-08 15:07:13');

-- --------------------------------------------------------

--
-- Table structure for table `points_chifte`
--

CREATE TABLE `points_chifte` (
  `id` int(11) NOT NULL,
  `trajet_id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `distance_avec_debut` decimal(10,2) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `points_chifte`
--

INSERT INTO `points_chifte` (`id`, `trajet_id`, `nom`, `distance_avec_debut`, `date_creation`) VALUES
(1, 14, 'shift 1', 30.00, '2025-10-11 05:24:40'),
(2, 15, 'Masina Q3 07 08 31', 10.00, '2025-10-15 16:44:18'),
(3, 13, 'shift 1', 20.00, '2025-10-15 18:01:33'),
(4, 12, 'Shift 1', 15.00, '2025-10-15 18:05:22'),
(5, 11, 'Shift 1', 15.00, '2025-10-15 18:10:38'),
(6, 9, 'Shift 1', 20.00, '2025-10-15 18:20:44'),
(7, 8, 'shift 1', 15.00, '2025-10-15 18:26:00'),
(8, 7, 'shift 1', 15.00, '2025-10-15 18:31:30');

-- --------------------------------------------------------

--
-- Table structure for table `points_vente`
--

CREATE TABLE `points_vente` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `type_point` enum('guichet','agence','mobile','en_ligne') DEFAULT 'guichet',
  `adresse` text DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `responsable_nom` varchar(100) DEFAULT NULL,
  `responsable_telephone` varchar(20) DEFAULT NULL,
  `statut` enum('actif','inactif','suspendu') DEFAULT 'actif',
  `horaire_ouverture` varchar(100) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `recharges_carte`
--

CREATE TABLE `recharges_carte` (
  `id` int(11) NOT NULL,
  `carte_id` int(11) NOT NULL,
  `montant` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `mode_paiement` enum('especes','mobile_money','carte_bancaire','virement','autre') NOT NULL,
  `reference_paiement` varchar(100) DEFAULT NULL,
  `operateur_mobile` varchar(50) DEFAULT NULL,
  `numero_telephone_paiement` varchar(20) DEFAULT NULL,
  `frais_recharge` decimal(10,2) DEFAULT 0.00,
  `solde_avant` decimal(10,2) NOT NULL,
  `solde_apres` decimal(10,2) NOT NULL,
  `effectue_par` int(11) DEFAULT NULL,
  `point_vente` varchar(100) DEFAULT NULL,
  `statut_recharge` enum('en_attente','reussie','echouee','annulee') DEFAULT 'en_attente',
  `date_recharge` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reclamations_colis`
--

CREATE TABLE `reclamations_colis` (
  `id` int(11) NOT NULL,
  `colis_id` int(11) NOT NULL,
  `type_reclamation` enum('retard','perte','dommage','erreur_livraison','autre') NOT NULL,
  `description` text NOT NULL,
  `montant_reclame` decimal(10,2) DEFAULT NULL,
  `photos` text DEFAULT NULL,
  `documents` text DEFAULT NULL,
  `statut_reclamation` enum('ouverte','en_cours','resolue','rejetee','fermee') DEFAULT 'ouverte',
  `resolution` text DEFAULT NULL,
  `montant_indemnisation` decimal(10,2) DEFAULT NULL,
  `date_resolution` datetime DEFAULT NULL,
  `traitee_par` int(11) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `numero_reservation` varchar(50) NOT NULL,
  `client_id` int(11) NOT NULL,
  `trajet_id` int(11) NOT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `bus_id` int(11) DEFAULT NULL,
  `arret_depart` varchar(100) NOT NULL,
  `arret_arrivee` varchar(100) NOT NULL,
  `date_voyage` date NOT NULL,
  `heure_depart` time DEFAULT NULL,
  `nombre_places` int(11) DEFAULT 1,
  `sieges_reserves` text DEFAULT NULL,
  `montant_total` decimal(10,2) NOT NULL,
  `statut_reservation` enum('en_attente','confirmee','payee','annulee','expiree') DEFAULT 'en_attente',
  `date_expiration` datetime DEFAULT NULL,
  `code_confirmation` varchar(20) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `id` int(11) NOT NULL,
  `bus_numero` varchar(20) NOT NULL,
  `date_prevue` date NOT NULL,
  `heure_debut` time NOT NULL,
  `heure_fin` time NOT NULL,
  `chauffeur_id` int(11) NOT NULL,
  `controleur_id` int(11) NOT NULL,
  `receveur_id` int(11) NOT NULL,
  `trajet_id` int(11) NOT NULL,
  `shift_effectuee` int(11) NOT NULL,
  `statut` enum('planifie','actif','termine','annule') DEFAULT 'planifie',
  `notes` text DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`id`, `bus_numero`, `date_prevue`, `heure_debut`, `heure_fin`, `chauffeur_id`, `controleur_id`, `receveur_id`, `trajet_id`, `shift_effectuee`, `statut`, `notes`, `date_creation`) VALUES
(1, '012', '2025-10-09', '07:00:00', '15:00:00', 1, 2, 1, 4, 0, 'planifie', NULL, '2025-10-08 21:43:29'),
(2, '006', '2025-10-11', '06:00:00', '12:00:00', 0, 0, 27, 0, 0, 'planifie', NULL, '2025-10-11 01:36:05'),
(5, '006', '2025-10-11', '13:00:00', '19:00:00', 0, 0, 23, 0, 0, 'termine', NULL, '2025-10-11 01:49:40');

-- --------------------------------------------------------

--
-- Table structure for table `statistiques_bi`
--

CREATE TABLE `statistiques_bi` (
  `id` int(11) NOT NULL,
  `type_stat` varchar(50) NOT NULL,
  `valeur` decimal(15,2) NOT NULL,
  `periode` date NOT NULL,
  `bus_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suivi_colis`
--

CREATE TABLE `suivi_colis` (
  `id` int(11) NOT NULL,
  `colis_id` int(11) NOT NULL,
  `statut` varchar(50) NOT NULL,
  `localisation` varchar(100) DEFAULT NULL,
  `bus_id` int(11) DEFAULT NULL,
  `description_etape` text DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `effectue_par` int(11) DEFAULT NULL,
  `date_etape` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tarifs`
--

CREATE TABLE `tarifs` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `trajet_id` int(11) DEFAULT NULL,
  `type_tarif` enum('normal','entreprise','etudiant','senior','enfant','touriste') DEFAULT 'normal',
  `prix` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `statut` enum('actif','inactif') DEFAULT 'actif',
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `latitude_depart` decimal(10,8) DEFAULT NULL,
  `longitude_depart` decimal(11,8) DEFAULT NULL,
  `latitude_arrivee` decimal(10,8) DEFAULT NULL,
  `longitude_arrivee` decimal(11,8) DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `trajets`
--

INSERT INTO `trajets` (`id`, `code`, `nom`, `distance_totale`, `duree_estimee`, `statut`, `latitude_depart`, `longitude_depart`, `latitude_arrivee`, `longitude_arrivee`, `date_creation`) VALUES
(7, NULL, 'KAPELA - CLINIC NGALIEMA', 27.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 14:08:42'),
(8, NULL, 'UPN - CAMPUS (TRAFIC)', 15.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 14:10:58'),
(9, '014', 'MASINA Q3 - PLACE DES EVOLUEE', 30.00, '35', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 14:21:14'),
(11, NULL, 'LEMBA - HOTEL DES POSTES', 3.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-10 17:02:55'),
(12, 'TRJ2510116931', 'UPN - GARE CENTRALE', 30.00, '0', 'actif', NULL, NULL, NULL, NULL, '2025-10-11 05:15:57'),
(13, NULL, 'NGIRI NGIRI - GARE CENTRAL', 15.00, NULL, 'actif', NULL, NULL, NULL, NULL, '2025-10-11 05:22:07'),
(14, NULL, 'MASINA Q1 - BATETELA', 26.00, NULL, 'actif', NULL, NULL, NULL, NULL, '2025-10-11 05:24:40'),
(15, NULL, 'KISANGANI - KINMAZIERE', 30.00, NULL, 'actif', NULL, NULL, NULL, NULL, '2025-10-15 16:44:18');

-- --------------------------------------------------------

--
-- Table structure for table `trajets_effectues`
--

CREATE TABLE `trajets_effectues` (
  `id` int(11) NOT NULL,
  `shift_effectuee` int(10) UNSIGNED ZEROFILL DEFAULT NULL,
  `bus_id` int(11) NOT NULL,
  `trajet_id` int(11) NOT NULL,
  `date_depart` int(11) NOT NULL,
  `heure_depart` time DEFAULT NULL,
  `heure_arrivee` time DEFAULT NULL,
  `nombre_passagers` int(11) DEFAULT 0,
  `revenus` decimal(10,2) DEFAULT 0.00,
  `distance_parcourue` decimal(10,2) DEFAULT NULL,
  `carburant_consomme` decimal(10,2) DEFAULT NULL,
  `incidents` text DEFAULT NULL,
  `statut` enum('termine','en_cours','interronpue','annulee') DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `trajets_effectues`
--

INSERT INTO `trajets_effectues` (`id`, `shift_effectuee`, `bus_id`, `trajet_id`, `date_depart`, `heure_depart`, `heure_arrivee`, `nombre_passagers`, `revenus`, `distance_parcourue`, `carburant_consomme`, `incidents`, `statut`, `date_creation`) VALUES
(1, NULL, 1, 1, 20251012, '06:00:00', '10:30:00', 45, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(2, NULL, 2, 2, 20251012, '06:30:00', '11:00:00', 38, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(3, NULL, 3, 1, 20251012, '14:00:00', '18:30:00', 42, 0.00, NULL, NULL, NULL, 'en_cours', '2025-10-12 16:17:44'),
(4, NULL, 4, 3, 20251012, '14:30:00', NULL, 35, 0.00, NULL, NULL, NULL, 'en_cours', '2025-10-12 16:17:44'),
(5, NULL, 1, 1, 20251011, '06:00:00', '10:30:00', 48, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(6, NULL, 2, 2, 20251011, '06:30:00', '11:00:00', 40, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(7, NULL, 3, 1, 20251011, '14:00:00', '18:30:00', 44, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(8, NULL, 4, 3, 20251011, '14:30:00', '19:00:00', 37, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(9, NULL, 5, 4, 20251011, '07:00:00', '12:00:00', 30, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(10, NULL, 1, 1, 20251010, '06:00:00', '10:30:00', 46, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(11, NULL, 2, 2, 20251010, '06:30:00', '11:00:00', 39, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(12, NULL, 3, 1, 20251010, '14:00:00', '18:30:00', 43, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(13, NULL, 4, 3, 20251010, '14:30:00', '19:00:00', 36, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(14, NULL, 1, 1, 20251009, '06:00:00', '10:30:00', 47, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(15, NULL, 2, 2, 20251009, '06:30:00', '11:00:00', 41, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(16, NULL, 3, 1, 20251009, '14:00:00', '18:30:00', 45, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(17, NULL, 4, 3, 20251009, '14:30:00', '19:00:00', 38, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(18, NULL, 5, 4, 20251009, '07:00:00', '12:00:00', 32, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(19, NULL, 1, 1, 20251008, '06:00:00', '10:30:00', 44, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(20, NULL, 2, 2, 20251008, '06:30:00', '11:00:00', 37, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(21, NULL, 3, 1, 20251008, '14:00:00', '18:30:00', 41, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(22, NULL, 1, 1, 20251007, '06:00:00', '10:30:00', 45, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(23, NULL, 2, 2, 20251007, '06:30:00', '11:00:00', 38, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(24, NULL, 4, 3, 20251007, '14:30:00', '19:00:00', 35, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(25, NULL, 1, 1, 20251006, '06:00:00', '10:30:00', 46, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(26, NULL, 2, 2, 20251006, '06:30:00', '11:00:00', 39, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(27, NULL, 3, 1, 20251006, '14:00:00', '18:30:00', 42, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(28, NULL, 5, 4, 20251006, '07:00:00', '12:00:00', 31, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(29, NULL, 1, 1, 20251005, '06:00:00', '10:30:00', 47, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(30, NULL, 2, 2, 20251005, '06:30:00', '11:00:00', 40, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(31, NULL, 4, 3, 20251005, '14:30:00', '19:00:00', 36, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(32, NULL, 1, 1, 20251002, '06:00:00', '10:30:00', 48, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(33, NULL, 2, 2, 20251002, '06:30:00', '11:00:00', 41, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(34, NULL, 3, 1, 20251001, '14:00:00', '18:30:00', 43, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(35, NULL, 4, 3, 20250930, '14:30:00', '19:00:00', 37, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(36, NULL, 5, 4, 20250929, '07:00:00', '12:00:00', 33, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(37, NULL, 1, 1, 20250928, '06:00:00', '10:30:00', 46, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(38, NULL, 2, 2, 20250927, '06:30:00', '11:00:00', 39, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(39, NULL, 3, 1, 20250926, '14:00:00', '18:30:00', 44, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(40, NULL, 4, 3, 20250925, '14:30:00', '19:00:00', 38, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(41, NULL, 1, 1, 20250924, '06:00:00', '10:30:00', 45, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(42, NULL, 2, 2, 20250923, '06:30:00', '11:00:00', 40, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(43, NULL, 5, 4, 20250922, '07:00:00', '12:00:00', 34, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(44, NULL, 1, 1, 20250921, '06:00:00', '10:30:00', 47, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(45, NULL, 2, 2, 20250920, '06:30:00', '11:00:00', 42, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(46, NULL, 3, 1, 20250919, '14:00:00', '18:30:00', 41, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(47, NULL, 4, 3, 20250918, '14:30:00', '19:00:00', 36, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(48, NULL, 1, 1, 20250917, '06:00:00', '10:30:00', 48, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(49, NULL, 2, 2, 20250916, '06:30:00', '11:00:00', 43, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(50, NULL, 5, 4, 20250915, '07:00:00', '12:00:00', 35, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(51, NULL, 3, 1, 20250914, '14:00:00', '18:30:00', 42, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(52, NULL, 4, 3, 20250913, '14:30:00', '19:00:00', 39, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44'),
(53, NULL, 1, 1, 20250912, '06:00:00', '10:30:00', 46, 0.00, NULL, NULL, NULL, 'termine', '2025-10-12 16:17:44');

-- --------------------------------------------------------

--
-- Table structure for table `transactions_billeterie`
--

CREATE TABLE `transactions_billeterie` (
  `id` int(11) NOT NULL,
  `type_transaction` enum('vente','reservation','annulation','remboursement') NOT NULL,
  `billet_id` int(11) DEFAULT NULL,
  `reservation_id` int(11) DEFAULT NULL,
  `montant` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `mode_paiement` enum('especes','mobile_money','carte_bancaire','autre') NOT NULL,
  `reference_paiement` varchar(100) DEFAULT NULL,
  `statut_transaction` enum('en_attente','reussie','echouee','annulee') DEFAULT 'en_attente',
  `operateur_mobile` varchar(50) DEFAULT NULL,
  `numero_telephone_paiement` varchar(20) DEFAULT NULL,
  `frais_transaction` decimal(10,2) DEFAULT 0.00,
  `effectue_par` int(11) DEFAULT NULL,
  `point_vente` varchar(100) DEFAULT NULL,
  `details_transaction` text DEFAULT NULL,
  `date_transaction` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transactions_billeterie`
--

INSERT INTO `transactions_billeterie` (`id`, `type_transaction`, `billet_id`, `reservation_id`, `montant`, `devise`, `mode_paiement`, `reference_paiement`, `statut_transaction`, `operateur_mobile`, `numero_telephone_paiement`, `frais_transaction`, `effectue_par`, `point_vente`, `details_transaction`, `date_transaction`) VALUES
(1, 'vente', 1, NULL, 5000.00, 'CDF', 'mobile_money', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 14:30:49'),
(2, 'vente', 2, NULL, 5000.00, 'CDF', 'carte_bancaire', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 15:30:49'),
(3, 'vente', 3, NULL, 4000.00, 'CDF', 'especes', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 16:00:49'),
(4, 'reservation', 4, NULL, 5000.00, 'CDF', 'mobile_money', NULL, 'en_attente', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 13:30:49'),
(5, 'reservation', 5, NULL, 7000.00, 'CDF', 'especes', NULL, 'en_attente', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 14:30:49'),
(6, 'vente', 6, NULL, 5000.00, 'CDF', 'mobile_money', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-11 16:30:49'),
(7, 'vente', 7, NULL, 4000.00, 'CDF', 'especes', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-11 16:30:49'),
(8, 'vente', 8, NULL, 5000.00, 'CDF', 'mobile_money', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 15:45:49'),
(9, 'vente', 9, NULL, 7000.00, 'CDF', 'carte_bancaire', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 16:10:49'),
(10, 'vente', 10, NULL, 4000.00, 'CDF', 'especes', NULL, 'reussie', NULL, NULL, 0.00, NULL, NULL, NULL, '2025-10-12 16:20:49');

-- --------------------------------------------------------

--
-- Table structure for table `transactions_carte`
--

CREATE TABLE `transactions_carte` (
  `id` int(11) NOT NULL,
  `carte_id` int(11) NOT NULL,
  `type_transaction` enum('paiement_billet','recharge','remboursement','annulation') NOT NULL,
  `billet_id` int(11) DEFAULT NULL,
  `montant` decimal(10,2) NOT NULL,
  `devise` varchar(10) DEFAULT 'CDF',
  `solde_avant` decimal(10,2) NOT NULL,
  `solde_apres` decimal(10,2) NOT NULL,
  `reduction_appliquee` decimal(10,2) DEFAULT 0.00,
  `bus_id` int(11) DEFAULT NULL,
  `trajet_id` int(11) DEFAULT NULL,
  `reference_transaction` varchar(100) DEFAULT NULL,
  `description_transaction` text DEFAULT NULL,
  `date_transaction` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `departement` enum('PL','BT','RH') NOT NULL DEFAULT 'PL',
  `role` enum('admin','supervisor','operator','viewer') DEFAULT 'viewer',
  `statut` enum('actif','inactif','suspendu') DEFAULT 'actif',
  `avatar` varchar(10) DEFAULT NULL,
  `derniere_connexion` datetime DEFAULT NULL,
  `date_creation` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `nom`, `email`, `mot_de_passe`, `departement`, `role`, `statut`, `avatar`, `derniere_connexion`, `date_creation`) VALUES
(1, 'Superviseur Planification', 'admin.pl@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'PL', 'supervisor', 'actif', 'SP', '2025-10-15 16:39:10', '2025-10-08 15:18:56'),
(2, 'Admin Billetterie', 'admin.bt@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'BT', 'admin', 'actif', 'AB', '2025-10-15 18:37:21', '2025-10-08 15:18:56'),
(3, 'Admin RH', 'admin.rh@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'RH', 'admin', 'actif', 'RH', '2025-10-15 16:41:33', '2025-10-08 15:18:56'),
(4, 'Landry Mwanda', 'landry.pl@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'PL', 'operator', 'actif', 'KM', '2025-10-08 16:11:38', '2025-10-08 15:18:56'),
(5, 'Larry Kaboba', 'larry.kaboba@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'BT', 'operator', 'actif', 'LK', NULL, '2025-10-08 15:18:56'),
(6, 'Marie Tshala', 'marie.tshala@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'RH', 'viewer', 'actif', 'MT', NULL, '2025-10-08 15:18:56'),
(7, 'Kyle Masangu', 'admin.all@safari.cd', '$argon2id$v=19$m=65536,t=4,p=1$MWVZSm9PZFdjWnhBNzVlSg$/1PvHawr7q6CyhaIsm8X+DqolE2rqEZdgzrIbT74YMQ', 'PL', 'admin', 'actif', 'KM', '2025-10-16 01:20:01', '2025-10-08 15:28:58'),
(8, 'Testeur 1', 'testeur1.pl@safari.com', '$2y$10$OYsD.ULr8jq.PZQyf1ocR.jkAuDQ2t.Utru52aSkWWsj/wzvtwxPe', 'PL', 'viewer', 'inactif', 'T1', NULL, '2025-10-13 22:06:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `affectations_equipe`
--
ALTER TABLE `affectations_equipe`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alertes`
--
ALTER TABLE `alertes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alertes_historique`
--
ALTER TABLE `alertes_historique`
  ADD PRIMARY KEY (`id`),
  ADD KEY `alerte_id` (`alerte_id`),
  ADD KEY `traite_par` (`traite_par`);

--
-- Indexes for table `arrets`
--
ALTER TABLE `arrets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `billets`
--
ALTER TABLE `billets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_billet` (`numero_billet`);

--
-- Indexes for table `bus`
--
ALTER TABLE `bus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero` (`numero`),
  ADD UNIQUE KEY `immatriculation` (`immatriculation`);

--
-- Indexes for table `caisses`
--
ALTER TABLE `caisses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cartes_prepayees`
--
ALTER TABLE `cartes_prepayees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_carte` (`numero_carte`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `colis`
--
ALTER TABLE `colis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_colis` (`numero_colis`),
  ADD UNIQUE KEY `code_suivi` (`code_suivi`);

--
-- Indexes for table `documents_bus`
--
ALTER TABLE `documents_bus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `equipe_bord`
--
ALTER TABLE `equipe_bord`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `matricule` (`matricule`);

--
-- Indexes for table `incidents_location`
--
ALTER TABLE `incidents_location`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `locations_bus`
--
ALTER TABLE `locations_bus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_location` (`numero_location`);

--
-- Indexes for table `logs_activite`
--
ALTER TABLE `logs_activite`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `paiements_location`
--
ALTER TABLE `paiements_location`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `parametres_systeme`
--
ALTER TABLE `parametres_systeme`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cle` (`cle`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_role_module` (`role`,`module_id`);

--
-- Indexes for table `points_chifte`
--
ALTER TABLE `points_chifte`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `points_vente`
--
ALTER TABLE `points_vente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `recharges_carte`
--
ALTER TABLE `recharges_carte`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reclamations_colis`
--
ALTER TABLE `reclamations_colis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_reservation` (`numero_reservation`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `statistiques_bi`
--
ALTER TABLE `statistiques_bi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suivi_colis`
--
ALTER TABLE `suivi_colis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tarifs`
--
ALTER TABLE `tarifs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trajets`
--
ALTER TABLE `trajets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trajets_effectues`
--
ALTER TABLE `trajets_effectues`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions_billeterie`
--
ALTER TABLE `transactions_billeterie`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions_carte`
--
ALTER TABLE `transactions_carte`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `affectations_equipe`
--
ALTER TABLE `affectations_equipe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `alertes`
--
ALTER TABLE `alertes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `alertes_historique`
--
ALTER TABLE `alertes_historique`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `arrets`
--
ALTER TABLE `arrets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `billets`
--
ALTER TABLE `billets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `bus`
--
ALTER TABLE `bus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cartes_prepayees`
--
ALTER TABLE `cartes_prepayees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colis`
--
ALTER TABLE `colis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `documents_bus`
--
ALTER TABLE `documents_bus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `equipe_bord`
--
ALTER TABLE `equipe_bord`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `incidents_location`
--
ALTER TABLE `incidents_location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locations_bus`
--
ALTER TABLE `locations_bus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs_activite`
--
ALTER TABLE `logs_activite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paiements_location`
--
ALTER TABLE `paiements_location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parametres_systeme`
--
ALTER TABLE `parametres_systeme`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `points_chifte`
--
ALTER TABLE `points_chifte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `points_vente`
--
ALTER TABLE `points_vente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recharges_carte`
--
ALTER TABLE `recharges_carte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reclamations_colis`
--
ALTER TABLE `reclamations_colis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `statistiques_bi`
--
ALTER TABLE `statistiques_bi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suivi_colis`
--
ALTER TABLE `suivi_colis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tarifs`
--
ALTER TABLE `tarifs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trajets`
--
ALTER TABLE `trajets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `trajets_effectues`
--
ALTER TABLE `trajets_effectues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `transactions_billeterie`
--
ALTER TABLE `transactions_billeterie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `transactions_carte`
--
ALTER TABLE `transactions_carte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alertes_historique`
--
ALTER TABLE `alertes_historique`
  ADD CONSTRAINT `fk_alertes_historique_alerte` FOREIGN KEY (`alerte_id`) REFERENCES `alertes` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
