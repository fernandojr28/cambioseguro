import 'package:cambioseguro/enums/enum.dart';
import 'package:intl/intl.dart';

class ClientFormData {
  final String id;
  final String additionalMail;
  final String name;
  final String fatherLastName;
  final String motherLastName;
  final String country;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phone;
  final String hash;
  final bool campaign;
  final String totalPoints;
  final String credentialType;
  final String credentialNumber;
  final bool politicallyExposed;
  final DateTime docDateCe;
  final bool familyExposedPolitically;
  final String docImageP;
  final String namePep;
  final String lastNamePep;
  final AccountType accountType;
  final String ruc; //":"10468238383",
  final String businessName; //":"hola sac",
  final String sbsRequirement; //":"no hay",
  final String typeRepresentation; //":"poder"

  ClientFormData({
    this.id,
    String email,
    this.additionalMail,
    String docImageP,
    this.name,
    String fatherLastName,
    String motherLastName,
    this.country,
    this.accountType = AccountType.Natural,
    this.createdAt,
    this.updatedAt,
    String phone,
    this.hash,
    this.campaign,
    this.totalPoints,
    this.politicallyExposed = false,
    this.familyExposedPolitically = false,
    this.credentialType,
    this.credentialNumber,
    this.docDateCe,
    this.namePep,
    this.lastNamePep,
    this.ruc,
    this.businessName,
    this.sbsRequirement,
    this.typeRepresentation,
  })  : this.fatherLastName = fatherLastName ?? '',
        this.motherLastName = motherLastName ?? '',
        this.phone = phone ?? '',
        this.docImageP = docImageP ?? '';

  ClientFormData copyWith({
    String id,
    String name,
    String fatherLastName,
    String motherLastName,
    String country,
    String accountType,
    DateTime createdAt,
    DateTime updatedAt,
    String phone,
    String hash,
    bool campaign,
    String totalPoints,
    bool politicallyExposed,
    bool familyExposedPolitically,
    bool exist,
    bool isTimetOut,
    bool isValidated,
    String credentialType,
    String credentialNumber,
    String namePep,
    String lastNamePep,
    String ruc,
    String businessName,
    String sbsRequirement,
    String typeRepresentation,
    DateTime docDateCe,
    String docImageP,
  }) {
    return ClientFormData(
      id: id ?? this.id,
      additionalMail: additionalMail ?? this.additionalMail,
      name: name ?? this.name,
      fatherLastName: fatherLastName ?? this.fatherLastName,
      motherLastName: motherLastName ?? this.motherLastName,
      country: country ?? this.country,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phone: phone ?? this.phone,
      hash: hash ?? this.hash,
      campaign: campaign ?? this.campaign,
      totalPoints: totalPoints ?? this.totalPoints,
      politicallyExposed: politicallyExposed ?? this.politicallyExposed,
      familyExposedPolitically:
          familyExposedPolitically ?? this.familyExposedPolitically,
      credentialType: credentialType ?? this.credentialType,
      credentialNumber: credentialNumber ?? this.credentialNumber,
      namePep: namePep ?? this.namePep,
      lastNamePep: lastNamePep ?? this.lastNamePep,
      ruc: ruc ?? this.ruc,
      businessName: businessName ?? this.businessName,
      sbsRequirement: sbsRequirement ?? this.sbsRequirement,
      typeRepresentation: typeRepresentation ?? this.typeRepresentation,
      docDateCe: docDateCe ?? this.docDateCe,
      docImageP: docImageP ?? this.docImageP,
    );
  }

  Map<String, dynamic> _makeDocument() {
    final Map<String, dynamic> data = {
      'type': credentialType,
      'number': credentialNumber
    };
    if (credentialType == 'CE') // data['date_ce'] = docDateCe;
      data['date_ce'] = DateFormat('y-MM-d').format(docDateCe);
    if (credentialType == 'PASAPORTE') data['image_p'] = docImageP;
    return data;
  }

  Map toJson() {
    Map data = {
      "name": name,
      "father_last_name": fatherLastName,
      "mother_last_name": motherLastName,
      "document": _makeDocument(),
      "phone": phone,
      "country": 'PER',
      "politically_exposed": politicallyExposed,
      "family_exposed_politically": familyExposedPolitically,
    };

    if (accountType == AccountType.Juridica)
      data = {
        ...data,
        "ruc": ruc,
        "business_name": businessName,
        "sbs_requirement": sbsRequirement,
        "type_representation": typeRepresentation
      };
    if (familyExposedPolitically)
      data = {
        ...data,
        "name_pep": namePep,
        "last_name_pep": lastNamePep,
      };
    return data;
  }
}

List typeRepresentationList = ['poder', 'mandato', 'registral'];
