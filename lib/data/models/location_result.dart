import 'package:geolocator/geolocator.dart';

class LocationResult {
  final Position? position;
  final String? address;
  final String? error;

  LocationResult({
    this.position,
    this.address,
    this.error,
  });

  bool get isSuccess => error == null && position != null;
}