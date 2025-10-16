<?php
/**
 * Contrôleur pour les billets
 */
class BilletController {
    private $db;
    private $billet;

    public function __construct($db) {
        $this->db = $db;
        require_once __DIR__ . '/../models/Billet.php';
        $this->billet = new Billet($db);
    }

    /**
     * Créer un nouveau billet
     * POST /billets
     */
    public function create() {
        // Get posted data
        $data = json_decode(file_get_contents("php://input"));

        // Validation des champs requis
        if (empty($data->numero_billet) || 
            empty($data->arret_depart) || 
            empty($data->arret_arrivee) || 
            empty($data->date_voyage) || 
            empty($data->prix_paye)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Données incomplètes. Champs requis: numero_billet, arret_depart, arret_arrivee, date_voyage, prix_paye"
            ]);
            return;
        }

        // Set billet properties
        $this->billet->numero_billet = $data->numero_billet;
        $this->billet->qr_code = $data->qr_code ?? null;
        $this->billet->trajet_id = $data->trajet_id ?? 7; // Default: KAPELA - CLINIC NGALIEMA (ID=7)
        $this->billet->tarif_id = $data->tarif_id ?? 1; // Default tarif_id
        $this->billet->shift_id = $data->shift_id ?? null;
        $this->billet->bus_id = $data->bus_id ?? null;
        $this->billet->client_id = $data->client_id ?? null;
        $this->billet->arret_depart = $data->arret_depart;
        $this->billet->arret_arrivee = $data->arret_arrivee;
        $this->billet->date_voyage = $data->date_voyage;
        $this->billet->heure_depart = $data->heure_depart ?? null;
        $this->billet->siege_numero = $data->siege_numero ?? null;
        $this->billet->prix_paye = $data->prix_paye;
        $this->billet->devise = $data->devise ?? 'CDF';
        $this->billet->statut_billet = $data->statut_billet ?? 'paye';
        $this->billet->mode_paiement = $data->mode_paiement ?? 'autre';
        $this->billet->reference_paiement = $data->reference_paiement ?? null;
        $this->billet->vendu_par = $data->vendu_par ?? null;
        $this->billet->point_vente = $data->point_vente ?? 'Application mobile';

        // Create billet
        if ($this->billet->create()) {
            http_response_code(201);
            echo json_encode([
                "success" => true,
                "message" => "Billet créé avec succès",
                "data" => [
                    "id" => $this->billet->id,
                    "numero_billet" => $this->billet->numero_billet,
                    "qr_code" => $this->billet->qr_code,
                    "statut_billet" => $this->billet->statut_billet
                ]
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Impossible de créer le billet"
            ]);
        }
    }

    /**
     * Récupérer tous les billets
     * GET /billets
     */
    public function getAll() {
        $result = $this->billet->getAll();
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Récupérer un billet par ID
     * GET /billets/{id}
     */
    public function getById($id) {
        $this->billet->id = $id;
        $result = $this->billet->getById();

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
                "message" => "Billet non trouvé"
            ]);
        }
    }

    /**
     * Récupérer un billet par numéro
     * GET /billets/numero/{numero}
     */
    public function getByNumero($numero) {
        $this->billet->numero_billet = $numero;
        $result = $this->billet->getByNumero();

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
                "message" => "Billet non trouvé"
            ]);
        }
    }

    /**
     * Récupérer les billets par client_id
     * GET /billets/client/{client_id}
     */
    public function getByClientId($clientId) {
        $this->billet->client_id = $clientId;
        $result = $this->billet->getByClientId();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "count" => count($result),
            "data" => $result
        ]);
    }

    /**
     * Mettre à jour le statut d'un billet
     * PUT /billets/{id}/statut
     */
    public function updateStatut($id) {
        $data = json_decode(file_get_contents("php://input"));

        if (empty($data->statut_billet)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Le statut est requis"
            ]);
            return;
        }

        $this->billet->id = $id;
        $this->billet->statut_billet = $data->statut_billet;

        if ($this->billet->updateStatut()) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Statut mis à jour avec succès"
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Impossible de mettre à jour le statut"
            ]);
        }
    }

    /**
     * Mettre à jour le numéro de siège
     * PUT /billets/{id}/siege
     */
    public function updateSiege($id) {
        $data = json_decode(file_get_contents("php://input"));

        if (empty($data->siege_numero)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Le numéro de siège est requis"
            ]);
            return;
        }

        $this->billet->id = $id;
        $this->billet->siege_numero = $data->siege_numero;

        if ($this->billet->updateSiege()) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Numéro de siège mis à jour avec succès"
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Impossible de mettre à jour le numéro de siège"
            ]);
        }
    }

    /**
     * Vérifier si un billet existe
     * GET /billets/{numero}/exists
     */
    public function exists($numero) {
        $this->billet->numero_billet = $numero;
        $exists = $this->billet->exists();

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "exists" => $exists
        ]);
    }
}
