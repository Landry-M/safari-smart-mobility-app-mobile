<?php
/**
 * Modèle Bus
 * Gère les opérations de lecture sur la table bus
 */
class Bus {
    private $conn;
    private $table_name = "bus";

    // Propriétés
    public $id;
    public $numero;
    public $immatriculation;
    public $marque;
    public $modele;
    public $annee;
    public $capacite;
    public $kilometrage;
    public $ligne_affectee;
    public $statut;
    public $modules;
    public $notes;
    public $derniere_activite;
    public $latitude;
    public $longitude;
    public $date_creation;

    /**
     * Constructeur
     */
    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Récupérer tous les bus actifs
     */
    public function getAll() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE statut = 'actif' ORDER BY numero ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer tous les bus actifs avec coordonnées GPS
     */
    public function getAllWithCoordinates() {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE statut = 'actif' 
                  AND latitude IS NOT NULL 
                  AND longitude IS NOT NULL 
                  ORDER BY numero ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer les bus par ligne affectée
     */
    public function getByLigneAffectee($ligne_id) {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE ligne_affectee = :ligne_id 
                  AND statut = 'actif' 
                  ORDER BY numero ASC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":ligne_id", $ligne_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un bus par son ID
     */
    public function getById() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un bus par numéro
     */
    public function getByNumero() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE numero = :numero LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":numero", $this->numero);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Vérifier si un bus existe
     */
    public function exists() {
        $query = "SELECT id FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->rowCount() > 0;
    }
}
