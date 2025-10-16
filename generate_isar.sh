#!/bin/bash

# Script pour générer les fichiers Isar
# Safari Smart Mobility - Équipe de bord

echo "🔧 Génération des fichiers Isar pour l'équipe de bord..."

# Générer les fichiers Isar
flutter pub run build_runner build --delete-conflicting-outputs

echo "✅ Génération terminée !"
echo ""
echo "Fichiers générés :"
echo "  - lib/data/models/equipe_bord_model.g.dart"
echo "  - lib/data/models/driver_session_model.g.dart"
echo ""
echo "Vous pouvez maintenant lancer l'application."
