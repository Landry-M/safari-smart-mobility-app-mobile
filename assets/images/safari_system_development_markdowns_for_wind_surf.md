# 01_MOBILE_FLUTTER.md

---

# Application Mobile — Plan de réalisation (Flutter)

## 1. Résumé fonctionnel
Application mobile destinée aux agents terrain (Chauffeur) et aux usagers :
- Achat et rechargement de carte prépayée
- Validation de billet via QR code (contrôleur)
- Enregistrement des encaissements (receveur)
- Géolocalisation du bus et couplage à une ligne/trajectoire
- Gamification du processus de login / création de compte (questions interactives)

## 2. Contraintes & décisions techniques
- Framework : Flutter (stable) — langue : Dart
- State management : Provider (conforme à ton historique)
- HTTP : `dio`
- Cartographie : `flutter_map`
- API KEY Google Map: `AIzaSyCokbp76WRQybewzj87ZwNeT6xdplTSyPA`
- QR scanning : `mobile_scanner`
- Géoloc : `geolocator`
- Notifications push : Firebase Cloud Messaging (FCM)
- Auth : JWT (access + refresh) via l'API PHP
- CI/CD : GitHub Actions (build/test) -> déploiement sur Firebase App Distribution / Play Store / TestFlight

## 3. Architecture & modules
- Présentation (UI)
  - Screens : Splash, Onboarding Interactif, Auth (interactif), Home (Dashboard), Achat/Recharge, Scanner, Encaissement, Profil, Historique, Debug/Admin
- Data
  - Repositories : AuthRepo, TicketRepo, BusRepo, TransactionRepo
  - Sources : Remote (ApiService), Local (Isar)
- Services
  - LocationService (push position périodique), QRService, NotificationService, SyncService

## 4. Gamified / interactif Login (UX détaillé)
**But** : Gamifier sans bloquer l'accès; prévoir option "Login classique".

### Objectif
Transformer le login/inscription en mini-dialogue où l'app pose 3–5 questions adaptatives pour personnaliser l'expérience et rendre l'action ludique (ex : avancement, badges). Le résultat génère le profil utilisateur et améliore la collecte de données (profil d'abonnement, préférences).

### Exemple de flux (inscription)
1. Écran 1 — « Salut ! On va créer votre compte en 3 petites étapes. Prêt ? » (Boutons : Oui / J'ai déjà un compte)
2. Écran 2 — Question 1 (Choix rapide) : "Tu voyages plutôt pour : Travail / Études / Tourisme ?" → choix pré-rempli influence profil tarifaire.
3. Écran 3 — Question 2 (Mini-quiz) : "Souhaites-tu recharger ta carte automatiquement ?" (Oui / Non)
4. Écran 4 — Collecte d'info : numéro de téléphone (champ) + bouton envoyer OTP.
5. Écran 5 — OTP (SMS) ou Email, vérification → création du compte côté API (POST /auth/register)
6. Écran 6 — Personnalisation finale : avatar (sélection), nom d'affichage, tutorial rapide.
7. Récompense : animation + badge "Premier pas".

### Variante connexion
- Connexion en 1 clic si token valide.
- Si mot de passe oublié : mini-jeu anti-bot (ex : glisser l'icône pour compléter) + OTP.

### Sécurité & ergonomie
- Option de «Passer le jeu» pour accès rapide.
- Stockage sécurisé du token.
- RGPD : demander consentement pour collecte de données et géoloc.

## 6. Modèle de données local (extraits)
- User { id, name, phone, role, token, balance }
- Ticket { id, user_id, trip_id, qr_code, status, created_at }
- BusPosition { bus_id, lat, lng, timestamp }


## 8. UX/UI notes
- Utiliser animations légères (Lottie) pour récompenses
- Palette sobre, contrastée pour usage en extérieur
- Mode hors-ligne : permettre scan et mise en cache des validations, sync au reconnect


## 10. Tests
- Unit tests pour logique métier
- Integration tests : Auth, Achat, Validation QR
- E2E : simuler contrôle de validation sur trajet

---
