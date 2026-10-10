class FamilyEntity {
  const FamilyEntity({
    required this.id,
    required this.familyRegisterId,
    required this.nameSurname,
    required this.birthday,
    required this.registerNumber,
    required this.region,
    required this.createdAt,
    required this.status,
    required this.phone,
    this.lat,
    this.lng,
  });

  final int id;
  final int familyRegisterId;
  final String nameSurname;
  final DateTime? birthday;
  final String registerNumber;
  final String region;
  final DateTime? createdAt;
  final String status;
  final String phone;
  final double? lat;
  final double? lng;
}
