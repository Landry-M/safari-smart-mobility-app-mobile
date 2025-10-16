# Identifiants de Test - Authentification Chauffeur

## 🚗 Système d'authentification persistante

L'application dispose maintenant d'un système d'authentification chauffeur **persistant** qui maintient la session même après redémarrage de l'application.

## 🔑 Identifiants de Test

### Étape 1 : Chauffeur
- **Matricule** : `CH001`
- **Mot de passe** : `123456`

### Étape 2 : Receveur
- **Matricule** : `RC001`
- **Mot de passe** : `654321`

### Étape 3 : Collecteur
- **Matricule** : `CL001`
- **Mot de passe** : `111111`

## 📱 Flux d'authentification

1. **Connexion** : Depuis l'écran de login → Cliquer sur "Connexion chauffeur"
2. **Validation 3 étapes** : Entrer les identifiants du chauffeur, receveur, puis collecteur
3. **Session sauvegardée** : Les informations sont stockées localement avec SharedPreferences
4. **Persistance** : Au redémarrage de l'app, l'utilisateur est automatiquement redirigé vers l'espace chauffeur
5. **Déconnexion** : Bouton de déconnexion dans la barre d'app qui supprime la session

## 🔒 Fonctionnalités de sécurité

- ✅ Session persistante stockée localement
- ✅ Vérification automatique au démarrage de l'app
- ✅ Redirection sécurisée vers login si session invalide
- ✅ Déconnexion volontaire pour toute l'équipe
- ✅ Protection contre les accès non autorisés

## 📂 Fichiers modifiés

### Créés
- `lib/core/services/driver_session_service.dart` - Service de gestion de session
- `lib/screens/driver/auth_driver_screen.dart` - Écran d'authentification en 3 étapes
- `lib/screens/driver/home_driver_screen.dart` - Interface chauffeur

### Modifiés
- `lib/screens/auth/login_screen.dart` - Ajout du bouton "Connexion chauffeur"
- `lib/screens/splash/splash_screen.dart` - Vérification de session chauffeur au démarrage
- `lib/main.dart` - Routes ajoutées pour `/driver-auth` et `/driver-home`

## 💡 Notes techniques

La session est stockée avec les informations suivantes :
- Matricule du chauffeur
- Matricule du receveur
- Matricule du collecteur
- Numéro du bus (BUS-225 par défaut)
- Route (Abobo - Plateau par défaut)
- Timestamp de connexion

La déconnexion supprime toutes ces données et redirige vers l'écran de login principal.
