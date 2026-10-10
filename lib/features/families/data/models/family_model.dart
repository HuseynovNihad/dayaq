import '../../domain/entities/family_entity.dart';

class FamilyModel extends FamilyEntity {
  const FamilyModel({
    required super.id,
    required super.familyRegisterId,
    required super.nameSurname,
    required super.birthday,
    required super.registerNumber,
    required super.region,
    required super.createdAt,
    required super.status,
    required super.phone,
    super.lat,
    super.lng,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: _parseInt(json['id']),
      familyRegisterId: _parseInt(json['family_register_id']),
      nameSurname: json['name_surname']?.toString() ?? '',
      birthday: _parseDate(json['birthday']),
      registerNumber: json['register_number']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      createdAt: _parseDate(json['created_at']),
      status: json['status']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();

    if (text.isEmpty) return null;

    return DateTime.tryParse(text);
  }
}
