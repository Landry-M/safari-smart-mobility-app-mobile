<?php
/**
 * Modèle EquipeBord
 * Gestion de l'équipe de bord (chauffeurs, receveurs, contrôleurs)
 * Safari Smart Mobility API v2.0
 */

class EquipeBord {
    private $conn;
    private $table_name = "equipe_bord";

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Authentifier un membre de l'équipe avec matricule et PIN
     * @param string $matricule
     * @param string $pin
     * @param string $poste (optionnel: 'chauffeur', 'receveur', 'controleur')
     * @return array|false Retourne les données du membre ou false si échec
     */
    public function authenticate($matricule, $pin, $poste = null) {
        try {
            $query = "SELECT id, nom, matricule, poste, telephone, email, bus_affecte, statut 
                      FROM " . $this->table_name . " 
                      WHERE matricule = :matricule 
                      AND pin = :pin 
                      AND statut = 'actif'";
            
            // Ajouter le filtre de poste si spécifié
            if ($poste !== null) {
                $query .= " AND poste = :poste";
            }
            
            $query .= " LIMIT 1";

            $stmt = $this->conn->prepare($query);
            
            // Bind des paramètres
            $stmt->bindParam(':matricule', $matricule);
            $stmt->bindParam(':pin', $pin);
            if ($poste !== null) {
                $stmt->bindParam(':poste', $poste);
            }

            $stmt->execute();
            
            if ($stmt->rowCount() > 0) {
                return $stmt->fetch(PDO::FETCH_ASSOC);
            }
            
            return false;
        } catch (PDOException $e) {
            error_log("Erreur authentification équipe: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Récupérer un membre par matricule
     * @param string $matricule
     * @return array|false
     */
    public function getByMatricule($matricule) {
        try {
            $query = "SELECT id, nom, matricule, poste, telephone, email, adresse, 
                      date_naissance, bus_affecte, statut, date_embauche, type_contrat, 
                      salaire, notes, date_creation 
                      FROM " . $this->table_name . " 
                      WHERE matricule = :matricule 
                      LIMIT 1";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':matricule', $matricule);
            $stmt->execute();
            
            if ($stmt->rowCount() > 0) {
                return $stmt->fetch(PDO::FETCH_ASSOC);
            }
            
            return false;
        } catch (PDOException $e) {
            error_log("Erreur récupération membre: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Récupérer tous les membres par poste
     * @param string $poste
     * @return array
     */
    public function getByPoste($poste) {
        try {
            $query = "SELECT id, nom, matricule, poste, telephone, email, bus_affecte, 
                      statut, date_embauche 
                      FROM " . $this->table_name . " 
                      WHERE poste = :poste 
                      ORDER BY nom ASC";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':poste', $poste);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur récupération par poste: " . $e->getMessage());
            return [];
        }
    }

    /**
     * Vérifier si un matricule existe
     * @param string $matricule
     * @return bool
     */
    public function exists($matricule) {
        try {
            $query = "SELECT id FROM " . $this->table_name . " 
                      WHERE matricule = :matricule LIMIT 1";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':matricule', $matricule);
            $stmt->execute();
            
            return $stmt->rowCount() > 0;
        } catch (PDOException $e) {
            error_log("Erreur vérification existence: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Mettre à jour le PIN d'un membre
     * @param string $matricule
     * @param string $newPin
     * @return bool
     */
    public function updatePin($matricule, $newPin) {
        try {
            $query = "UPDATE " . $this->table_name . " 
                      SET pin = :pin 
                      WHERE matricule = :matricule";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':pin', $newPin);
            $stmt->bindParam(':matricule', $matricule);
            
            return $stmt->execute();
        } catch (PDOException $e) {
            error_log("Erreur mise à jour PIN: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Récupérer tous les membres actifs
     * @return array
     */
    public function getAllActifs() {
        try {
            $query = "SELECT id, nom, matricule, poste, telephone, email, bus_affecte, 
                      statut, date_embauche 
                      FROM " . $this->table_name . " 
                      WHERE statut = 'actif' 
                      AND poste IN ('chauffeur', 'receveur', 'controleur')
                      ORDER BY poste, nom ASC";

            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur récupération membres actifs: " . $e->getMessage());
            return [];
        }
    }
}
