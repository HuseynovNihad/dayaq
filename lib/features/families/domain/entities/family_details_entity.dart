class FamilyDetailsEntity {
  const FamilyDetailsEntity({
    required this.region,
    required this.members,
    required this.documents,
    required this.notes,
    required this.monthlyIncome,
    required this.rentEx,
    required this.communalEx,
    required this.chronicPatientEx,
    required this.monthlyDebtEx,
    required this.monthlyMedicalEx,
    this.lat,
    this.lng,
  });

  final String region;
  final List<FamilyDetailMemberEntity> members;
  final List<FamilyDetailDocumentEntity> documents;
  final List<FamilyDetailNoteEntity> notes;
  final num monthlyIncome;
  final num rentEx;
  final num communalEx;
  final num chronicPatientEx;
  final num monthlyDebtEx;
  final num monthlyMedicalEx;
  final double? lat;
  final double? lng;

  num get totalExpenses =>
      rentEx + communalEx + chronicPatientEx + monthlyDebtEx + monthlyMedicalEx;

  num get remainingIncome => monthlyIncome - totalExpenses;
}

class FamilyDetailMemberEntity {
  const FamilyDetailMemberEntity({
    required this.name,
    this.birthday,
    required this.familyMemberType,
    required this.address,
    required this.phone,
  });

  final String name;
  final DateTime? birthday;
  final String familyMemberType;
  final String address;
  final String phone;
}

class FamilyDetailDocumentEntity {
  const FamilyDetailDocumentEntity({required this.file});

  final String file;
}

class FamilyDetailNoteEntity {
  const FamilyDetailNoteEntity({required this.note});

  final String note;
}
