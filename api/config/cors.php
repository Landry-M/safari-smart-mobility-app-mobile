<?php
/**
 * Configuration CORS pour permettre les requêtes depuis l'application mobile
 */

// Autoriser les requêtes depuis n'importe quelle origine (à restreindre en production)
header("Access-Control-Allow-Origin: *");

// Méthodes HTTP autorisées
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");

// En-têtes autorisés
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept");

// Type de contenu
header("Content-Type: application/json; charset=UTF-8");

// Durée de validité du preflight en secondes
header("Access-Control-Max-Age: 3600");

// Gérer les requêtes OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
