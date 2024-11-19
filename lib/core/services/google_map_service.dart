import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapService {
  Future<Placemark?> getPlaceMark(
      {required double lat, required double long}) async {
    try {
      // Fetch the list of Placemarks for the provided coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      // Return the first Placemark if available
      return placemarks.isNotEmpty ? placemarks[0] : null;
    } catch (e) {
      print("Error retrieving placemark: $e");
      return null;
    }
  }

  Future<String?> getFullAddress(
      {required double lat, required double long}) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Create a list of address components, ignoring empty ones
        List<String?> addressParts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((part) => part != null && part.isNotEmpty).toList();

        return addressParts.join(", ");
      } else {
        return "No address found";
      }
    } catch (e) {
      print("Error occurred while getting address: $e");
      return null;
    }
  }

  Future<Position?> getCurrentPosition(BuildContext context) async {
    AndroidSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return null;

    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      print("Location services are disabled.");
      return null;
    }

    try {
      // Get current position with error handling and a timeout
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("Location request timed out.");
          return Future.error("Location request timed out.");
        },
      );
      return position;
    } catch (e) {
      print("Error obtaining location: $e");
      return null;
    }
  }

  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}