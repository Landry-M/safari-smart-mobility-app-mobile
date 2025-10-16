-- Fix pour permettre trajet_id NULL dans la table billets
-- Cela permet d'acheter un billet même si on ne connaît pas le trajet exact

USE ngla4195_safari;

-- Modifier la colonne trajet_id pour accepter NULL
ALTER TABLE billets 
MODIFY COLUMN trajet_id int(11) DEFAULT NULL;

-- Vérifier la modification
DESCRIBE billets;

-- Afficher un message de confirmation
SELECT 'La colonne trajet_id accepte maintenant NULL' AS status;
