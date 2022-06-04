import 'package:cambioseguro/models/bank_account.dart';
import 'package:cambioseguro/models/credential.dart';

class UserData {
  final String id;
  final String email;
  final String facebookId;
  final String googleId;
  final String additionalMail;
  final String name;
  final String fatherLastName;
  final String motherLastName;
  final String country;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phone;
  final String hash;
  final bool campaign;
  final String totalPoints;
  final List<BankAccount> bankAccounts;
  // si es false tiene que obligar.
  final bool validEmail;
  final bool status;
  final String comments;
  final bool politicallyExposed;
  final bool familyExposedPolitically;
  final bool exist;
  final bool isTimetOut;
  final bool isValidated;
  final bool isLoaded;
  final Credential credential;
  UserData({
    this.id,
    String email,
    this.facebookId,
    this.googleId,
    this.additionalMail,
    this.name,
    String fatherLastName,
    String motherLastName,
    this.country,
    this.accountType,
    this.createdAt,
    this.updatedAt,
    String phone,
    this.hash,
    this.campaign,
    this.totalPoints,
    this.bankAccounts,
    bool validEmail,
    this.status,
    this.comments,
    this.politicallyExposed,
    this.familyExposedPolitically,
    this.exist,
    this.isTimetOut,
    this.isValidated,
    this.isLoaded = false,
    this.credential,
  })  : this.fatherLastName = fatherLastName ?? '',
        this.motherLastName = motherLastName ?? '',
        this.email = email ?? '',
        this.phone = phone ?? '',
        this.validEmail = validEmail ?? true;

  static UserData fromJson(dynamic json) {
    if (json == null) return UserData();
    return UserData(
      isLoaded: true,
      email: json['email'],
      facebookId: json['facebook_id'],
      googleId: json['google_id'],
      validEmail: json['valid_email'],
      status: json['status'],
      comments: json['comments'],
      additionalMail: json['additional_mail'],
      name: json['name'],
      fatherLastName: json['father_last_name'],
      motherLastName: json['mother_last_name'],
      politicallyExposed: json['politically_exposed'],
      familyExposedPolitically: json['family_exposed_politically'],
      exist: json['exist'],
      isTimetOut: json['is_timet_out'],
      isValidated: json['is_validated'],
      country: json['country'],
      id: json['_id'],
      accountType: json['account_type'],
      phone: json['phone'] != null ? json['phone'].toString() : null,
      hash: json['hash'],
      campaign: json['campaign'],
      bankAccounts: json['bank_account'] == null
          ? []
          : (json['bank_account'] as List)
              .map((b) => BankAccount.fromJson(b))
              .toList(),
      credential: Credential.fromJson(json['document']),
    );
  }
}
