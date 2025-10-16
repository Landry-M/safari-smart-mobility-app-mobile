<?php
/**
 * Modèle Trajet
 * Gère les opérations de lecture sur la table trajets
 */
class Trajet {
    private $conn;
    private $table_name = "trajets";

    // Propriétés
    public $id;
    public $code;
    public $nom;
    public $distance_totale;
    public $duree_estimee;
    public $statut;
    public $latitude_deprte;
    public $longitude_depart;
    public $latitude_arrivee;
    public $longitude_arrivee;
    public $date_creation;

    /**
     * Constructeur
     */
    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Récupérer tous les trajets actifs
     */
    public function getAll() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE statut = 'actif' ORDER BY nom ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer tous les trajets (actifs et inactifs)
     */
    public function getAllWithInactive() {
        $query = "SELECT * FROM " . $this->table_name . " ORDER BY nom ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un trajet par son ID
     */
    public function getById() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un trajet par nom
     */
    public function getByNom() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE nom = :nom LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":nom", $this->nom);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer les noms de lignes (pour dropdown)
     */
    public function getLignesNames() {
        $query = "SELECT id, nom, code, distance_totale, duree_estimee 
                  FROM " . $this->table_name . " 
                  WHERE statut = 'actif' 
                  ORDER BY nom ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Vérifier si un trajet existe
     */
    public function exists() {
        $query = "SELECT id FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->rowCount() > 0;
    }
}
