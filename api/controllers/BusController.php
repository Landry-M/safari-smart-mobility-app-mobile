<?php
/**
 * Contrôleur Bus
 * Gère les requêtes HTTP pour les bus
 */

require_once __DIR__ . '/../models/Bus.php';

class BusController {
    private $bus;

    public function __construct($db) {
        $this->bus = new Bus($db);
    }

    /**
     * Récupérer tous les bus actifs
     * GET /bus
     */
    public function getAll() {
        $result = $this->bus->getAll();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Récupérer tous les bus actifs avec coordonnées GPS
     * GET /bus/nearby
     */
    public function getAllWithCoordinates() {
        $result = $this->bus->getAllWithCoordinates();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Récupérer les bus par ligne affectée
     * GET /bus/ligne/{ligne_id}
     */
    public function getByLigneAffectee($ligne_id) {
        $result = $this->bus->getByLigneAffectee($ligne_id);

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Récupérer un bus par son ID
     * GET /bus/{id}
     */
    public function getById($id) {
        $this->bus->id = $id;
        $result = $this->bus->getById();

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
                "message" => "Bus non trouvé"
            ]);
        }
    }

    /**
     * Récupérer un bus par numéro
     * GET /bus/numero/{numero}
     */
    public function getByNumero($numero) {
        $this->bus->numero = $numero;
        $result = $this->bus->getByNumero();

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
                "message" => "Bus non trouvé"
            ]);
        }
    }

    /**
     * Vérifier si un bus existe
     * GET /bus/{id}/exists
     */
    public function exists($id) {
        $this->bus->id = $id;
        $exists = $this->bus->exists();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "exists" => $exists
        ]);
    }
}
