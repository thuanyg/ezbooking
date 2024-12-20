import 'package:ezbooking/data/models/location_result.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart' as lottie;

class AddressFilterChoose extends StatefulWidget {
  static String routeName = "AddressFinderPage";

  const AddressFilterChoose({super.key});

  @override
  _AddressFilterChooseState createState() => _AddressFilterChooseState();
}

class _AddressFilterChooseState extends State<AddressFilterChoose> {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();

  LatLng _center = const LatLng(21.0227384, 105.8163641);
  String? selectedAddress = '';
  bool isLoading = true;
  List<Marker> _markers = <Marker>[];
  LocationResult? _locationResult;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          isLoading = false;
        });

        await _getAddressFromLatLng(_center);
      }
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Get address from latitude and longitude
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        List<String?> addressParts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((part) => part != null && part.isNotEmpty).toList();

        String address = addressParts.join(", ");

        setState(() {
          selectedAddress = address;
          Position p = Position(
            longitude: position.longitude,
            latitude: position.latitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
          _locationResult = LocationResult(address: address, position: p);
          _markers.clear();
          _markers.add(Marker(
              markerId: const MarkerId('selectedLocation'),
              position: position,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: address)));
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // Search for a place
  Future<void> _searchPlace(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLocation = LatLng(location.latitude, location.longitude);

        // Move camera to searched location
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: searchedLocation, zoom: 15)));

        await _getAddressFromLatLng(searchedLocation);
      }
    } catch (e) {
      print('Error searching place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Select Location'),
        actions: [
          IconButton(
            onPressed: () {
              if (_locationResult != null) {
                Navigator.pop<LocationResult?>(context, _locationResult);
              }
            },
            icon: _locationResult != null
                ? const Icon(Icons.done, color: Colors.green)
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: lottie.Lottie.asset(
                "assets/animations/loading.json",
                height: 80,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'Search location',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (searchController.text.isNotEmpty) {
                            _searchPlace(searchController.text);
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _searchPlace(value);
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          selectedAddress ?? "No location was chosen!",
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15,
                    ),
                    onTap: (LatLng position) async {
                      await _getAddressFromLatLng(position);
                    },
                    markers: Set<Marker>.of(_markers),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
              ],
            ),
    );
  }
}
