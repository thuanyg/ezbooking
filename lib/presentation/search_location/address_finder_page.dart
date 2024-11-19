// First, add these dependencies to your pubspec.yaml:
// google_maps_flutter: ^2.5.0
// geocoding: ^2.1.1
// geolocator: ^10.1.0

import 'dart:io';

import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/services/google_map_service.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/data/models/location_result.dart';
import 'package:ezbooking/main.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddressFinderPage extends StatefulWidget {
  static String routeName = "AddressFinderPage";

  const AddressFinderPage({super.key});

  @override
  _AddressFinderPageState createState() => _AddressFinderPageState();
}

class _AddressFinderPageState extends State<AddressFinderPage> {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  final GoogleMapService _mapService = GoogleMapService();

  late GetLocationBloc locationBloc;

  LatLng _center = const LatLng(21.0227384, 105.8163641);
  String? selectedAddress = '';
  bool isLoading = true;
  List<Marker> _markers = <Marker>[];
  LocationResult? _locationResult;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<GetLocationBloc>(context);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        // If permission denied & user selected address => show selected address
        if (locationBloc.locationResult != null &&
            locationBloc.locationResult!.position != null) {
          _center = LatLng(
            locationBloc.locationResult!.position!.latitude,
            locationBloc.locationResult!.position!.longitude,
          );

          String? currentAddress = await _mapService.getFullAddress(
            lat: locationBloc.locationResult!.position!.latitude,
            long: locationBloc.locationResult!.position!.longitude,
          );

          _markers.add(
            Marker(
              markerId: const MarkerId('SomeId'),
              position: _center,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow:
                  InfoWindow(title: currentAddress ?? "Current Address"),
            ),
          );

          selectedAddress = currentAddress;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String? currentAddress = await _mapService.getFullAddress(
          lat: position.latitude, long: position.longitude);

      setState(() {
        _center = LatLng(position.latitude, position.longitude);

        _markers.add(Marker(
            markerId: const MarkerId('SomeId'),
            position: _center,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow:
                InfoWindow(title: currentAddress ?? "Current Address")));
        isLoading = false;
      });

      await _getAddressFromLatLng(_center);

      _locationResult = LocationResult(
        address: currentAddress,
        position: position,
      );
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    selectedAddress = await _mapService.getFullAddress(
      lat: position.latitude,
      long: position.longitude,
    );

    _locationResult = LocationResult(
      address: selectedAddress,
      position: Position(
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
      ),
    );
    setState(() {});
  }

  Future<void> _searchPlace(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng newPosition = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 15),
        );

        _getAddressFromLatLng(newPosition);

        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('SomeId'),
            position: newPosition,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: selectedAddress ?? "Current Address"),
          ),
        );
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
    return BlocListener<GetLocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoading) {
          DialogUtils.showLoadingDialog(context);
        }

        if (state is LocationSuccess && _locationResult != null) {
          // Hide Loading
          Navigator.pop(context);
          // Back to Home
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Address'),
          actions: [
            IconButton(
              onPressed: () {
                if(_locationResult != null){
                  context.read<GetLocationBloc>().emitLocation(_locationResult);
                }
              },
              icon: _locationResult != null ? Icon(
                Icons.done,
                color: AppColors.primaryColor,
              ) : const SizedBox.shrink(),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search location',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              _searchPlace(searchController.text);
                            }
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _searchPlace(value);
                        }
                      },
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
                        _markers.clear();
                        _markers.add(Marker(
                            markerId: const MarkerId('SomeId'),
                            position: position,
                            icon: BitmapDescriptor.defaultMarker,
                            infoWindow: InfoWindow(
                                title: selectedAddress ?? "Current Address")));
                      },
                      markers: Set<Marker>.of(_markers),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Address:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(selectedAddress ?? "No location was chosen!"),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
