<?php
/**
 * Contrôleur Trajet
 * Gère les requêtes HTTP pour les trajets/lignes
 */

require_once __DIR__ . '/../models/Trajet.php';

class TrajetController {
    private $trajet;

    public function __construct($db) {
        $this->trajet = new Trajet($db);
    }

    /**
     * Récupérer tous les trajets actifs
     * GET /trajets
     */
    public function getAll() {
        $result = $this->trajet->getAll();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Récupérer les noms de lignes pour dropdown
     * GET /trajets/lignes
     */
    public function getLignesNames() {
        $result = $this->trajet->getLignesNames();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Récupérer un trajet par son ID
     * GET /trajets/{id}
     */
    public function getById($id) {
        $this->trajet->id = $id;
        $result = $this->trajet->getById();

        if ($result) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "data" => $result
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Trajet non trouvé"
            ]);
        }
    }

    /**
     * Récupérer un trajet par nom de ligne
     * GET /trajets/ligne/{nom}
     */
    public function getByNom($nom) {
        $this->trajet->nom = urldecode($nom);
        $result = $this->trajet->getByNom();

        if ($result) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "data" => $result
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Trajet non trouvé"
            ]);
        }
    }

    /**
     * Vérifier si un trajet existe
     * GET /trajets/{id}/exists
     */
    public function exists($id) {
        $this->trajet->id = $id;
        $exists = $this->trajet->exists();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "exists" => $exists
        ]);
    }
}
