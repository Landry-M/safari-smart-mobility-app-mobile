# Safari Smart Mobility

Application mobile Flutter pour la gestion intelligente des transports en commun Safari.

## 📱 Description

Safari Smart Mobility est une application mobile destinée aux agents terrain (chauffeurs) et aux usagers du système de transport Safari. Elle permet :

- **Achat et rechargement** de carte prépayée
- **Validation de billets** via QR code (contrôleurs)
- **Enregistrement des encaissements** (receveurs)
- **Géolocalisation** des bus et couplage aux lignes
- **Système d'authentification gamifié** avec badges et récompenses

## 🏗️ Architecture

### Technologies utilisées
- **Framework** : Flutter (Dart)
- **State Management** : Provider
- **Base de données locale** : Isar
- **HTTP Client** : Dio
- **Cartographie** : Flutter Map
- **Scanner QR** : Mobile Scanner
- **Géolocalisation** : Geolocator
- **Notifications** : Firebase Cloud Messaging
- **Authentification** : JWT (access + refresh tokens)

### Structure du projet
```
lib/
├── core/
│   ├── constants/          # Couleurs, strings, constantes
│   ├── services/           # Services (API, DB, Location, QR)
│   └── theme/              # Thème de l'application
├── data/
│   └── models/             # Modèles de données (User, Ticket, etc.)
├── providers/              # State management avec Provider
├── screens/                # Écrans de l'application
│   ├── auth/               # Authentification
│   ├── home/               # Accueil
│   ├── profile/            # Profil utilisateur
│   ├── scanner/            # Scanner QR
│   ├── splash/             # Écran de démarrage
│   └── tickets/            # Gestion des billets
└── widgets/                # Composants réutilisables
```

## 🚀 Installation

### Prérequis
- Flutter SDK (version 3.6.1 ou supérieure)
- Dart SDK
- Android Studio / VS Code
- Émulateur Android ou appareil physique
dart run build_runner build
```

4. **Configurer Firebase** (optionnel)
- Ajouter le fichier `google-services.json` dans `android/app/`
- Ajouter le fichier `GoogleService-Info.plist` dans `ios/Runner/`

5. **Lancer l'application**
```bash
flutter run
```

## 🎯 Fonctionnalités

### Pour les Passagers
- ✅ Inscription/Connexion gamifiée
- ✅ Achat de billets (simple, aller-retour, pass)
- ✅ Rechargement de carte prépayée
- ✅ Visualisation du solde
- ✅ Historique des transactions
- 🔄 Géolocalisation des bus à proximité

### Pour les Chauffeurs
- ✅ Mise à jour de position GPS
- 🔄 Rapport de fin de service
- 🔄 Gestion des trajets

### Pour les Contrôleurs
- ✅ Scanner QR des billets
- ✅ Validation des titres de transport
- 🔄 Rapport de contrôle

### Pour les Receveurs
- 🔄 Enregistrement des encaissements
- 🔄 Rapport journalier
- 🔄 Gestion des paiements en espèces

## 🎮 Système de Gamification

L'application intègre un système de gamification pour améliorer l'expérience utilisateur :

- **Badges** : Récompenses pour différentes actions
- **Processus d'inscription interactif** : Questions adaptatives
- **Personnalisation** : Avatar, nom d'affichage
- **Préférences** : Motif de voyage, rechargement automatique

## 🔧 Configuration

### Variables d'environnement
Créer un fichier `.env` à la racine du projet :
```
API_BASE_URL=https://api.safari-mobility.com
GOOGLE_MAPS_API_KEY=AIzaSyCokbp76WRQybewzj87ZwNeT6xdplTSyPA
```

### Permissions requises
- **Android** : `android/app/src/main/AndroidManifest.xml`
- **iOS** : `ios/Runner/Info.plist`

Permissions nécessaires :
- Caméra (scanner QR)
- Localisation (GPS)
- Internet (API)
- Stockage (base de données locale)

## 🎨 Design System

### Palette de couleurs (basée sur le logo Safari)
- **Vert principal** : `#2E7D32`
- **Orange principal** : `#FF8F00`
- **Variations** : Tons clairs et foncés pour chaque couleur

### Composants personnalisés
- `CustomButton` : Boutons avec états de chargement
- `CustomTextField` : Champs de saisie stylisés
- Thème cohérent avec Material Design 3

## 📱 Écrans principaux

1. **Splash Screen** : Chargement et initialisation
2. **Authentification** : Login/Register gamifié avec OTP
3. **Home** : Dashboard avec actions rapides selon le rôle
4. **Profil** : Gestion des informations personnelles
5. **Achat de billets** : Interface d'achat avec différents types
6. **Scanner QR** : Validation des billets pour les contrôleurs

## 🔄 État du développement

### ✅ Terminé
- Architecture et structure du projet
- Modèles de données avec Isar
- Services (API, Location, QR, Database)
- Provider pour l'authentification
- Écrans principaux (Splash, Auth, Home, Profile, etc.)
- Système de thème et design
- Navigation avec GoRouter

### 🔄 En cours / À faire
- Intégration API backend
- Tests unitaires et d'intégration
- Fonctionnalités de géolocalisation avancées
- Système de notifications push
- Mode hors ligne complet
- Optimisations de performance

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Analyse du code
flutter analyze
```

## 📦 Build

### Android
```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release
```

### iOS
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Contact

- **Équipe de développement** : Safari Smart Mobility Team
- **Email** : dev@safari-mobility.com
- **Documentation** : Voir le fichier markdown des spécifications

---

**Version** : 1.0.0  
**Dernière mise à jour** : Octobre 2024
