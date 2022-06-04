class BankAccount {
  final bool wasDeleted;
  final bool isOwner;
  final bool isOwnerAccount;
  final String id;
  final String bankAccountNumber;
  final String bank;
  final String bankAccountType;
  final String nameBank;
  final String currencyType;
  final String alias;
  final String nameUbigeo;
  final String ubigeo;
  final bool busy;

  BankAccount({
    bool wasDeleted,
    bool isOwner,
    bool isOwnerAccount,
    String id,
    String bankAccountNumber,
    String bank,
    String bankAccountType,
    String nameBank,
    String currencyType,
    String alias,
    String nameUbigeo,
    String ubigeo,
    this.busy = false,
  })  : this.wasDeleted = wasDeleted ?? false,
        this.isOwner = isOwner ?? false,
        this.isOwnerAccount = isOwnerAccount ?? false,
        this.id = id ?? '',
        this.bankAccountNumber = bankAccountNumber ?? '',
        this.bank = bank ?? '',
        this.bankAccountType = bankAccountType ?? '',
        this.nameBank = nameBank ?? '',
        this.currencyType = currencyType ?? '',
        this.alias = alias ?? '',
        this.nameUbigeo = nameUbigeo ?? '',
        this.ubigeo = ubigeo ?? '';

  static BankAccount fromJson(Map<String, dynamic> json) {
    if (json == null) return BankAccount();
    return BankAccount(
      wasDeleted: json['was_deleted'],
      isOwner: json['is_owner'],
      isOwnerAccount: json['is_owner_account'],
      id: json['_id'],
      bankAccountNumber: json['bank_account_number'],
      bank: json['bank'],
      bankAccountType: json['bank_account_type'],
      nameBank: json['name_bank'],
      currencyType: json['currency_type'],
      alias: json['alias'],
      nameUbigeo: json['name_ubigeo'],
      ubigeo: json['ubigeo'],
    );
  }

  static BankAccount initState() {
    return BankAccount();
  }

  BankAccount copyWith({
    bool wasDeleted,
    bool isOwner,
    bool isOwnerAccount,
    String id,
    String bankAccountNumber,
    String bank,
    String bankAccountType,
    String nameBank,
    String currencyType,
    String alias,
    String nameUbigeo,
    String ubigeo,
    bool busy,
  }) {
    return BankAccount(
      wasDeleted: wasDeleted ?? this.wasDeleted,
      isOwner: isOwner ?? this.isOwner,
      isOwnerAccount: isOwnerAccount ?? this.isOwnerAccount,
      id: id ?? this.id,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bank: bank ?? this.bank,
      bankAccountType: bankAccountType ?? this.bankAccountType,
      nameBank: nameBank ?? this.nameBank,
      currencyType: currencyType ?? this.currencyType,
      alias: alias ?? this.alias,
      nameUbigeo: nameUbigeo ?? this.nameUbigeo,
      ubigeo: ubigeo ?? this.ubigeo,
      busy: busy,
    );
  }
}
