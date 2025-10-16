<?php
/**
 * Configuration de la connexion à la base de données
 */
class Database {
    private $host = "localhost";
    private $db_name = "ngla4195_safari";
    private $username = "ngla4195_ngla4195"; // Modifier selon votre configuration
    private $password = "vlE+(*efYDZj"; // Modifier selon votre configuration
    private $charset = "utf8mb4";
    public $conn;

    /**
     * Obtenir la connexion à la base de données
     */
    public function getConnection() {
        $this->conn = null;

        try {
            $dsn = "mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=" . $this->charset;
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ];
            
            $this->conn = new PDO($dsn, $this->username, $this->password, $options);
        } catch(PDOException $exception) {
            error_log("Erreur de connexion: " . $exception->getMessage());
            throw new Exception("Erreur de connexion à la base de données");
        }

        return $this->conn;
    }
}
