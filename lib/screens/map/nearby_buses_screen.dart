import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/services/api_service.dart';
import '../../data/models/bus_position_model.dart';
import '../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../tickets/bus_ticket_order_screen.dart';

class NearbyBusesScreen extends StatefulWidget {
  const NearbyBusesScreen({super.key});

  @override
  State<NearbyBusesScreen> createState() => _NearbyBusesScreenState();
}

enum MapStyle {
  standard,
  satellite,
  terrain,
}

class _NearbyBusesScreenState extends State<NearbyBusesScreen> {
  final MapController _mapController = MapController();
  final ApiService _apiService = ApiService();
  LatLng? _userLocation;
  bool _isLoadingLocation = true;
  bool _isLoadingTrajets = true;
  bool _isLoadingBuses = false;
  List<BusPosition> _nearbyBuses = [];
  List<BusPosition> _filteredBuses = [];
  BusPosition? _selectedBus;
  MapStyle _mapStyle = MapStyle.standard;

  // Dropdown data
  List<Map<String, dynamic>> _trajetsFromApi = [];
  Map<String, dynamic>? _selectedTrajet;

  // Trajet coordinates
  LatLng? _trajetDepart;
  LatLng? _trajetArrivee;

  // Rayon urbain: 5 km, Inter-urbain: 30 km
  double _maxRadiusKm = 5.0;
  bool _isUrbanMode = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _loadTrajets();
    _loadAllNearbyBuses();
  }

  Future<void> _loadTrajets() async {
    try {
      final trajets = await _apiService.getLignes();
      setState(() {
        _trajetsFromApi = trajets;
        _isLoadingTrajets = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des trajets: $e');
      setState(() {
        _isLoadingTrajets = false;
      });
    }
  }

  Future<void> _loadBusByTrajet(String trajetId) async {
    setState(() {
      _isLoadingBuses = true;
    });

    try {
      final busData = await _apiService.getBusByLigne(trajetId);

      // Convertir les données de l'API en BusPosition pour l'affichage sur la carte
      _convertApiBusToBusPositions(busData);

      setState(() {
        _isLoadingBuses = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des bus: $e');
      setState(() {
        _isLoadingBuses = false;
      });
    }
  }

  Future<void> _loadAllNearbyBuses() async {
    try {
      final busData = await _apiService.getAllNearbyBuses();

      // Attendre que la position de l'utilisateur soit disponible
      int attempts = 0;
      while (_userLocation == null && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (_userLocation == null) {
        print('Position utilisateur non disponible');
        return;
      }

      // Filtrer les bus dans un rayon de 30 km
      final List<BusPosition> positions = [];

      for (var bus in busData) {
        if (bus['latitude'] != null && bus['longitude'] != null) {
          final busLat = double.tryParse(bus['latitude'].toString()) ?? 0.0;
          final busLng = double.tryParse(bus['longitude'].toString()) ?? 0.0;

          // Calculer la distance entre l'utilisateur et le bus
          final distance = _calculateDistance(
            _userLocation!.latitude,
            _userLocation!.longitude,
            busLat,
            busLng,
          );

          // Ne garder que les bus dans un rayon de 30 km
          if (distance <= 30.0) {
            // Trouver le nom de la ligne depuis trajets
            String? routeName;
            if (bus['trajet_id'] != null) {
              final trajet = _trajetsFromApi.firstWhere(
                (t) => t['id'].toString() == bus['trajet_id'].toString(),
                orElse: () => {},
              );
              routeName = trajet['nom'];
            }

            positions.add(BusPosition(
              busId: bus['numero']?.toString() ?? 'N/A',
              immatriculation: bus['immatriculation']?.toString(),
              marque: bus['marque']?.toString(),
              modele: bus['modele']?.toString(),
              latitude: busLat,
              longitude: busLng,
              routeName: routeName ?? 'Non défini',
              direction: bus['notes'] ?? '',
              status: _convertStatut(bus['statut']),
              occupancy: 0,
              capacity: int.tryParse(bus['capacite']?.toString() ?? '40') ?? 40,
              speed: 35.0 +
                  (double.tryParse(bus['id']?.toString() ?? '0') ?? 0) % 20,
            ));
          }
        }
      }

      setState(() {
        _nearbyBuses = positions;
        _filteredBuses = List.from(positions);
      });
    } catch (e) {
      print('Erreur lors du chargement des bus à proximité: $e');
    }
  }

  void _convertApiBusToBusPositions(List<Map<String, dynamic>> busData) {
    final List<BusPosition> positions = [];

    for (var bus in busData) {
      // Ne garder que les bus avec coordonnées GPS
      if (bus['latitude'] != null && bus['longitude'] != null) {
        positions.add(BusPosition(
          busId: bus['numero']?.toString() ?? 'N/A',
          immatriculation: bus['immatriculation']?.toString(),
          marque: bus['marque']?.toString(),
          modele: bus['modele']?.toString(),
          latitude: double.tryParse(bus['latitude'].toString()) ?? 0.0,
          longitude: double.tryParse(bus['longitude'].toString()) ?? 0.0,
          routeName: _selectedTrajet?['nom'] ?? 'Non défini',
          direction: bus['notes'] ?? '',
          status: _convertStatut(bus['statut']),
          occupancy: 0, // Pas de données d'occupation dans la BDD
          capacity: int.tryParse(bus['capacite']?.toString() ?? '40') ?? 40,
          speed: 35.0 +
              (double.tryParse(bus['id']?.toString() ?? '0') ?? 0) %
                  20, // Données de test : vitesse entre 35-55 km/h
        ));
      }
    }

    setState(() {
      _nearbyBuses = positions;
      _filteredBuses = List.from(positions);
    });
  }

  BusStatus _convertStatut(String? statut) {
    switch (statut) {
      case 'actif':
        return BusStatus.active;
      case 'maintenance':
        return BusStatus.maintenance;
      case 'panne':
        return BusStatus.breakdown;
      default:
        return BusStatus.inactive;
    }
  }

  void _toggleUrbanMode() {
    setState(() {
      _isUrbanMode = !_isUrbanMode;
      _maxRadiusKm = _isUrbanMode ? 5.0 : 30.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isUrbanMode
            ? 'Mode urbain: Rayon 5 km'
            : 'Mode inter-urbain: Rayon 30 km'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updateTrajetCoordinates(Map<String, dynamic>? trajet) {
    if (trajet == null) {
      _trajetDepart = null;
      _trajetArrivee = null;
      return;
    }

    // Extraire les coordonnées de départ et d'arrivée
    final latDepart = trajet['latitude_depart'];
    final lonDepart = trajet['longitude_depart'];
    final latArrivee = trajet['latitude_arrivee'];
    final lonArrivee = trajet['longitude_arrivee'];

    print('🗺️ Coordonnées du trajet "${trajet['nom']}":');
    print('  - Départ: lat=$latDepart, lon=$lonDepart');
    print('  - Arrivée: lat=$latArrivee, lon=$lonArrivee');

    if (latDepart != null &&
        lonDepart != null &&
        latArrivee != null &&
        lonArrivee != null) {
      try {
        _trajetDepart = LatLng(
          double.parse(latDepart.toString()),
          double.parse(lonDepart.toString()),
        );
        _trajetArrivee = LatLng(
          double.parse(latArrivee.toString()),
          double.parse(lonArrivee.toString()),
        );

        print(
            '✅ Marqueurs créés: Départ=$_trajetDepart, Arrivée=$_trajetArrivee');

        // Ajuster la carte pour afficher tout l'itinéraire
        _fitMapToTrajet();
      } catch (e) {
        print('❌ Erreur lors du parsing des coordonnées: $e');
        _trajetDepart = null;
        _trajetArrivee = null;
      }
    } else {
      print('⚠️ Coordonnées manquantes pour ce trajet');
      _trajetDepart = null;
      _trajetArrivee = null;
    }
  }

  void _fitMapToTrajet() {
    if (_trajetDepart == null || _trajetArrivee == null) return;

    // Créer une liste de tous les points à afficher
    List<LatLng> allPoints = [_trajetDepart!, _trajetArrivee!];

    // Ajouter la position de l'utilisateur si disponible
    if (_userLocation != null) {
      allPoints.add(_userLocation!);
    }

    // Calculer les bounds (limites) qui englobent tous les points
    double minLat = allPoints[0].latitude;
    double maxLat = allPoints[0].latitude;
    double minLng = allPoints[0].longitude;
    double maxLng = allPoints[0].longitude;

    for (var point in allPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Calculer le centre et le zoom approprié
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    final center = LatLng(centerLat, centerLng);

    // Calculer la distance entre les points les plus éloignés
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    // Déterminer le niveau de zoom en fonction de la distance
    double zoom;
    if (maxDiff > 0.5) {
      zoom = 10.0; // Vue large pour grandes distances
    } else if (maxDiff > 0.2) {
      zoom = 11.5; // Vue moyenne
    } else if (maxDiff > 0.1) {
      zoom = 12.5; // Vue rapprochée
    } else {
      zoom = 13.5; // Vue très rapprochée
    }

    // Déplacer et zoomer la carte de manière fluide
    // Note: flutter_map ne supporte pas l'animation native, mais le mouvement sera visible
    _mapController.move(center, zoom);

    // Afficher un message à l'utilisateur
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Itinéraire affiché: ${_selectedTrajet?['nom'] ?? 'Trajet'}'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _initializeLocation() async {
    try {
      // Vérifier et demander les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Permission de localisation refusée');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Permission de localisation refusée définitivement');
        return;
      }

      // Obtenir la position actuelle
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      _showError('Erreur de localisation: $e');
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const Distance distance = Distance();
    return distance.as(
      LengthUnit.Kilometer,
      LatLng(lat1, lon1),
      LatLng(lat2, lon2),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  String _getMapTileUrl() {
    switch (_mapStyle) {
      case MapStyle.standard:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapStyle.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case MapStyle.terrain:
        return 'https://tile.opentopomap.org/{z}/{x}/{y}.png';
    }
  }

  IconData _getMapStyleIcon() {
    switch (_mapStyle) {
      case MapStyle.standard:
        return Icons.map;
      case MapStyle.satellite:
        return Icons.satellite;
      case MapStyle.terrain:
        return Icons.terrain;
    }
  }

  void _changeMapStyle() {
    setState(() {
      switch (_mapStyle) {
        case MapStyle.standard:
          _mapStyle = MapStyle.satellite;
          break;
        case MapStyle.satellite:
          _mapStyle = MapStyle.terrain;
          break;
        case MapStyle.terrain:
          _mapStyle = MapStyle.standard;
          break;
      }
    });

    // Show snackbar with current style
    final styleName = _mapStyle == MapStyle.standard
        ? 'Standard'
        : _mapStyle == MapStyle.satellite
            ? 'Satellite'
            : 'Terrain';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Style de carte: $styleName'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onBusMarkerTapped(BusPosition bus) {
    setState(() {
      _selectedBus = bus;
    });
    _showBusDetails(bus);
  }

  void _showBusDetails(BusPosition bus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildBusDetailsSheet(bus),
    );
  }

  void _showUserDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildUserDetailsSheet(),
    );
  }

  void _showTrajetPointDetails(String type) {
    final point = type == 'départ' ? _trajetDepart : _trajetArrivee;
    if (point == null || _selectedTrajet == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          color: AppColors.white,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // En-tête avec icône
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: type == 'départ'
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        type == 'départ' ? Icons.location_on : Icons.flag,
                        color: type == 'départ' ? Colors.green : Colors.red,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Point de ${type}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedTrajet!['nom'] ?? 'Ligne',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Coordonnées GPS
                _buildInfoRow(
                  Icons.place,
                  'Latitude',
                  point.latitude.toStringAsFixed(6),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.place,
                  'Longitude',
                  point.longitude.toStringAsFixed(6),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Informations du trajet
                if (_selectedTrajet!['distance_totale'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildInfoRow(
                      Icons.straighten,
                      'Distance totale',
                      '${_selectedTrajet!['distance_totale']} km',
                    ),
                  ),
                if (_selectedTrajet!['duree_estimee'] != null &&
                    _selectedTrajet!['duree_estimee'] != '0')
                  _buildInfoRow(
                    Icons.access_time,
                    'Durée estimée',
                    '${_selectedTrajet!['duree_estimee']} min',
                  ),

                const SizedBox(height: 24),

                // Bouton fermer
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusDetailsSheet(BusPosition bus) {
    final distance = _userLocation != null
        ? _calculateDistance(
            _userLocation!.latitude,
            _userLocation!.longitude,
            bus.latitude,
            bus.longitude,
          )
        : 0.0;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final ticketPrice = 200.0; // Prix en FC

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Container(
            color: AppColors.white,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 24 + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bus ID and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.directions_bus,
                                color: AppColors.primaryPurple,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bus #${bus.busId}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (bus.immatriculation != null)
                                  Text(
                                    bus.immatriculation!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                Text(
                                  _getStatusText(bus.status),
                                  style: TextStyle(
                                    color: _getStatusColor(bus.status),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: bus.isFull
                                ? AppColors.error
                                : AppColors.success,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            bus.isFull
                                ? 'Complet'
                                : '${bus.occupancy}/${bus.capacity}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Route Line Display
                    const Text(
                      'Ligne de bus',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryPurple,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.route,
                              color: AppColors.primaryPurple,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bus.routeName ?? 'Non définie',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.navigation,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Direction: ${bus.direction ?? 'Non définie'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bus Model and Brand
                    if (bus.marque != null || bus.modele != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informations du véhicule',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.grey.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color: AppColors.primaryPurple,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${bus.marque ?? ''} ${bus.modele ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                    // Bus Information
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.grey.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.info,
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${distance.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Text(
                                  'Distance',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.grey.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.speed,
                                  color: AppColors.success,
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${bus.speed?.toStringAsFixed(0) ?? '0'} km/h',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Text(
                                  'Vitesse',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Pricing
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryPurple,
                            AppColors.darkPurple
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prix du billet',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyHelper.convertAndFormat(
                                  ticketPrice,
                                  user?.currency ?? 'FC',
                                ),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (user?.currency == 'USD') ...[
                                const SizedBox(height: 4),
                                Text(
                                  '(≈ ${ticketPrice.toStringAsFixed(0)} FC)',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Icon(
                            Icons.confirmation_number,
                            color: AppColors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: const Text('Fermer'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryPurple,
                              side: const BorderSide(
                                  color: AppColors.primaryPurple),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: bus.isFull
                                ? null
                                : () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BusTicketOrderScreen(
                                          bus: bus,
                                          distance: distance,
                                        ),
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.shopping_cart),
                            label: Text(
                                bus.isFull ? 'Complet' : 'Acheter un billet'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserDetailsSheet() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        if (user == null) {
          return Container(
            color: AppColors.white,
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
            ),
            child: const Center(
              child: Text('Aucune information utilisateur disponible'),
            ),
          );
        }

        return Container(
          color: AppColors.white,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // User Header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? 'Utilisateur',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          user.phone ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // User Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    _buildUserInfoRow(
                      Icons.email,
                      'Email',
                      user.email ?? 'Non renseigné',
                    ),
                    const Divider(height: 24),
                    _buildUserInfoRow(
                      Icons.work,
                      'Rôle',
                      _getRoleName(user.role),
                    ),
                    const Divider(height: 24),
                    _buildUserInfoRow(
                      Icons.monetization_on,
                      'Devise',
                      user.currency ?? 'FC',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.darkPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solde disponible',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyHelper.convertAndFormat(
                        user.balance ?? 0.0,
                        user.currency ?? 'FC',
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user.currency == 'USD') ...[
                      const SizedBox(height: 4),
                      Text(
                        '(≈ ${(user.balance ?? 0.0).toStringAsFixed(0)} FC)',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Fermer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.passenger:
        return 'Passager';
      case UserRole.driver:
        return 'Chauffeur';
      case UserRole.controller:
        return 'Contrôleur';
      case UserRole.collector:
        return 'Receveur';
      case UserRole.admin:
        return 'Administrateur';
    }
  }

  String _getStatusText(BusStatus status) {
    switch (status) {
      case BusStatus.active:
        return '● En service';
      case BusStatus.inactive:
        return '● Hors service';
      case BusStatus.maintenance:
        return '● En maintenance';
      case BusStatus.breakdown:
        return '● En panne';
      case BusStatus.depot:
        return '● Au dépôt';
    }
  }

  Color _getStatusColor(BusStatus status) {
    switch (status) {
      case BusStatus.active:
        return AppColors.success;
      case BusStatus.inactive:
        return AppColors.grey;
      case BusStatus.maintenance:
        return AppColors.warning;
      case BusStatus.breakdown:
        return AppColors.error;
      case BusStatus.depot:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryPurple,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bus à proximité'),
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.primaryPurple,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          actions: [
            IconButton(
              icon: Icon(_isUrbanMode ? Icons.location_city : Icons.landscape),
              onPressed: _toggleUrbanMode,
              tooltip: _isUrbanMode ? 'Mode inter-urbain' : 'Mode urbain',
            ),
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                if (_userLocation != null) {
                  _mapController.move(_userLocation!, 14.0);
                }
              },
              tooltip: 'Centrer sur ma position',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Recharger les bus
                if (_selectedTrajet != null && _selectedTrajet!['id'] != null) {
                  // Si une ligne est sélectionnée, recharger les bus de cette ligne
                  _loadBusByTrajet(_selectedTrajet!['id'].toString());
                } else {
                  // Sinon, recharger tous les bus à proximité
                  _loadAllNearbyBuses();
                }
              },
              tooltip: 'Actualiser',
            ),
          ],
        ),
        body: _isLoadingLocation
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                    const SizedBox(height: 16),
                    const Text('Localisation en cours...'),
                  ],
                ),
              )
            : _userLocation == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Impossible d\'obtenir votre position',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _initializeLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Réessayer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      // Map
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _userLocation!,
                          initialZoom: 14.0,
                          minZoom: 10.0,
                          maxZoom: 18.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: _getMapTileUrl(),
                            userAgentPackageName: 'com.safari.sma',
                          ),
                          // Circle pour le rayon de 20km
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: _userLocation!,
                                radius: _maxRadiusKm * 1000, // en mètres
                                useRadiusInMeter: true,
                                color: AppColors.primaryPurple.withOpacity(0.1),
                                borderColor:
                                    AppColors.primaryPurple.withOpacity(0.3),
                                borderStrokeWidth: 2,
                              ),
                            ],
                          ),
                          // Marqueur de l'utilisateur
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _userLocation!,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.info,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: _showUserDetails,
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Marqueurs des bus (filtrés)
                          MarkerLayer(
                            markers: _filteredBuses.map((bus) {
                              final isSelected =
                                  _selectedBus?.busId == bus.busId;
                              return Marker(
                                point: LatLng(bus.latitude, bus.longitude),
                                width: isSelected ? 50 : 40,
                                height: isSelected ? 50 : 40,
                                child: GestureDetector(
                                  onTap: () => _onBusMarkerTapped(bus),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: bus.isFull
                                          ? AppColors.error
                                          : AppColors.success,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: isSelected ? 4 : 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.black.withOpacity(0.3),
                                          blurRadius: isSelected ? 10 : 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.directions_bus,
                                      color: AppColors.white,
                                      size: isSelected ? 24 : 20,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          // Marqueurs du trajet (départ et arrivée)
                          if (_trajetDepart != null || _trajetArrivee != null)
                            MarkerLayer(
                              markers: [
                                if (_trajetDepart != null)
                                  Marker(
                                    point: _trajetDepart!,
                                    width: 50,
                                    height: 50,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showTrajetPointDetails('départ'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: AppColors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_trajetArrivee != null)
                                  Marker(
                                    point: _trajetArrivee!,
                                    width: 50,
                                    height: 50,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showTrajetPointDetails('arrivée'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.flag,
                                          color: AppColors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),

                      // Map style button (bottom left)
                      Positioned(
                        bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
                        left: 16,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _getMapStyleIcon(),
                                color: AppColors.primaryPurple,
                              ),
                              onPressed: _changeMapStyle,
                              tooltip: 'Changer le style de carte',
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ),

                      // Barre de recherche et info panel
                      Positioned(
                        top: 16,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            // Barre de recherche
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.route,
                                      color: AppColors.textSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _isLoadingTrajets
                                          ? const Text(
                                              'Chargement...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.textHint,
                                              ),
                                            )
                                          : DropdownButtonHideUnderline(
                                              child: DropdownButton<
                                                  Map<String, dynamic>>(
                                                value: _selectedTrajet,
                                                dropdownColor: Colors.white,
                                                hint: const Text(
                                                  'Sélectionner une ligne',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                                isExpanded: true,
                                                menuMaxHeight: 400,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color:
                                                      AppColors.primaryPurple,
                                                ),
                                                items: _trajetsFromApi
                                                    .map((trajet) {
                                                  final distance =
                                                      trajet['distance_totale'];
                                                  final distanceText = distance !=
                                                          null
                                                      ? ' (${double.parse(distance.toString()).toStringAsFixed(0)} km)'
                                                      : '';
                                                  return DropdownMenuItem<
                                                      Map<String, dynamic>>(
                                                    value: trajet,
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        '${trajet['nom'] ?? 'Non défini'}$distanceText',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (trajet) {
                                                  setState(() {
                                                    _selectedTrajet = trajet;
                                                    _updateTrajetCoordinates(
                                                        trajet);
                                                  });
                                                  if (trajet != null &&
                                                      trajet['id'] != null) {
                                                    _loadBusByTrajet(
                                                        trajet['id']
                                                            .toString());
                                                  }
                                                },
                                              ),
                                            ),
                                    ),
                                    if (_selectedTrajet != null)
                                      IconButton(
                                        icon: const Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            _selectedTrajet = null;
                                            _nearbyBuses = [];
                                            _filteredBuses = [];
                                            _trajetDepart = null;
                                            _trajetArrivee = null;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            // Info panel
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${_filteredBuses.length}/${_nearbyBuses.length}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _isUrbanMode
                                                ? AppColors.success
                                                    .withOpacity(0.1)
                                                : AppColors.info
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _isUrbanMode ? 'Urb.' : 'Inter',
                                            style: TextStyle(
                                              color: _isUrbanMode
                                                  ? AppColors.success
                                                  : AppColors.info,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPurple
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${_maxRadiusKm.toInt()}km',
                                            style: TextStyle(
                                              color: AppColors.primaryPurple,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Message "Aucun bus trouvé" quand aucun bus disponible
                      if (_filteredBuses.isEmpty &&
                          _selectedTrajet != null &&
                          !_isLoadingBuses)
                        Positioned(
                          top: 100,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.directions_bus_outlined,
                                  size: 48,
                                  color:
                                      AppColors.textSecondary.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Aucun bus actif sur cette ligne',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
