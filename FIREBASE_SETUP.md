# Configuration Firebase pour Safari Smart Mobility

## 📋 Prérequis

- Compte Google/Firebase
- Flutter installé
- Application Safari Smart Mobility

## 🔥 Étapes de Configuration Firebase

### 1. Créer un Projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com)
2. Cliquez sur "Ajouter un projet"
3. Nommez votre projet : `safari-smart-mobility`
4. Activez Google Analytics (optionnel)
5. Créez le projet

### 2. Ajouter l'Application Android

1. Dans la console Firebase, cliquez sur l'icône Android
2. **Package name** : `com.safari.sma`
3. **App nickname** : `Safari Smart Mobility Android`
4. **SHA-1** : Générez avec `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
5. Téléchargez `google-services.json`
6. Placez le fichier dans `android/app/google-services.json`

### 3. Ajouter l'Application iOS

1. Dans la console Firebase, cliquez sur l'icône iOS
2. **Bundle ID** : `com.safari.sma`
3. **App nickname** : `Safari Smart Mobility iOS`
4. Téléchargez `GoogleService-Info.plist`
5. Placez le fichier dans `ios/Runner/GoogleService-Info.plist`

### 4. Activer l'Authentification par Téléphone

1. Dans la console Firebase, allez dans **Authentication**
2. Cliquez sur **Sign-in method**
3. Activez **Phone**
4. Ajoutez votre domaine autorisé si nécessaire

### 5. Configuration des Numéros de Test (Développement)

Pour tester sans envoyer de vrais SMS :

1. Dans **Authentication > Sign-in method > Phone**
2. Ajoutez des numéros de test :
   - `+225 01 02 03 04 05` → Code : `123456`
   - `+225 07 08 09 10 11` → Code : `654321`

### 6. Configuration Android Supplémentaire

Ajoutez dans `android/app/build.gradle` (déjà fait) :

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 7. Configuration iOS Supplémentaire

Dans `ios/Runner/Info.plist`, ajoutez :

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Remplacez `YOUR_REVERSED_CLIENT_ID` par la valeur dans `GoogleService-Info.plist`.

## 🛠 Configuration Backend

### Endpoint pour Vérification Firebase Token

Votre backend doit implémenter l'endpoint `/auth/verify-firebase` :

```javascript
// Node.js/Express exemple
app.post('/auth/verify-firebase', async (req, res) => {
  try {
    const { idToken, phoneNumber } = req.body;
    
    // Vérifier le token Firebase
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;
    const phone = decodedToken.phone_number;
    
    // Créer ou récupérer l'utilisateur
    let user = await User.findOne({ firebaseUid: uid });
    
    if (!user) {
      user = new User({
        firebaseUid: uid,
        phone: phone,
        // Autres données utilisateur
      });
      await user.save();
    }
    
    // Générer JWT token pour votre app
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
    
    res.json({
      success: true,
      user: user,
      token: token
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message
    });
  }
});
```

## 🧪 Test de l'Authentification

### 1. Test en Mode Debug

1. Lancez l'app : `flutter run --debug`
2. Allez sur l'écran d'inscription
3. Utilisez un numéro de test : `+225 01 02 03 04 05`
4. Entrez le code : `123456`

### 2. Test en Production

1. Utilisez un vrai numéro de téléphone
2. Vérifiez que vous recevez le SMS
3. Entrez le code reçu

## 🔒 Sécurité

### Règles de Sécurité Firestore (si utilisé)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Limitations de Quota

- **SMS gratuits** : 10 par jour en mode test
- **Production** : Facturation selon usage
- **Limitation par IP** : Configurez dans la console

## 🚀 Déploiement

### Variables d'Environnement

```bash
# Backend
FIREBASE_PROJECT_ID=safari-smart-mobility
FIREBASE_PRIVATE_KEY=your-private-key
FIREBASE_CLIENT_EMAIL=your-service-account-email
```

### Build de Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📱 Fonctionnalités Implémentées

- ✅ Envoi OTP via Firebase
- ✅ Vérification OTP
- ✅ Gestion des erreurs localisées
- ✅ Support numéros internationaux
- ✅ Formatage automatique (+225)
- ✅ Renvoi de code
- ✅ Auto-vérification
- ✅ Intégration backend
- ✅ Navigation sécurisée

## 🐛 Dépannage

### Erreurs Communes

1. **"Firebase not initialized"**
   - Vérifiez que `Firebase.initializeApp()` est appelé dans `main()`

2. **"Invalid phone number"**
   - Utilisez le format international : `+225XXXXXXXX`

3. **"SMS not received"**
   - Vérifiez les numéros de test en développement
   - Vérifiez les quotas Firebase

4. **"Token verification failed"**
   - Vérifiez la configuration backend
   - Vérifiez les clés de service Firebase

### Logs Utiles

```bash
# Voir les logs Firebase
flutter logs | grep -i firebase

# Voir les logs d'authentification
flutter logs | grep -i auth
```

## 📞 Support

- [Documentation Firebase Auth](https://firebase.google.com/docs/auth)
- [Flutter Firebase](https://firebase.flutter.dev/)
- [Console Firebase](https://console.firebase.google.com)

---

**Note** : Cette configuration est spécifique à la Côte d'Ivoire (+225). Adaptez les numéros de test selon votre région.
