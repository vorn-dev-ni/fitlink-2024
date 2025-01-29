class GoogleAddress {
  final String address;
  final String country;

  GoogleAddress({required this.address, required this.country});

  @override
  String toString() {
    return 'Address: $address, Country: $country';
  }

  GoogleAddress copyWith({
    String? address,
    String? country,
  }) {
    return GoogleAddress(
      address: address ?? this.address,
      country: country ?? this.country,
    );
  }
}
