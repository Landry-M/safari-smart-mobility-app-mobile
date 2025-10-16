<?php
/**
 * Script de test pour l'API Safari Smart Mobility
 * Exécuter ce script pour vérifier que l'API fonctionne correctement
 */

echo "=== Test de l'API Safari Smart Mobility ===\n\n";

// Test 1: Connexion à la base de données
echo "1. Test de connexion à la base de données...\n";
try {
    require_once __DIR__ . '/config/database.php';
    $database = new Database();
    $db = $database->getConnection();
    echo "   ✅ Connexion réussie\n\n";
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
    exit(1);
}

// Test 2: Création d'un client de test
echo "2. Test de création d'un client...\n";
try {
    require_once __DIR__ . '/models/Client.php';
    $client = new Client($db);
    $client->uid = 'test_uid_' . time();
    $client->nom = 'Test';
    $client->prenom = 'User';
    $client->telephone = '+243 999 999 999';
    $client->email = 'test@safari.cd';
    
    if ($client->create()) {
        echo "   ✅ Client créé avec succès (ID: {$client->id}, UID: {$client->uid})\n\n";
        $testClientId = $client->id;
        $testClientUid = $client->uid;
    } else {
        echo "   ❌ Échec de la création du client\n\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
    exit(1);
}

// Test 3: Récupération du client par ID
echo "3. Test de récupération du client par ID...\n";
try {
    $client->id = $testClientId;
    $result = $client->getById();
    if ($result && $result['id'] === $testClientId) {
        echo "   ✅ Client récupéré avec succès\n";
        echo "   - ID: {$result['id']}\n";
        echo "   - Nom: {$result['nom']} {$result['prenom']}\n";
        echo "   - Téléphone: {$result['telephone']}\n\n";
    } else {
        echo "   ❌ Client non trouvé\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

// Test 4: Récupération du client par UID Firebase
echo "4. Test de récupération du client par UID Firebase...\n";
try {
    $client->uid = $testClientUid;
    $result = $client->getByUid();
    if ($result && $result['uid'] === $testClientUid) {
        echo "   ✅ Client récupéré par UID avec succès\n";
        echo "   - ID: {$result['id']}\n";
        echo "   - UID: {$result['uid']}\n\n";
    } else {
        echo "   ❌ Client non trouvé par UID\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

// Test 5: Récupération du client par téléphone
echo "5. Test de récupération du client par téléphone...\n";
try {
    $client->telephone = '+243 999 999 999';
    $result = $client->getByPhone();
    if ($result) {
        echo "   ✅ Client trouvé par téléphone\n\n";
    } else {
        echo "   ❌ Client non trouvé par téléphone\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

// Test 6: Mise à jour du client
echo "6. Test de mise à jour du client...\n";
try {
    $client->id = $testClientId;
    $client->nom = 'Test Modifié';
    $client->email = 'test.modifie@safari.cd';
    
    if ($client->update()) {
        echo "   ✅ Client mis à jour avec succès\n\n";
    } else {
        echo "   ❌ Échec de la mise à jour\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

// Test 7: Vérification de l'existence du client
echo "7. Test de vérification de l'existence...\n";
try {
    $client->id = $testClientId;
    if ($client->exists()) {
        echo "   ✅ Client existe bien dans la base\n\n";
    } else {
        echo "   ❌ Client n'existe pas\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

// Test 8: Suppression du client de test
echo "8. Test de suppression du client...\n";
try {
    $client->id = $testClientId;
    if ($client->delete()) {
        echo "   ✅ Client supprimé avec succès\n\n";
    } else {
        echo "   ❌ Échec de la suppression\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

// Test 9: Vérification de la suppression
echo "9. Vérification de la suppression...\n";
try {
    $client->id = $testClientId;
    if (!$client->exists()) {
        echo "   ✅ Client bien supprimé\n\n";
    } else {
        echo "   ❌ Client toujours présent\n\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erreur: " . $e->getMessage() . "\n\n";
}

echo "=== Tous les tests sont terminés ===\n";
echo "\nPour tester l'API via HTTP, utilisez :\n";
echo "curl -X POST http://localhost/clients \\\n";
echo "  -H \"Content-Type: application/json\" \\\n";
echo "  -d '{\"uid\":\"firebase_uid_test\",\"telephone\":\"+243812345678\",\"nom\":\"Doe\",\"prenom\":\"John\"}'\n";
