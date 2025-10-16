<?php
require_once __DIR__ . '/../controllers/ClientController.php';
require_once __DIR__ . '/../controllers/TrajetController.php';
require_once __DIR__ . '/../controllers/BusController.php';

/**
 * Routeur API
 * Gère le routage des requêtes HTTP
 */
class Router {
    private $clientController;
    private $trajetController;
    private $busController;
    private $db;

    public function __construct($db = null) {
        $this->db = $db;
        if ($db) {
            $this->clientController = new ClientController($db);
            $this->trajetController = new TrajetController($db);
            $this->busController = new BusController($db);
        }
    }

    /**
     * Router la requête vers la méthode appropriée
     */
    public function route($method, $uri) {
        // Nettoyer l'URI
        $uri = trim($uri, '/');
        $segments = explode('/', $uri);

        // Routes pour /bus
        if ($segments[0] === 'bus') {
            $this->routeBus($method, $segments);
        }
        // Routes pour /trajets
        elseif ($segments[0] === 'trajets') {
            $this->routeTrajets($method, $segments);
        }
        // Routes pour /clients
        elseif ($segments[0] === 'clients') {
            switch ($method) {
                case 'GET':
                    if (isset($segments[1])) {
                        if ($segments[1] === 'uid' && isset($segments[2])) {
                            // Routes pour /api/clients/uid/{uid}
                            if (isset($segments[3]) && $segments[3] === 'exists') {
                                // GET /api/clients/uid/{uid}/exists
                                $this->clientController->existsByUid($segments[2]);
                            } else {
                                // GET /api/clients/uid/{uid}
                                $this->clientController->getByUid($segments[2]);
                            }
                        } elseif ($segments[1] === 'phone' && isset($segments[2])) {
                            // GET /api/clients/phone/{phone}
                            $this->clientController->getByPhone(urldecode($segments[2]));
                        } elseif (isset($segments[2]) && $segments[2] === 'exists') {
                            // GET /api/clients/{id}/exists
                            $this->clientController->exists($segments[1]);
                        } else {
                            // GET /api/clients/{id}
                            $this->clientController->getById($segments[1]);
                        }
                    } else {
                        // GET /api/clients
                        $this->clientController->getAll();
                    }
                    break;

                case 'POST':
                    // POST /api/clients
                    $this->clientController->create();
                    break;

                case 'PUT':
                    if (isset($segments[1])) {
                        // PUT /api/clients/{id}
                        $this->clientController->update($segments[1]);
                    } else {
                        $this->sendError(400, "ID manquant");
                    }
                    break;

                case 'DELETE':
                    if (isset($segments[1])) {
                        // DELETE /api/clients/{id}
                        $this->clientController->delete($segments[1]);
                    } else {
                        $this->sendError(400, "ID manquant");
                    }
                    break;

                default:
                    $this->sendError(405, "Méthode non autorisée");
                    break;
            }
        } else {
            $this->sendError(404, "Route non trouvée");
        }
    }

    /**
     * Router les requêtes pour /bus
     */
    private function routeBus($method, $segments) {
        switch ($method) {
            case 'GET':
                if (isset($segments[1])) {
                    if ($segments[1] === 'nearby') {
                        // GET /bus/nearby
                        $this->busController->getAllWithCoordinates();
                    } elseif ($segments[1] === 'ligne' && isset($segments[2])) {
                        // GET /bus/ligne/{ligne_id}
                        $this->busController->getByLigneAffectee($segments[2]);
                    } elseif ($segments[1] === 'numero' && isset($segments[2])) {
                        // GET /bus/numero/{numero}
                        $this->busController->getByNumero($segments[2]);
                    } elseif (isset($segments[2]) && $segments[2] === 'exists') {
                        // GET /bus/{id}/exists
                        $this->busController->exists($segments[1]);
                    } else {
                        // GET /bus/{id}
                        $this->busController->getById($segments[1]);
                    }
                } else {
                    // GET /bus
                    $this->busController->getAll();
                }
                break;

            default:
                $this->sendError(405, "Méthode non autorisée");
                break;
        }
    }

    /**
     * Router les requêtes pour /trajets
     */
    private function routeTrajets($method, $segments) {
        switch ($method) {
            case 'GET':
                if (isset($segments[1])) {
                    if ($segments[1] === 'lignes') {
                        // GET /trajets/lignes (pour dropdown)
                        $this->trajetController->getLignesNames();
                    } elseif ($segments[1] === 'ligne' && isset($segments[2])) {
                        // GET /trajets/ligne/{nom}
                        $this->trajetController->getByNom($segments[2]);
                    } elseif (isset($segments[2]) && $segments[2] === 'exists') {
                        // GET /trajets/{id}/exists
                        $this->trajetController->exists($segments[1]);
                    } else {
                        // GET /trajets/{id}
                        $this->trajetController->getById($segments[1]);
                    }
                } else {
                    // GET /trajets
                    $this->trajetController->getAll();
                }
                break;

            default:
                $this->sendError(405, "Méthode non autorisée");
                break;
        }
    }

    /**
     * Envoyer une réponse d'erreur
     */
    private function sendError($code, $message) {
        http_response_code($code);
        echo json_encode([
            "success" => false,
            "message" => $message
        ]);
    }
}
