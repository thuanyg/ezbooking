class Organizer {
  String? name, email, address, phoneNumber, facebook, youtube, website;

  Organizer({
    this.name,
    this.email,
    this.address,
    this.phoneNumber,
    this.facebook,
    this.website,
    this.youtube,
  });

  // From JSON
  factory Organizer.fromJson(Map<String, dynamic>? json) {
    return Organizer(
      name: json?['name'] as String?,
      email: json?['email'] as String?,
      address: json?['address'] as String?,
      phoneNumber: json?['phoneNumber'] as String?,
      facebook: json?['facebook'] as String?,
      youtube: json?['youtube'] as String?,
      website: json?['website'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'facebook': facebook,
      'youtube': youtube,
      'website': website,
    };
  }
}
