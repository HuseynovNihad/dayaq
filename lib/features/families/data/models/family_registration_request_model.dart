import 'package:dio/dio.dart';

class FamilyRegistrationRequestModel {
  const FamilyRegistrationRequestModel({
    required this.name,
    required this.surname,
    required this.fin,
    required this.seriaNumber,
    required this.phone,
    required this.regionId,
    required this.address,
    required this.familyStatus,
    this.note,
    this.salary = 0,
    this.physicalLabor = 0,
    this.sosial = 0,
    this.scholarship = 0,
    this.financialAssistance = 0,
    this.charity = 0,
    this.individualAssistance = 0,
    this.education = 0,
    this.educationEx = 0,
    this.rentEx = 0,
    this.electricEx = 0,
    this.waterEx = 0,
    this.gasEx = 0,
    this.heatingSystemEx = 0,
    this.communicationEx = 0,
    this.lat,
    this.lng,
    this.nameMember = const [],
    this.surnameMember = const [],
    this.statusMember = const [],
    this.birthMember = const [],
    this.salaryMember = const [],
    this.documents = const [],
    this.title = const [],
  }) : assert(
         nameMember.length == surnameMember.length &&
             nameMember.length == statusMember.length &&
             nameMember.length == birthMember.length &&
             nameMember.length == salaryMember.length,
         'Ailə üzvlərinin bütün array-ləri eyni uzunluqda olmalıdır.',
       ),
       assert(
         documents.length == title.length,
         'Sənədlər və başlıqların sayı eyni olmalıdır.',
       );

  // ADDIM 1 — Şəxsi məlumatlar
  final String name;
  final String surname;
  final String fin;
  final String seriaNumber;
  final String phone;
  final int regionId;
  final String address;
  final int familyStatus;
  final String? note;

  // ADDIM 4 — Gəlirlər
  final int salary;
  final int physicalLabor;
  final int sosial;
  final int scholarship;
  final int financialAssistance;
  final int charity;
  final int individualAssistance;
  final int education;

  // ADDIM 5 — Xərclər
  final int educationEx;
  final int rentEx;
  final int electricEx;
  final int waterEx;
  final int gasEx;
  final int heatingSystemEx;
  final int communicationEx;

  // ADDIM 2 — GPS
  // Swagger: number($string)
  final String? lat;
  final String? lng;

  // ADDIM 3 — Ailə üzvləri
  final List<String> nameMember;
  final List<String> surnameMember;
  final List<int> statusMember;
  final List<String> birthMember;
  final List<num> salaryMember;

  // ADDIM 6 — Sənədlər
  // Lokal PDF fayllarının yolları; title ilə sıra uyğunluğu qorunur.
  final List<String> documents;
  final List<String> title;

  Future<FormData> toFormData() async {
    if (documents.length != title.length) {
      throw const FormatException('Sənəd və başlıq sayı eyni olmalıdır.');
    }
    if (nameMember.length != surnameMember.length ||
        nameMember.length != statusMember.length ||
        nameMember.length != birthMember.length ||
        nameMember.length != salaryMember.length) {
      throw const FormatException('Ailə üzvü məlumatları uyğun deyil.');
    }
    final formData = FormData();
    void field(String key, Object value) {
      formData.fields.add(MapEntry(key, value.toString()));
    }

    void arrayField(String key, Iterable<Object> values) {
      for (final value in values) {
        field('$key[]', value);
      }
    }

    field('name', name.trim());
    field('surname', surname.trim());
    field('fin', fin.trim().toUpperCase());
    field('seria_number', seriaNumber.trim().toUpperCase());
    field('phone', phone.trim());
    field('region_id', regionId);
    field('address', address.trim());
    field('family_status', familyStatus);
    if (note != null && note!.trim().isNotEmpty) field('note', note!.trim());
    field('salary', salary);
    field('physical_labor', physicalLabor);
    field('sosial', sosial);
    field('scholarship', scholarship);
    field('financial_assistance', financialAssistance);
    field('charity', charity);
    field('individual_assistance', individualAssistance);
    field('education', education);
    field('education_ex', educationEx);
    field('rent_ex', rentEx);
    field('electric_ex', electricEx);
    field('water_ex', waterEx);
    field('gas_ex', gasEx);
    field('heating_system_ex', heatingSystemEx);
    field('communication_ex', communicationEx);
    if (lat != null && lat!.trim().isNotEmpty) field('lat', lat!.trim());
    if (lng != null && lng!.trim().isNotEmpty) field('lng', lng!.trim());
    arrayField('name_member', nameMember);
    arrayField('surname_member', surnameMember);
    arrayField('status_member', statusMember);
    arrayField('birth_member', birthMember);
    arrayField('salary_member', salaryMember);
    for (var i = 0; i < documents.length; i++) {
      final path = documents[i];
      if (!path.toLowerCase().endsWith('.pdf')) {
        throw const FormatException('Yalnız PDF sənədləri göndərilə bilər.');
      }
      final filename = Uri.file(path).pathSegments.last;
      formData.files.add(
        MapEntry(
          'documents[]',
          await MultipartFile.fromFile(path, filename: filename),
        ),
      );
      field('title[]', title[i].trim());
    }
    return formData;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'surname': surname.trim(),
      'fin': fin.trim().toUpperCase(),
      'seria_number': seriaNumber.trim().toUpperCase(),
      'phone': phone.trim(),
      'region_id': regionId,
      'address': address.trim(),
      'family_status': familyStatus,

      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),

      // Gəlirlər
      'salary': salary,
      'physical_labor': physicalLabor,
      'sosial': sosial,
      'scholarship': scholarship,
      'financial_assistance': financialAssistance,
      'charity': charity,
      'individual_assistance': individualAssistance,
      'education': education,

      // Xərclər
      'education_ex': educationEx,
      'rent_ex': rentEx,
      'electric_ex': electricEx,
      'water_ex': waterEx,
      'gas_ex': gasEx,
      'heating_system_ex': heatingSystemEx,
      'communication_ex': communicationEx,

      // GPS
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,

      // Ailə üzvləri
      'name_member': nameMember,
      'surname_member': surnameMember,
      'status_member': statusMember,
      'birth_member': birthMember,
      'salary_member': salaryMember,

      // Sənədlər
      'documents': documents,
      'title': title,
    };
  }
}
