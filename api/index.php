<?php
/**
 * Point d'entrée de l'API Safari Smart Mobility
 * Gère toutes les requêtes API
 */

// Inclure la configuration CORS
require_once __DIR__ . '/config/cors.php';

// Inclure la configuration de la base de données
require_once __DIR__ . '/config/database.php';

// Inclure le routeur
require_once __DIR__ . '/routes/api.php';

// Activer l'affichage des erreurs en développement (désactiver en production)
error_reporting(E_ALL);
ini_set('display_errors', 1); // Mettre à 1 pour voir les erreurs en développement
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/logs/error.log');

// Créer le dossier logs s'il n'existe pas
if (!file_exists(__DIR__ . '/logs')) {
    mkdir(__DIR__ . '/logs', 0755, true);
}

try {
    // Connexion à la base de données
    $database = new Database();
    $db = $database->getConnection();
    
    // Récupérer la méthode HTTP
    $method = $_SERVER['REQUEST_METHOD'];

    // Récupérer l'URI demandée
    $uri = $_SERVER['REQUEST_URI'];
    
    // Retirer le préfixe /api si présent
    $uri = str_replace('/api/', '', $uri);
    
    // Retirer les paramètres de requête
    $uri = strtok($uri, '?');

    // Créer une instance du routeur et router la requête
    $router = new Router($db);
    $router->route($method, $uri);

} catch (Exception $e) {
    // Log l'erreur
    error_log("Erreur API: " . $e->getMessage());
    
    // Retourner une réponse d'erreur
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Erreur interne du serveur",
        "error" => $e->getMessage()
    ]);
}
