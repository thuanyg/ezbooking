import 'package:ezbooking/core/services/google_map_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapDatasource {
  final GoogleMapService _googleMapService;

  MapDatasource(this._googleMapService);

  /// Get the current location coordinates
  Future<Position?> getCurrentLocation(BuildContext context) async {
    return await _googleMapService.getCurrentPosition(context);
  }

  /// Get the full address for given coordinates
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    return await _googleMapService.getFullAddress(
      lat: latitude,
      long: longitude,
    );
  }

  /// Get detailed place information for given coordinates
  Future<Map<String, String?>> getDetailedPlaceInfo({
    required double latitude,
    required double longitude,
  }) async {
    final placemark = await _googleMapService.getPlaceMark(
      lat: latitude,
      long: longitude,
    );

    if (placemark == null) {
      return {
        'error': 'Unable to fetch location details',
      };
    }

    return {
      'street': placemark.street,
      'subLocality': placemark.subLocality,
      'locality': placemark.locality,
      'administrativeArea': placemark.administrativeArea,
      'postalCode': placemark.postalCode,
      'country': placemark.country,
      'fullAddress': '${placemark.street}, ${placemark.locality}, ${placemark.country}',
    };
  }

  /// Check if location services are available and permitted
  Future<bool> checkLocationAvailability(BuildContext context) async {
    return await GoogleMapService.handleLocationPermission(context);
  }

  /// Get both current location and address in one call
  Future<Map<String, dynamic>> getCurrentLocationWithAddress(BuildContext context) async {
    final position = await getCurrentLocation(context);

    if (position == null) {
      return {
        'error': 'Unable to get current location',
        'position': null,
        'address': null,
      };
    }

    final address = await getAddressFromCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return {
      'error': null,
      'position': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'speedAccuracy': position.speedAccuracy,
      },
      'address': address,
    };
  }
}