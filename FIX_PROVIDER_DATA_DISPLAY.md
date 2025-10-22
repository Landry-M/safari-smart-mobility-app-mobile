# Fix : Affichage des données du Provider dans HomeDriverScreen

## Problème identifié
Aucune donnée provenant de l'API ne s'affichait dans `HomeDriverScreen` depuis le passage au pattern Provider.

## Cause
Les données étaient chargées dans le `EquipeBordProvider` via `loadActiveSession()` et `loadTodayStats()`, mais **n'étaient pas consommées** dans l'UI. Le screen utilisait uniquement des variables locales qui n'étaient jamais mises à jour.

## Solution appliquée

### 1. Wrapper le build avec Consumer<EquipeBordProvider>
```dart
@override
Widget build(BuildContext context) {
  return Consumer<EquipeBordProvider>(
    builder: (context, provider, child) {
      // Les données du Provider sont maintenant disponibles ici
      _chauffeur = provider.chauffeur;
      _receveur = provider.receveur;
      _controleur = provider.controleur;
      _bus = provider.bus;
      _todayStats.addAll(provider.todayStats);
      
      return Scaffold(...);
    },
  );
}
```

### 2. Synchronisation automatique
Le `Consumer` se reconstruit automatiquement quand `notifyListeners()` est appelé dans le Provider, donc :
- Quand `loadActiveSession()` finit → UI se met à jour
- Quand `loadTodayStats()` finit → UI se met à jour
- Quand les données changent → UI se rafraîchit

## Données disponibles dans le Provider

### Membres de l'équipe
- `provider.chauffeur` → Objet `EquipeBord?` pour le chauffeur
- `provider.receveur` → Objet `EquipeBord?` pour le receveur
- `provider.controleur` → Objet `EquipeBord?` pour le contrôleur

### Bus
- `provider.bus` → Objet `Bus?` avec toutes les infos du véhicule

### Statistiques
- `provider.todayStats` → Map avec :
  - `trips` : nombre de voyages
  - `passengers` : nombre de passagers
  - `revenue` : recettes
  - `ticketsScanned` : billets scannés

## Flux de données

```
1. User ouvre HomeDriverScreen
   ↓
2. initState() appelle provider.loadActiveSession()
   ↓
3. Provider charge les données depuis Isar
   ↓
4. Provider appelle notifyListeners()
   ↓
5. Consumer se reconstruit avec les nouvelles données
   ↓
6. UI affiche les informations
```

## Testing

Pour vérifier que tout fonctionne :

1. **Console logs** : Cherchez ces messages dans les logs :
   ```
   ✅ Session active chargée
   🚌 Bus: [numero] - [immatriculation]
   ```

2. **Debug** : Ajoutez un print dans le Consumer :
   ```dart
   print('🔄 Consumer rebuild - Bus: ${provider.bus?.numero}');
   ```

3. **Vérification visuelle** : 
   - L'immatriculation du bus devrait s'afficher dans l'en-tête
   - Les matricules des membres devraient apparaître dans l'onglet Équipe
   - Les stats du jour devraient être visibles

## Points d'attention

- ⚠️ Les données doivent d'abord être sauvegardées lors du login (voir `EquipeBordProvider.saveDriverSession()`)
- ⚠️ Si rien ne s'affiche, vérifier que la session a bien été créée dans Isar
- ⚠️ Le refresh pull-to-refresh recharge les données via `_refreshBusData()`

## Fichiers modifiés
- `lib/screens/driver/home_driver_screen.dart`
  - Ajout de `Consumer<EquipeBordProvider>` dans build()
  - Assignation des données du Provider aux variables locales
  - Ajout des imports manquants (ApiService, EquipeBordService)
