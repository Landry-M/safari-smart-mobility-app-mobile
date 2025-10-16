<?php
/**
 * Script de test pour l'API Billets
 * Permet de vérifier que l'insertion fonctionne correctement
 */

// Test 1: Connexion à la base de données
echo "=== TEST 1: Connexion à la base de données ===\n";
require_once __DIR__ . '/config/database.php';
$database = new Database();
$db = $database->getConnection();

if ($db) {
    echo "✅ Connexion réussie\n\n";
} else {
    echo "❌ Échec de la connexion\n";
    exit(1);
}

// Test 2: Vérifier que la table billets existe
echo "=== TEST 2: Vérification de la table billets ===\n";
try {
    $query = "SHOW TABLES LIKE 'billets'";
    $stmt = $db->prepare($query);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result) {
        echo "✅ Table 'billets' existe\n\n";
    } else {
        echo "❌ Table 'billets' n'existe pas\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "❌ Erreur: " . $e->getMessage() . "\n";
    exit(1);
}

// Test 3: Vérifier la structure de la table
echo "=== TEST 3: Structure de la table billets ===\n";
try {
    $query = "DESCRIBE billets";
    $stmt = $db->prepare($query);
    $stmt->execute();
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "Colonnes trouvées:\n";
    foreach ($columns as $column) {
        echo "  - {$column['Field']} ({$column['Type']})\n";
    }
    echo "\n";
} catch (Exception $e) {
    echo "❌ Erreur: " . $e->getMessage() . "\n";
}

// Test 4: Créer un billet de test
echo "=== TEST 4: Création d'un billet de test ===\n";
require_once __DIR__ . '/models/Billet.php';
$billet = new Billet($db);

$billet->numero_billet = 'TEST-' . time();
$billet->qr_code = 'QR-TEST-' . time();
$billet->trajet_id = null;
$billet->tarif_id = 1;
$billet->shift_id = null;
$billet->bus_id = null;
$billet->client_id = null;
$billet->arret_depart = 'Test Départ';
$billet->arret_arrivee = 'Test Arrivée';
$billet->date_voyage = date('Y-m-d');
$billet->heure_depart = null;
$billet->siege_numero = null;
$billet->prix_paye = 100.00;
$billet->devise = 'CDF';
$billet->statut_billet = 'paye';
$billet->mode_paiement = 'autre';
$billet->reference_paiement = 'TEST-REF-' . time();
$billet->vendu_par = null;
$billet->point_vente = 'Test API';

try {
    if ($billet->create()) {
        echo "✅ Billet créé avec succès\n";
        echo "   ID: " . $billet->id . "\n";
        echo "   Numéro: " . $billet->numero_billet . "\n\n";
        
        // Test 5: Vérifier que le billet a bien été inséré
        echo "=== TEST 5: Vérification de l'insertion ===\n";
        $query = "SELECT * FROM billets WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $billet->id);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($result) {
            echo "✅ Billet trouvé dans la base de données\n";
            echo "   Données: " . json_encode($result, JSON_PRETTY_PRINT) . "\n\n";
            
            // Nettoyage: Supprimer le billet de test
            echo "=== Nettoyage ===\n";
            $deleteQuery = "DELETE FROM billets WHERE id = :id";
            $deleteStmt = $db->prepare($deleteQuery);
            $deleteStmt->bindParam(':id', $billet->id);
            if ($deleteStmt->execute()) {
                echo "✅ Billet de test supprimé\n";
            }
        } else {
            echo "❌ Billet non trouvé après insertion\n";
        }
    } else {
        echo "❌ Échec de la création du billet\n";
        $errorInfo = $db->errorInfo();
        echo "   Erreur SQL: " . print_r($errorInfo, true) . "\n";
    }
} catch (Exception $e) {
    echo "❌ Exception: " . $e->getMessage() . "\n";
    echo "   Trace: " . $e->getTraceAsString() . "\n";
}

// Test 6: Tester l'endpoint API REST
echo "\n=== TEST 6: Test de l'endpoint POST /billets ===\n";
echo "Pour tester l'API via HTTP, exécutez:\n";
echo "curl -X POST https://apiv2.hakika.events/billets \\\n";
echo "  -H 'Content-Type: application/json' \\\n";
echo "  -d '{\n";
echo "    \"numero_billet\": \"TEST-" . time() . "\",\n";
echo "    \"qr_code\": \"QR-TEST-" . time() . "\",\n";
echo "    \"arret_depart\": \"Test Départ\",\n";
echo "    \"arret_arrivee\": \"Test Arrivée\",\n";
echo "    \"date_voyage\": \"" . date('Y-m-d') . "\",\n";
echo "    \"prix_paye\": 100.00,\n";
echo "    \"devise\": \"CDF\",\n";
echo "    \"statut_billet\": \"paye\",\n";
echo "    \"mode_paiement\": \"autre\"\n";
echo "  }'\n\n";

echo "=== RÉSUMÉ DES TESTS ===\n";
echo "Si tous les tests sont ✅, l'API fonctionne correctement.\n";
echo "Si vous voyez des ❌, corrigez les erreurs avant de continuer.\n";
