<?php
/**
 * Modèle Client
 * Gère les opérations CRUD sur la table clients
 */
class Client {
    private $conn;
    private $table_name = "clients";

    // Propriétés
    public $id;
    public $uid;
    public $nom;
    public $prenom;
    public $telephone;
    public $email;
    public $date_creation;

    /**
     * Constructeur
     */
    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Créer un nouveau client
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . " 
                  SET uid = :uid,
                      nom = :nom,
                      prenom = :prenom,
                      telephone = :telephone,
                      email = :email";

        $stmt = $this->conn->prepare($query);

        // Nettoyer les données
        $this->uid = htmlspecialchars(strip_tags($this->uid));
        $this->nom = htmlspecialchars(strip_tags($this->nom));
        $this->prenom = htmlspecialchars(strip_tags($this->prenom));
        $this->telephone = htmlspecialchars(strip_tags($this->telephone));
        $this->email = htmlspecialchars(strip_tags($this->email));

        // Lier les valeurs
        $stmt->bindParam(":uid", $this->uid);
        $stmt->bindParam(":nom", $this->nom);
        $stmt->bindParam(":prenom", $this->prenom);
        $stmt->bindParam(":telephone", $this->telephone);
        $stmt->bindParam(":email", $this->email);

        try {
            if ($stmt->execute()) {
                // Récupérer l'ID auto-incrémenté
                $this->id = $this->conn->lastInsertId();
                return true;
            }
            return false;
        } catch (PDOException $e) {
            // Si l'UID existe déjà, mettre à jour
            if ($e->getCode() == 23000) {
                return $this->updateByUid();
            }
            error_log("Erreur création client: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Mettre à jour un client existant par ID
     */
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET nom = :nom,
                      prenom = :prenom,
                      telephone = :telephone,
                      email = :email
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);

        // Nettoyer les données
        $this->id = htmlspecialchars(strip_tags($this->id));
        $this->nom = htmlspecialchars(strip_tags($this->nom));
        $this->prenom = htmlspecialchars(strip_tags($this->prenom));
        $this->telephone = htmlspecialchars(strip_tags($this->telephone));
        $this->email = htmlspecialchars(strip_tags($this->email));

        // Lier les valeurs
        $stmt->bindParam(":id", $this->id);
        $stmt->bindParam(":nom", $this->nom);
        $stmt->bindParam(":prenom", $this->prenom);
        $stmt->bindParam(":telephone", $this->telephone);
        $stmt->bindParam(":email", $this->email);

        try {
            if ($stmt->execute()) {
                return true;
            }
            return false;
        } catch (PDOException $e) {
            error_log("Erreur mise à jour client: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Mettre à jour un client existant par UID Firebase
     */
    public function updateByUid() {
        $query = "UPDATE " . $this->table_name . "
                  SET nom = :nom,
                      prenom = :prenom,
                      telephone = :telephone,
                      email = :email
                  WHERE uid = :uid";

        $stmt = $this->conn->prepare($query);

        // Nettoyer les données
        $this->uid = htmlspecialchars(strip_tags($this->uid));
        $this->nom = htmlspecialchars(strip_tags($this->nom));
        $this->prenom = htmlspecialchars(strip_tags($this->prenom));
        $this->telephone = htmlspecialchars(strip_tags($this->telephone));
        $this->email = htmlspecialchars(strip_tags($this->email));

        // Lier les valeurs
        $stmt->bindParam(":uid", $this->uid);
        $stmt->bindParam(":nom", $this->nom);
        $stmt->bindParam(":prenom", $this->prenom);
        $stmt->bindParam(":telephone", $this->telephone);
        $stmt->bindParam(":email", $this->email);

        try {
            if ($stmt->execute()) {
                return true;
            }
            return false;
        } catch (PDOException $e) {
            error_log("Erreur mise à jour client par UID: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Récupérer un client par son ID auto-incrémenté
     */
    public function getById() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un client par son UID Firebase
     */
    public function getByUid() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE uid = :uid LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":uid", $this->uid);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer un client par son téléphone
     */
    public function getByPhone() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE telephone = :telephone LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":telephone", $this->telephone);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Récupérer tous les clients
     */
    public function getAll() {
        $query = "SELECT * FROM " . $this->table_name . " ORDER BY date_creation DESC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Supprimer un client
     */
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
        
        $stmt = $this->conn->prepare($query);
        $this->id = htmlspecialchars(strip_tags($this->id));
        $stmt->bindParam(":id", $this->id);

        try {
            if ($stmt->execute()) {
                return true;
            }
            return false;
        } catch (PDOException $e) {
            error_log("Erreur suppression client: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Vérifier si un client existe par ID
     */
    public function exists() {
        $query = "SELECT id FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();

        return $stmt->rowCount() > 0;
    }

    /**
     * Vérifier si un client existe par UID Firebase
     */
    public function existsByUid() {
        $query = "SELECT id FROM " . $this->table_name . " WHERE uid = :uid LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":uid", $this->uid);
        $stmt->execute();

        return $stmt->rowCount() > 0;
    }
}
