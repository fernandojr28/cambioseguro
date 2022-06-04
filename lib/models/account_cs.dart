class AccountCs {
  final bool isCci;
  final String id;
  final String name;
  final String ruc;
  final String typeAccount;
  final String typeCurrency;
  final String idBank;
  final String nameBank;
  final String shortNameBank;
  final String numberAccount;

  AccountCs({
    bool isCci,
    this.id,
    this.name,
    this.ruc,
    this.typeAccount,
    this.typeCurrency,
    this.idBank,
    this.nameBank,
    this.shortNameBank,
    this.numberAccount,
  }) : this.isCci = isCci ?? false;

  static AccountCs fromJson(dynamic json) {
    if (json == null) return AccountCs();
    return AccountCs(
      isCci: json['is_cci'],
      id: json['_id'],
      name: json['name'],
      ruc: json['ruc'],
      typeAccount: json['type_account'],
      typeCurrency: json['type_currency'],
      idBank: json['id_bank'],
      nameBank: json['name_bank'],
      shortNameBank: json['short_name_bank'],
      numberAccount: json['number_account'],
    );
  }
}
