-- Script pour ajouter le champ PIN à la table equipe_bord
-- Safari Smart Mobility - Authentification équipe de bord
-- Date: 2025-10-16

USE ngla4195_safari;

-- Vérifier si la colonne pin n'existe pas déjà
ALTER TABLE equipe_bord 
ADD COLUMN IF NOT EXISTS pin VARCHAR(6) DEFAULT NULL COMMENT 'Code PIN pour authentification (6 chiffres)';

-- Ajouter des PINs par défaut pour les tests (à modifier en production)
UPDATE equipe_bord SET pin = '123456' WHERE poste = 'chauffeur' AND pin IS NULL;
UPDATE equipe_bord SET pin = '654321' WHERE poste = 'receveur' AND pin IS NULL;
UPDATE equipe_bord SET pin = '111111' WHERE poste = 'controleur' AND pin IS NULL;

-- Afficher le résultat
SELECT id, nom, matricule, poste, pin, statut FROM equipe_bord WHERE poste IN ('chauffeur', 'receveur', 'controleur') ORDER BY poste, id LIMIT 20;
