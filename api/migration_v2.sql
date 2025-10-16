-- =====================================================
-- Migration Script: ID Auto-increment + UID Firebase
-- Version: 2.0.0
-- Date: 2025-10-16
-- =====================================================
-- 
-- Ce script migre la table clients de la version 1 à la version 2
-- AVANT : id = Firebase UID (BIGINT, clé primaire)
-- APRÈS : id = Auto-increment, uid = Firebase UID (VARCHAR UNIQUE)
--
-- ⚠️ ATTENTION : Faites une sauvegarde avant d'exécuter ce script !
-- =====================================================

USE ngla4195_safari;

-- =====================================================
-- Étape 1 : Vérifier la structure actuelle
-- =====================================================
SHOW COLUMNS FROM clients;

-- =====================================================
-- Étape 2 : Créer une table de sauvegarde
-- =====================================================
CREATE TABLE IF NOT EXISTS clients_backup_v1 AS SELECT * FROM clients;
SELECT 'Sauvegarde créée: clients_backup_v1' AS Status;

-- =====================================================
-- Étape 3 : Ajouter la nouvelle colonne uid
-- =====================================================
ALTER TABLE clients ADD COLUMN uid VARCHAR(255) DEFAULT NULL AFTER id;
SELECT 'Colonne uid ajoutée' AS Status;

-- =====================================================
-- Étape 4 : Migrer les données (id -> uid)
-- =====================================================
-- Si vous avez des données existantes avec id = Firebase UID
-- Décommentez cette ligne :
-- UPDATE clients SET uid = id WHERE uid IS NULL;

SELECT 'Données migrées vers uid' AS Status;

-- =====================================================
-- Étape 5 : Supprimer la clé primaire actuelle
-- =====================================================
ALTER TABLE clients DROP PRIMARY KEY;
SELECT 'Clé primaire supprimée' AS Status;

-- =====================================================
-- Étape 6 : Modifier id en AUTO_INCREMENT
-- =====================================================
-- Réinitialiser la colonne id (elle sera vide)
ALTER TABLE clients MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT FIRST;
SELECT 'Colonne id modifiée en AUTO_INCREMENT' AS Status;

-- =====================================================
-- Étape 7 : Restaurer la clé primaire sur id
-- =====================================================
ALTER TABLE clients ADD PRIMARY KEY (id);
SELECT 'Clé primaire restaurée sur id' AS Status;

-- =====================================================
-- Étape 8 : Ajouter l'index UNIQUE sur uid
-- =====================================================
ALTER TABLE clients ADD UNIQUE KEY unique_uid (uid);
SELECT 'Index unique ajouté sur uid' AS Status;

-- =====================================================
-- Étape 9 : Optionnel - Réinitialiser AUTO_INCREMENT
-- =====================================================
-- Si vous voulez commencer à 1
-- ALTER TABLE clients AUTO_INCREMENT = 1;

-- =====================================================
-- Étape 10 : Vérifier la nouvelle structure
-- =====================================================
SHOW COLUMNS FROM clients;

-- =====================================================
-- Étape 11 : Afficher les contraintes
-- =====================================================
SHOW INDEXES FROM clients;

-- =====================================================
-- Résumé de la migration
-- =====================================================
SELECT 
    'Migration terminée' AS Status,
    COUNT(*) AS Total_Clients,
    COUNT(DISTINCT uid) AS Clients_Uniques
FROM clients;

-- =====================================================
-- Vérifications post-migration
-- =====================================================

-- Vérifier qu'il n'y a pas de uid NULL (si vous avez des données)
SELECT COUNT(*) AS Clients_Sans_UID FROM clients WHERE uid IS NULL;

-- Vérifier qu'il n'y a pas de doublons uid
SELECT uid, COUNT(*) AS Nombre
FROM clients
WHERE uid IS NOT NULL
GROUP BY uid
HAVING COUNT(*) > 1;

-- =====================================================
-- En cas de problème : Restauration
-- =====================================================
-- Si quelque chose ne va pas, vous pouvez restaurer :
-- 
-- DROP TABLE clients;
-- CREATE TABLE clients AS SELECT * FROM clients_backup_v1;
-- 
-- Puis réappliquer les contraintes originales
-- =====================================================

-- =====================================================
-- Nettoyage (à faire après vérification)
-- =====================================================
-- Une fois que tout fonctionne bien, vous pouvez supprimer la sauvegarde :
-- DROP TABLE IF EXISTS clients_backup_v1;
-- =====================================================

SELECT '✅ Migration terminée avec succès !' AS Result;
SELECT '⚠️ Vérifiez que tout fonctionne avant de supprimer clients_backup_v1' AS Warning;
