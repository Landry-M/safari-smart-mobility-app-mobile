import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  
  StreamController<Position>? _positionController;
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastKnownPosition;
  
  // Location settings
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters
  );
  
  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Check and request permissions
      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) {
        throw LocationServiceException('Permission de localisation refusée');
      }
      
      // Check if location services are enabled
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        throw LocationServiceException('Services de localisation désactivés');
      }
      
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      _lastKnownPosition = position;
      return position;
    } catch (e) {
      if (e is LocationServiceException) rethrow;
      throw LocationServiceException('Impossible d\'obtenir la position: $e');
    }
  }
  
  // Get last known position
  Position? getLastKnownPosition() {
    return _lastKnownPosition;
  }
  
  // Start listening to position changes
  Stream<Position> startLocationStream() {
    if (_positionController != null && !_positionController!.isClosed) {
      return _positionController!.stream;
    }
    
    _positionController = StreamController<Position>.broadcast();
    
    _startLocationUpdates();
    
    return _positionController!.stream;
  }
  
  // Stop listening to position changes
  void stopLocationStream() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    
    if (_positionController != null && !_positionController!.isClosed) {
      _positionController!.close();
    }
    _positionController = null;
  }
  
  // Start location updates
  Future<void> _startLocationUpdates() async {
    try {
      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) {
        _positionController?.addError(
          LocationServiceException('Permission de localisation refusée'),
        );
        return;
      }
      
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        _positionController?.addError(
          LocationServiceException('Services de localisation désactivés'),
        );
        return;
      }
      
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: _locationSettings,
      ).listen(
        (position) {
          _lastKnownPosition = position;
          _positionController?.add(position);
        },
        onError: (error) {
          _positionController?.addError(
            LocationServiceException('Erreur de localisation: $error'),
          );
        },
      );
    } catch (e) {
      _positionController?.addError(
        LocationServiceException('Impossible de démarrer la localisation: $e'),
      );
    }
  }
  
  // Check and request location permission
  Future<bool> _checkAndRequestPermission() async {
    // Check app permission
    var permission = await Permission.location.status;
    
    if (permission.isDenied) {
      permission = await Permission.location.request();
    }
    
    if (permission.isPermanentlyDenied) {
      // Open app settings
      await openAppSettings();
      return false;
    }
    
    return permission.isGranted;
  }
  
  // Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final permission = await Permission.location.status;
    return permission.isGranted;
  }
  
  // Request location permission
  Future<bool> requestLocationPermission() async {
    final permission = await Permission.location.request();
    return permission.isGranted;
  }
  
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  // Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
  
  // Calculate distance between two positions
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
  
  // Calculate bearing between two positions
  double calculateBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
  
  // Check if position is within radius of target
  bool isWithinRadius({
    required Position currentPosition,
    required double targetLatitude,
    required double targetLongitude,
    required double radiusInMeters,
  }) {
    final distance = calculateDistance(
      startLatitude: currentPosition.latitude,
      startLongitude: currentPosition.longitude,
      endLatitude: targetLatitude,
      endLongitude: targetLongitude,
    );
    
    return distance <= radiusInMeters;
  }
  
  // Get location accuracy description
  String getAccuracyDescription(Position position) {
    final accuracy = position.accuracy;
    
    if (accuracy <= 5) {
      return 'Très précise';
    } else if (accuracy <= 10) {
      return 'Précise';
    } else if (accuracy <= 20) {
      return 'Bonne';
    } else if (accuracy <= 50) {
      return 'Moyenne';
    } else {
      return 'Faible';
    }
  }
  
  // Format position for display
  String formatPosition(Position position) {
    return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }
  
  // Dispose resources
  void dispose() {
    stopLocationStream();
  }
}

// Custom exception for location service errors
class LocationServiceException implements Exception {
  final String message;
  
  LocationServiceException(this.message);
  
  @override
  String toString() => 'LocationServiceException: $message';
}
