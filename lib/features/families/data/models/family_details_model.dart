import '../../domain/entities/family_details_entity.dart';

class FamilyDetailsModel extends FamilyDetailsEntity {
  const FamilyDetailsModel({
    required super.region,
    required super.members,
    required super.documents,
    required super.notes,
    required super.monthlyIncome,
    required super.rentEx,
    required super.communalEx,
    required super.chronicPatientEx,
    required super.monthlyDebtEx,
    required super.monthlyMedicalEx,
    super.lat,
    super.lng,
  });

  factory FamilyDetailsModel.fromJson(Map<String, dynamic> json) {
    return FamilyDetailsModel(
      region: json['region']?.toString() ?? '',
      members: _parseList(json['members'], FamilyDetailMemberModel.fromJson),
      documents: _parseList(
        json['documents'],
        FamilyDetailDocumentModel.fromJson,
      ),
      notes: _parseList(json['notes'], FamilyDetailNoteModel.fromJson),
      monthlyIncome: _parseNumber(json['monthly_income']),
      rentEx: _parseNumber(json['rent_ex']),
      communalEx: _parseNumber(json['communal_ex']),
      chronicPatientEx: _parseNumber(json['chronic_patient_ex']),
      monthlyDebtEx: _parseNumber(json['monthly_debt_ex']),
      monthlyMedicalEx: _parseNumber(json['monthly_medical_ex']),
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
    );
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (value is! List) return <T>[];

    return value
        .whereType<Map>()
        .map((item) => parser(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  static num _parseNumber(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class FamilyDetailMemberModel extends FamilyDetailMemberEntity {
  const FamilyDetailMemberModel({
    required super.name,
    super.birthday,
    required super.familyMemberType,
    required super.address,
    required super.phone,
  });

  factory FamilyDetailMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyDetailMemberModel(
      name: json['name']?.toString() ?? '',
      birthday: FamilyDetailsModel._parseDate(json['birthday']),
      familyMemberType: json['family_member_type']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

class FamilyDetailDocumentModel extends FamilyDetailDocumentEntity {
  const FamilyDetailDocumentModel({required super.file});

  factory FamilyDetailDocumentModel.fromJson(Map<String, dynamic> json) {
    return FamilyDetailDocumentModel(file: json['file']?.toString() ?? '');
  }
}

class FamilyDetailNoteModel extends FamilyDetailNoteEntity {
  const FamilyDetailNoteModel({required super.note});

  factory FamilyDetailNoteModel.fromJson(Map<String, dynamic> json) {
    return FamilyDetailNoteModel(note: json['note']?.toString() ?? '');
  }
}
