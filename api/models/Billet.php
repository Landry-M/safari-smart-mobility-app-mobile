<?php
/**
 * Modèle Billet
 * Gère les opérations CRUD sur la table billets
 */
class Billet {
    private $conn;
    private $table_name = "billets";

    // Propriétés
    public $id;
    public $numero_billet;
    public $qr_code;
    public $trajet_id;
    public $tarif_id;
    public $shift_id;
    public $bus_id;
    public $client_id;
    public $arret_depart;
    public $arret_arrivee;
    public $date_voyage;
    public $heure_depart;
    public $siege_numero;
    public $prix_paye;
    public $devise;
    public $statut_billet;
    public $mode_paiement;
    public $reference_paiement;
    public $vendu_par;
    public $point_vente;
    public $date_achat;
    public $date_utilisation;
    public $date_annulation;
    public $motif_annulation;
    public $date_creation;

    /**
     * Constructeur
     */
    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Créer un nouveau billet
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . " 
                  (numero_billet, qr_code, trajet_id, tarif_id, shift_id, bus_id, client_id, 
                   arret_depart, arret_arrivee, date_voyage, heure_depart, siege_numero, 
                   prix_paye, devise, statut_billet, mode_paiement, reference_paiement, 
                   vendu_par, point_vente, date_achat) 
                  VALUES 
                  (:numero_billet, :qr_code, :trajet_id, :tarif_id, :shift_id, :bus_id, :client_id, 
                   :arret_depart, :arret_arrivee, :date_voyage, :heure_depart, :siege_numero, 
                   :prix_paye, :devise, :statut_billet, :mode_paiement, :reference_paiement, 
                   :vendu_par, :point_vente, NOW())";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->numero_billet = htmlspecialchars(strip_tags($this->numero_billet));
        $this->qr_code = htmlspecialchars(strip_tags($this->qr_code));
        $this->arret_depart = htmlspecialchars(strip_tags($this->arret_depart));
        $this->arret_arrivee = htmlspecialchars(strip_tags($this->arret_arrivee));

        // Bind values avec conversion de types si nécessaire
        $stmt->bindParam(":numero_billet", $this->numero_billet);
        $stmt->bindParam(":qr_code", $this->qr_code);
        $stmt->bindParam(":trajet_id", $this->trajet_id, PDO::PARAM_INT);
        $stmt->bindParam(":tarif_id", $this->tarif_id, PDO::PARAM_INT);
        $stmt->bindParam(":shift_id", $this->shift_id, PDO::PARAM_INT);
        
        // Convertir bus_id en INT si c'est une string numérique
        $bus_id_int = null;
        if ($this->bus_id !== null) {
            $bus_id_int = is_numeric($this->bus_id) ? (int)$this->bus_id : null;
        }
        $stmt->bindParam(":bus_id", $bus_id_int, PDO::PARAM_INT);
        
        $stmt->bindParam(":client_id", $this->client_id, PDO::PARAM_INT);
        $stmt->bindParam(":arret_depart", $this->arret_depart);
        $stmt->bindParam(":arret_arrivee", $this->arret_arrivee);
        $stmt->bindParam(":date_voyage", $this->date_voyage);
        $stmt->bindParam(":heure_depart", $this->heure_depart);
        $stmt->bindParam(":siege_numero", $this->siege_numero);
        $stmt->bindParam(":prix_paye", $this->prix_paye);
        $stmt->bindParam(":devise", $this->devise);
        $stmt->bindParam(":statut_billet", $this->statut_billet);
        $stmt->bindParam(":mode_paiement", $this->mode_paiement);
        $stmt->bindParam(":reference_paiement", $this->reference_paiement);
        $stmt->bindParam(":vendu_par", $this->vendu_par);
        $stmt->bindParam(":point_vente", $this->point_vente);

        if ($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }

        return false;
    }

    /**
     * Récupérer tous les billets
     */
    public function getAll() {
        $query = "SELECT * FROM " . $this->table_name . " ORDER BY date_creation DESC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un billet par ID
     */
    public function getById() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un billet par numéro
     */
    public function getByNumero() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE numero_billet = :numero_billet LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":numero_billet", $this->numero_billet);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer les billets par client_id
     */
    public function getByClientId() {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE client_id = :client_id 
                  ORDER BY date_creation DESC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":client_id", $this->client_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Mettre à jour le statut d'un billet
     */
    public function updateStatut() {
        $query = "UPDATE " . $this->table_name . " 
                  SET statut_billet = :statut_billet 
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);

        $this->statut_billet = htmlspecialchars(strip_tags($this->statut_billet));

        $stmt->bindParam(":statut_billet", $this->statut_billet);
        $stmt->bindParam(":id", $this->id);

        return $stmt->execute();
    }

    /**
     * Mettre à jour le numéro de siège
     */
    public function updateSiege() {
        $query = "UPDATE " . $this->table_name . " 
                  SET siege_numero = :siege_numero 
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);

        $this->siege_numero = htmlspecialchars(strip_tags($this->siege_numero));

        $stmt->bindParam(":siege_numero", $this->siege_numero);
        $stmt->bindParam(":id", $this->id);

        return $stmt->execute();
    }

    /**
     * Vérifier si un billet existe
     */
    public function exists() {
        $query = "SELECT id FROM " . $this->table_name . " 
                  WHERE numero_billet = :numero_billet LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":numero_billet", $this->numero_billet);
        $stmt->execute();

        return $stmt->rowCount() > 0;
    }
}
