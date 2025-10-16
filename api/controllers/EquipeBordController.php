<?php
/**
 * Contrôleur EquipeBord
 * Gestion des authentifications et opérations sur l'équipe de bord
 * Safari Smart Mobility API v2.0
 */

require_once __DIR__ . '/../models/EquipeBord.php';

class EquipeBordController {
    private $db;
    private $equipeBord;

    public function __construct($db = null) {
        $this->db = $db;
        if ($this->db) {
            $this->equipeBord = new EquipeBord($this->db);
        }
    }

    /**
     * Authentifier un membre de l'équipe
     * POST /equipe-bord/auth
     * Body: { "matricule": "EMP-2025-001", "pin": "123456", "poste": "chauffeur" }
     */
    public function authenticate() {
        try {
            // Récupérer les données JSON
            $data = json_decode(file_get_contents("php://input"), true);
            
            // Validation des données
            if (empty($data['matricule']) || empty($data['pin'])) {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Matricule et PIN requis'
                ]);
                return;
            }

            $matricule = $this->sanitize($data['matricule']);
            $pin = $this->sanitize($data['pin']);
            $poste = isset($data['poste']) ? $this->sanitize($data['poste']) : null;

            // Validation du poste si fourni
            $postesValides = ['chauffeur', 'receveur', 'controleur'];
            if ($poste !== null && !in_array($poste, $postesValides)) {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Poste invalide. Doit être: chauffeur, receveur ou controleur'
                ]);
                return;
            }

            // Authentification
            $membre = $this->equipeBord->authenticate($matricule, $pin, $poste);

            if ($membre) {
                http_response_code(200);
                echo json_encode([
                    'success' => true,
                    'message' => 'Authentification réussie',
                    'data' => $membre
                ]);
            } else {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'Identifiants incorrects ou compte inactif'
                ]);
            }

        } catch (Exception $e) {
            error_log("Erreur authenticate: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erreur serveur lors de l\'authentification'
            ]);
        }
    }

    /**
     * Récupérer un membre par matricule
     * GET /equipe-bord/matricule/{matricule}
     */
    public function getByMatricule($matricule) {
        try {
            $matricule = $this->sanitize($matricule);
            
            $membre = $this->equipeBord->getByMatricule($matricule);
            
            if ($membre) {
                // Ne pas retourner le PIN
                unset($membre['pin']);
                
                http_response_code(200);
                echo json_encode([
                    'success' => true,
                    'data' => $membre
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Membre non trouvé'
                ]);
            }

        } catch (Exception $e) {
            error_log("Erreur getByMatricule: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erreur serveur'
            ]);
        }
    }

    /**
     * Récupérer tous les membres par poste
     * GET /equipe-bord/poste/{poste}
     */
    public function getByPoste($poste) {
        try {
            $poste = $this->sanitize($poste);
            
            $postesValides = ['chauffeur', 'receveur', 'controleur'];
            if (!in_array($poste, $postesValides)) {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Poste invalide'
                ]);
                return;
            }
            
            $membres = $this->equipeBord->getByPoste($poste);
            
            http_response_code(200);
            echo json_encode([
                'success' => true,
                'count' => count($membres),
                'data' => $membres
            ]);

        } catch (Exception $e) {
            error_log("Erreur getByPoste: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erreur serveur'
            ]);
        }
    }

    /**
     * Récupérer tous les membres actifs
     * GET /equipe-bord/actifs
     */
    public function getAllActifs() {
        try {
            $membres = $this->equipeBord->getAllActifs();
            
            http_response_code(200);
            echo json_encode([
                'success' => true,
                'count' => count($membres),
                'data' => $membres
            ]);

        } catch (Exception $e) {
            error_log("Erreur getAllActifs: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erreur serveur'
            ]);
        }
    }

    /**
     * Vérifier si un matricule existe
     * GET /equipe-bord/matricule/{matricule}/exists
     */
    public function exists($matricule) {
        try {
            $matricule = $this->sanitize($matricule);
            
            $exists = $this->equipeBord->exists($matricule);
            
            http_response_code(200);
            echo json_encode([
                'success' => true,
                'exists' => $exists
            ]);

        } catch (Exception $e) {
            error_log("Erreur exists: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erreur serveur'
            ]);
        }
    }

    /**
     * Mettre à jour le PIN
     * PUT /equipe-bord/matricule/{matricule}/pin
     * Body: { "newPin": "654321" }
     */
    public function updatePin($matricule) {
        try {
            $data = json_decode(file_get_contents("php://input"), true);
            
            if (empty($data['newPin'])) {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Nouveau PIN requis'
                ]);
                return;
            }

            $matricule = $this->sanitize($matricule);
            $newPin = $this->sanitize($data['newPin']);

            // Validation du PIN (6 chiffres)
            if (!preg_match('/^\d{6}$/', $newPin)) {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Le PIN doit contenir exactement 6 chiffres'
                ]);
                return;
            }

            $updated = $this->equipeBord->updatePin($matricule, $newPin);
            
            if ($updated) {
                http_response_code(200);
                echo json_encode([
                    'success' => true,
                    'message' => 'PIN mis à jour avec succès'
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Membre non trouvé ou erreur de mise à jour'
                ]);
            }

        } catch (Exception $e) {
            error_log("Erreur updatePin: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erreur serveur'
            ]);
        }
    }

    /**
     * Sanitiser une chaîne
     * @param string $data
     * @return string
     */
    private function sanitize($data) {
        $data = trim($data);
        $data = stripslashes($data);
        $data = htmlspecialchars($data);
        return $data;
    }
}
