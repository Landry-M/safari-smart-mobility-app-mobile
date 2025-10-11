// Script pour normaliser les numéros de téléphone dans Firestore
// À exécuter via Firebase Functions ou localement avec Firebase Admin SDK

import 'package:cloud_firestore/cloud_firestore.dart';

/// Normalise un numéro de téléphone au format +243XXXXXXXXX
String normalizePhoneNumber(String phone) {
  // Retirer tous les caractères sauf chiffres et +
  String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
  
  // Si le numéro commence par +, le garder tel quel mais vérifier
  if (cleaned.startsWith('+')) {
    return cleaned;
  }
  
  // Si le numéro commence par 0, le retirer
  if (cleaned.startsWith('0')) {
    cleaned = cleaned.substring(1);
  }
  
  // Si le numéro commence par 243, ajouter le +
  if (cleaned.startsWith('243')) {
    return '+$cleaned';
  }
  
  // Sinon, ajouter le code pays RDC Congo par défaut
  return '+243$cleaned';
}

/// Fonction principale pour normaliser tous les numéros
Future<void> normalizeAllPhoneNumbers() async {
  final firestore = FirebaseFirestore.instance;
  
  print('🔄 Début de la normalisation des numéros de téléphone...');
  print('');
  
  try {
    // Récupérer tous les utilisateurs
    final snapshot = await firestore.collection('users').get();
    
    print('📊 Nombre d\'utilisateurs trouvés: ${snapshot.docs.length}');
    print('');
    
    int updatedCount = 0;
    int errorCount = 0;
    int skippedCount = 0;
    
    for (var doc in snapshot.docs) {
      try {
        final data = doc.data();
        final phone = data['phone'] as String?;
        
        if (phone == null || phone.isEmpty) {
          print('⚠️  ${doc.id}: Pas de numéro de téléphone');
          skippedCount++;
          continue;
        }
        
        // Normaliser le numéro
        final normalizedPhone = normalizePhoneNumber(phone);
        
        // Mettre à jour seulement si différent
        if (normalizedPhone != phone) {
          await doc.reference.update({'phone': normalizedPhone});
          print('✅ ${doc.id}: $phone → $normalizedPhone');
          updatedCount++;
        } else {
          print('✓  ${doc.id}: $phone (déjà au bon format)');
          skippedCount++;
        }
      } catch (e) {
        print('❌ ${doc.id}: Erreur - $e');
        errorCount++;
      }
    }
    
    print('');
    print('═══════════════════════════════════════════');
    print('📈 RÉSUMÉ');
    print('═══════════════════════════════════════════');
    print('✅ Mis à jour:     $updatedCount');
    print('✓  Déjà corrects:  $skippedCount');
    print('❌ Erreurs:        $errorCount');
    print('📊 Total:          ${snapshot.docs.length}');
    print('═══════════════════════════════════════════');
    
  } catch (e) {
    print('');
    print('💥 ERREUR FATALE: $e');
  }
}

/// Fonction pour vérifier un numéro spécifique
Future<void> checkSpecificPhone(String phoneToCheck) async {
  final firestore = FirebaseFirestore.instance;
  
  print('🔍 Recherche du numéro: $phoneToCheck');
  print('');
  
  final normalized = normalizePhoneNumber(phoneToCheck);
  print('📱 Numéro normalisé: $normalized');
  print('');
  
  // Essayer différents formats
  final formats = [
    phoneToCheck,
    normalized,
    phoneToCheck.replaceAll(' ', ''),
    phoneToCheck.replaceAll('+', ''),
  ].toSet().toList(); // Retirer les doublons
  
  print('🔎 Formats testés:');
  for (var format in formats) {
    print('   - $format');
  }
  print('');
  
  bool found = false;
  
  for (var format in formats) {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('phone', isEqualTo: format)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        
        print('✅ TROUVÉ avec le format: $format');
        print('');
        print('📄 Document ID: ${doc.id}');
        print('👤 Nom: ${data['name']}');
        print('📧 Email: ${data['email']}');
        print('📱 Téléphone stocké: ${data['phone']}');
        print('🎭 Rôle: ${data['role']}');
        print('');
        
        found = true;
        break;
      }
    } catch (e) {
      print('⚠️  Erreur lors de la recherche avec $format: $e');
    }
  }
  
  if (!found) {
    print('❌ Aucun utilisateur trouvé avec ce numéro');
    print('');
    print('💡 Suggestions:');
    print('   1. Vérifier que le numéro existe dans Firestore');
    print('   2. Exécuter normalizeAllPhoneNumbers() pour normaliser tous les numéros');
    print('   3. Vérifier les règles Firestore (permissions de lecture)');
  }
}

/// Fonction pour afficher tous les numéros
Future<void> listAllPhones() async {
  final firestore = FirebaseFirestore.instance;
  
  print('📋 Liste de tous les numéros de téléphone');
  print('');
  
  try {
    final snapshot = await firestore.collection('users').get();
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name'] ?? 'Sans nom';
      final phone = data['phone'] ?? 'Pas de numéro';
      
      print('• $name: $phone');
    }
    
    print('');
    print('Total: ${snapshot.docs.length} utilisateurs');
    
  } catch (e) {
    print('❌ Erreur: $e');
  }
}

// ══════════════════════════════════════════════════════════════
// INSTRUCTIONS D'UTILISATION
// ══════════════════════════════════════════════════════════════
//
// Ce script ne peut PAS être exécuté directement dans l'application Flutter.
// Il doit être exécuté via Firebase Functions ou un script Node.js avec Admin SDK.
//
// === Option 1: Via Firebase Functions ===
//
// 1. Créer une fonction HTTP dans functions/index.js:
//
// exports.normalizePhones = functions.https.onRequest(async (req, res) => {
//   const db = admin.firestore();
//   const snapshot = await db.collection('users').get();
//   
//   let updated = 0;
//   for (const doc of snapshot.docs) {
//     const phone = doc.data().phone;
//     if (phone) {
//       const normalized = normalizePhoneNumber(phone);
//       if (normalized !== phone) {
//         await doc.ref.update({ phone: normalized });
//         updated++;
//       }
//     }
//   }
//   
//   res.json({ message: `${updated} numéros normalisés` });
// });
//
// 2. Déployer: firebase deploy --only functions
// 3. Appeler la fonction via l'URL générée
//
// === Option 2: Via Script Node.js Local ===
//
// 1. Créer normalize_phones.js:
//
// const admin = require('firebase-admin');
// const serviceAccount = require('./serviceAccountKey.json');
//
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });
//
// const db = admin.firestore();
//
// function normalizePhoneNumber(phone) {
//   let cleaned = phone.replace(/[^\d+]/g, '');
//   if (cleaned.startsWith('+')) return cleaned;
//   if (cleaned.startsWith('0')) cleaned = cleaned.substring(1);
//   if (cleaned.startsWith('243')) return '+' + cleaned;
//   return '+243' + cleaned;
// }
//
// async function run() {
//   const snapshot = await db.collection('users').get();
//   console.log(`Found ${snapshot.size} users`);
//   
//   for (const doc of snapshot.docs) {
//     const phone = doc.data().phone;
//     if (phone) {
//       const normalized = normalizePhoneNumber(phone);
//       if (normalized !== phone) {
//         await doc.ref.update({ phone: normalized });
//         console.log(`Updated: ${phone} -> ${normalized}`);
//       }
//     }
//   }
//   
//   console.log('Done!');
//   process.exit(0);
// }
//
// run().catch(console.error);
//
// 2. Installer: npm install firebase-admin
// 3. Télécharger la clé de service depuis Firebase Console
// 4. Exécuter: node normalize_phones.js
//
// === Option 3: Via Console Firebase (Manuel) ===
//
// Pour chaque document dans la collection 'users':
// 1. Copier le numéro de téléphone
// 2. Le normaliser au format +243XXXXXXXXX
// 3. Mettre à jour le champ 'phone'
//
// ══════════════════════════════════════════════════════════════

void main() {
  print('⚠️  Ce script doit être exécuté via Firebase Admin SDK');
  print('    Consultez les instructions ci-dessus');
}
