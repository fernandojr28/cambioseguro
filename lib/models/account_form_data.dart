import 'package:intl/intl.dart';

class AccountFormData {
  final String ubigeo;
  final String bank;
  final String bankAccountType;
  final String currencyType;
  final String alias;
  final bool isOwner;
  final String bankAccountNumber;
  final String docType;
  final String docNumber;
  final String docImageP;
  final DateTime docDateCe;
  final String nameThird;
  final String fatherLastNameThird;
  final String motherLastNameThird;
  final String businessName;

  AccountFormData({
    this.ubigeo,
    this.bank,
    this.bankAccountType,
    this.currencyType,
    this.alias,
    this.isOwner,
    this.bankAccountNumber,
    this.nameThird,
    this.fatherLastNameThird,
    this.motherLastNameThird,
    this.businessName,
    this.docType,
    this.docNumber,
    this.docImageP,
    this.docDateCe,
  });

  Map toJson() => {
        'ubigeo': this.ubigeo,
        'bank': this.bank,
        'bank_account_type': this.bankAccountType.toLowerCase(),
        'currency_type': this.currencyType,
        'alias': this.alias,
        'is_owner': this.isOwner,
        'bank_account_number': this.bankAccountNumber,
        'name_third': this.nameThird,
        'father_last_name_third': this.fatherLastNameThird,
        'mother_last_name_third': this.motherLastNameThird,
        'document': _makeDocument(),
        'business_name': this.businessName,
      };
  Map<String, dynamic> _makeDocument() {
    final Map<String, dynamic> data = {'type': docType, 'number': docNumber};
    if (docType == 'CE')
      data['date_ce'] = DateFormat('y-mm-d').format(docDateCe);
    if (docType == 'PASAPORTE') data['image_p'] = docImageP;
    return data;
  }

  bool isValid() {
    bool baseValid = ubigeo.trim().isNotEmpty &&
        bank.trim().isNotEmpty &&
        bankAccountType.trim().isNotEmpty &&
        alias.trim().isNotEmpty &&
        bankAccountNumber.trim().isNotEmpty;

    if (docType == null) return baseValid;

    if (docType == 'DNI') return baseValid && docNumber.trim().isNotEmpty;
    if (docType == 'CE')
      return baseValid &&
          nameThird.trim().isNotEmpty &&
          fatherLastNameThird.trim().isNotEmpty &&
          motherLastNameThird.trim().isNotEmpty &&
          docNumber.trim().isNotEmpty &&
          docDateCe != null;
    if (docType == 'PASAPORTE')
      return baseValid &&
          nameThird.trim().isNotEmpty &&
          fatherLastNameThird.trim().isNotEmpty &&
          motherLastNameThird.trim().isNotEmpty &&
          docNumber.trim().isNotEmpty &&
          docImageP.trim().isNotEmpty;
    if (docType == 'RUC')
      return baseValid &&
          businessName.trim().isNotEmpty &&
          docNumber.trim().isNotEmpty;
    return false;
  }
}
