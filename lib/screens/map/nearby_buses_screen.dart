import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_helper.dart';
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
  LatLng? _userLocation;
  bool _isLoadingLocation = true;
  List<BusPosition> _nearbyBuses = [];
  BusPosition? _selectedBus;
  MapStyle _mapStyle = MapStyle.standard;

  final double _maxRadiusKm = 20.0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
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

      // Charger les bus à proximité (données simulées pour l'instant)
      _loadNearbyBuses();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      _showError('Erreur de localisation: $e');
    }
  }

  void _loadNearbyBuses() {
    // Données simulées - À remplacer par un appel API réel
    if (_userLocation == null) return;

    final mockBuses = [
      BusPosition(
        busId: 'BUS-001',
        latitude: _userLocation!.latitude + 0.01,
        longitude: _userLocation!.longitude + 0.01,
        routeName: 'Kinshasa - Gombe',
        direction: 'Gombe',
        status: BusStatus.active,
        occupancy: 25,
        capacity: 40,
        speed: 45.0,
      ),
      BusPosition(
        busId: 'BUS-002',
        latitude: _userLocation!.latitude - 0.015,
        longitude: _userLocation!.longitude + 0.02,
        routeName: 'Kinshasa - Lemba',
        direction: 'Lemba',
        status: BusStatus.active,
        occupancy: 35,
        capacity: 40,
        speed: 38.0,
      ),
      BusPosition(
        busId: 'BUS-003',
        latitude: _userLocation!.latitude + 0.02,
        longitude: _userLocation!.longitude - 0.01,
        routeName: 'Gombe - Lemba',
        direction: 'Lemba',
        status: BusStatus.active,
        occupancy: 15,
        capacity: 40,
        speed: 42.0,
      ),
      BusPosition(
        busId: 'BUS-004',
        latitude: _userLocation!.latitude - 0.01,
        longitude: _userLocation!.longitude - 0.015,
        routeName: 'Kinshasa - Ngaliema',
        direction: 'Ngaliema',
        status: BusStatus.active,
        occupancy: 10,
        capacity: 40,
        speed: 50.0,
      ),
    ];

    // Filtrer les bus dans le rayon de 20km
    final filteredBuses = mockBuses.where((bus) {
      final distance = _calculateDistance(
        _userLocation!.latitude,
        _userLocation!.longitude,
        bus.latitude,
        bus.longitude,
      );
      return distance <= _maxRadiusKm;
    }).toList();

    setState(() {
      _nearbyBuses = filteredBuses;
    });
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
        content: Text(message),
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

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
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
                            bus.busId,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: bus.isFull ? AppColors.error : AppColors.success,
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
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
                              color: AppColors.black,
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

              // Bus Information
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
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
                              color: AppColors.black,
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
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
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
                              color: AppColors.black,
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
                    colors: [AppColors.primaryPurple, AppColors.darkPurple],
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
                            color: AppColors.white.withOpacity(0.9),
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
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Icon(
                      Icons.confirmation_number,
                      color: AppColors.white.withOpacity(0.8),
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
                        side: const BorderSide(color: AppColors.primaryPurple),
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
                                  builder: (context) => BusTicketOrderScreen(
                                    bus: bus,
                                    distance: distance,
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(bus.isFull ? 'Complet' : 'Acheter un billet'),
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

              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
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
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: const Center(
              child: Text('Aucune information utilisateur disponible'),
            ),
          );
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
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
                            color: AppColors.black,
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
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
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
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user.currency == 'USD') ...[
                      const SizedBox(height: 4),
                      Text(
                        '(≈ ${(user.balance ?? 0.0).toStringAsFixed(0)} FC)',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.8),
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
                  color: AppColors.black,
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
              onPressed: _loadNearbyBuses,
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
                          // Marqueurs des bus
                          MarkerLayer(
                            markers: _nearbyBuses.map((bus) {
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

                      // Info panel
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_bus,
                                    color: AppColors.primaryPurple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_nearbyBuses.length} bus à proximité',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Rayon: ${_maxRadiusKm.toInt()} km',
                                  style: TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
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
