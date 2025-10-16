<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/Client.php';

/**
 * Contrôleur Client
 * Gère les requêtes HTTP pour les clients
 */
class ClientController {
    private $db;
    private $client;

    /**
     * Constructeur
     */
    public function __construct($db = null) {
        if ($db) {
            $this->db = $db;
        } else {
            $database = new Database();
            $this->db = $database->getConnection();
        }
        $this->client = new Client($this->db);
    }

    /**
     * Créer un nouveau client
     * POST /clients
     */
    public function create() {
        // Récupérer les données JSON
        $data = json_decode(file_get_contents("php://input"));

        // Valider les données requises
        if (empty($data->uid) || empty($data->telephone)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Les champs 'uid' et 'telephone' sont obligatoires"
            ]);
            return;
        }

        // Assigner les valeurs
        $this->client->uid = $data->uid;
        $this->client->nom = isset($data->nom) ? $data->nom : null;
        $this->client->prenom = isset($data->prenom) ? $data->prenom : null;
        $this->client->telephone = $data->telephone;
        $this->client->email = isset($data->email) ? $data->email : null;

        // Créer le client
        if ($this->client->create()) {
            http_response_code(201);
            echo json_encode([
                "success" => true,
                "message" => "Client créé avec succès",
                "data" => [
                    "id" => $this->client->id,
                    "uid" => $this->client->uid,
                    "nom" => $this->client->nom,
                    "prenom" => $this->client->prenom,
                    "telephone" => $this->client->telephone,
                    "email" => $this->client->email
                ]
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Impossible de créer le client"
            ]);
        }
    }

    /**
     * Récupérer un client par son ID auto-incrémenté
     * GET /clients/{id}
     */
    public function getById($id) {
        $this->client->id = $id;
        $result = $this->client->getById();

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
                "message" => "Client non trouvé"
            ]);
        }
    }

    /**
     * Récupérer un client par son UID Firebase
     * GET /clients/uid/{uid}
     */
    public function getByUid($uid) {
        $this->client->uid = $uid;
        $result = $this->client->getByUid();

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
                "message" => "Client non trouvé"
            ]);
        }
    }

    /**
     * Récupérer un client par son téléphone
     * GET /clients/phone/{phone}
     */
    public function getByPhone($phone) {
        $this->client->telephone = $phone;
        $result = $this->client->getByPhone();

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
                "message" => "Client non trouvé"
            ]);
        }
    }

    /**
     * Récupérer tous les clients
     * GET /clients
     */
    public function getAll() {
        $results = $this->client->getAll();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($results),
            "data" => $results
        ]);
    }

    /**
     * Mettre à jour un client
     * PUT /clients/{id}
     */
    public function update($id) {
        // Récupérer les données JSON
        $data = json_decode(file_get_contents("php://input"));

        // Vérifier si le client existe
        $this->client->id = $id;
        if (!$this->client->exists()) {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Client non trouvé"
            ]);
            return;
        }

        // Assigner les valeurs
        $this->client->nom = isset($data->nom) ? $data->nom : null;
        $this->client->prenom = isset($data->prenom) ? $data->prenom : null;
        $this->client->telephone = isset($data->telephone) ? $data->telephone : null;
        $this->client->email = isset($data->email) ? $data->email : null;

        // Mettre à jour le client
        if ($this->client->update()) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Client mis à jour avec succès"
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Impossible de mettre à jour le client"
            ]);
        }
    }

    /**
     * Supprimer un client
     * DELETE /clients/{id}
     */
    public function delete($id) {
        $this->client->id = $id;

        // Vérifier si le client existe
        if (!$this->client->exists()) {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Client non trouvé"
            ]);
            return;
        }

        // Supprimer le client
        if ($this->client->delete()) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Client supprimé avec succès"
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Impossible de supprimer le client"
            ]);
        }
    }

    /**
     * Vérifier si un client existe par ID
     * GET /clients/{id}/exists
     */
    public function exists($id) {
        $this->client->id = $id;
        $exists = $this->client->exists();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "exists" => $exists
        ]);
    }

    /**
     * Vérifier si un client existe par UID Firebase
     * GET /clients/uid/{uid}/exists
     */
    public function existsByUid($uid) {
        $this->client->uid = $uid;
        $exists = $this->client->existsByUid();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "exists" => $exists
        ]);
    }
}
