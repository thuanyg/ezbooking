class PlaceDetails {
  final String? street;
  final String? subLocality;
  final String? locality;
  final String? administrativeArea;
  final String? postalCode;
  final String? country;
  final String? fullAddress;
  final String? error;

  PlaceDetails({
    this.street,
    this.subLocality,
    this.locality,
    this.administrativeArea,
    this.postalCode,
    this.country,
    this.fullAddress,
    this.error,
  });

  bool get isSuccess => error == null;
}