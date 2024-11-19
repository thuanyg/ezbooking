import 'package:ezbooking/data/datasources/map_datasource.dart';
import 'package:ezbooking/data/models/location_result.dart';
import 'package:ezbooking/data/models/place_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class MapUseCase {
  final MapDatasource _datasource;

  MapUseCase(this._datasource);

  /// Get the user's current location with address
  Future<LocationResult> getCurrentLocation(BuildContext context) async {
    // First check if location services are available
    final hasPermission = await _datasource.checkLocationAvailability(context);
    if (!hasPermission) {
      return LocationResult(
        error: 'Location services are not available or permitted',
      );
    }

    // Get location data
    final locationData =
        await _datasource.getCurrentLocationWithAddress(context);

    if (locationData['error'] != null) {
      return LocationResult(
        error: locationData['error'],
      );
    }

    return LocationResult(
      position: Position(
        latitude: locationData['position']['latitude'],
        longitude: locationData['position']['longitude'],
        timestamp: DateTime.now(),
        accuracy: locationData['position']['accuracy'],
        altitude: locationData['position']['altitude'],
        heading: 0.0,
        speed: locationData['position']['speed'],
        speedAccuracy: locationData['position']['speedAccuracy'],
        altitudeAccuracy: 0,
        headingAccuracy: 0.0,
      ),
      address: locationData['address'],
    );
  }

  /// Get place details for specific coordinates
  Future<PlaceDetails> getPlaceDetails({
    required double latitude,
    required double longitude,
  }) async {
    final placeInfo = await _datasource.getDetailedPlaceInfo(
      latitude: latitude,
      longitude: longitude,
    );

    if (placeInfo.containsKey('error')) {
      return PlaceDetails(
        error: placeInfo['error'],
      );
    }

    return PlaceDetails(
      street: placeInfo['street'],
      subLocality: placeInfo['subLocality'],
      locality: placeInfo['locality'],
      administrativeArea: placeInfo['administrativeArea'],
      postalCode: placeInfo['postalCode'],
      country: placeInfo['country'],
      fullAddress: placeInfo['fullAddress'],
    );
  }

  /// Get just the address for specific coordinates
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    return await _datasource.getAddressFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Calculate distance between two points in meters
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

  /// Check if a location is within a certain radius (in meters) of another location
  bool isLocationWithinRadius({
    required double centerLatitude,
    required double centerLongitude,
    required double pointLatitude,
    required double pointLongitude,
    required double radiusInMeters,
  }) {
    final distance = calculateDistance(
      startLatitude: centerLatitude,
      startLongitude: centerLongitude,
      endLatitude: pointLatitude,
      endLongitude: pointLongitude,
    );

    return distance <= radiusInMeters;
  }

  /// Format distance in a human-readable way
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      final kilometers = distanceInMeters / 1000;
      return '${kilometers.toStringAsFixed(1)} km';
    }
  }
}
