import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/user_data.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@immutable
class UserApp {
  final String id;
  final String email;
  // final bool complete;
  final String token;
  final String lastName;
  final String name;
  final bool emailStatus;
  final AccountType accountType;
  final bool isValidated;
  final UserData data;
  final bool hasData;

  UserApp({
    String id,
    String email,
    bool isTeamConfigured,
    // this.complete = false,
    String token,
    String lastName,
    String name,
    bool emailStatus,
    AccountType accountType,
    bool isValidated,
    bool hasData,
    this.data,
  })  : this.id = id ?? null,
        this.email = email ?? '',
        this.token = token ?? "",
        this.lastName = lastName ?? "",
        this.name = name ?? "",
        this.emailStatus = emailStatus ?? false,
        this.accountType = accountType ?? AccountType.Natural,
        this.isValidated = isValidated ?? false,
        this.hasData = hasData ?? false;

  UserApp copyWith({
    String id,
    String email,
    bool complete,
    String token,
    String lastName,
    String name,
    bool emailStatus,
    AccountType accountType,
    bool isValidated,
    UserData data,
    bool hasData,
  }) =>
      UserApp(
        id: id ?? this.id,
        email: email ?? this.email,
        // complete: complete ?? this.complete,
        token: token ?? this.token,
        lastName: lastName ?? this.lastName,
        name: name ?? this.name,
        emailStatus: emailStatus ?? this.emailStatus,
        accountType: accountType ?? this.accountType,
        isValidated: isValidated ?? this.isValidated,
        data: data ?? this.data,
        hasData: hasData ?? this.hasData,
      );

  static UserApp withToken(String token) => UserApp(token: token);

  static UserApp fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return UserApp(
      id: json['_id'],
      email: json['email'] as String,
      token: json['token'],
      lastName: json['last_name'],
      name: json['name'],
      emailStatus: json['email_status'],
      accountType: AccountType.values.firstWhere(
          (e) => e.toString() == 'AccountType.${json['account_type']}',
          orElse: () => AccountType.Natural),
      isValidated: json['is_validated'],
      hasData: json['has_data'],
      data: UserData.fromJson(json),
    );
  }

  dynamic toJson() => {
        'id': id,
        'email': email,
        'token': token,
        'last_name': lastName,
        'name': name,
        'email_status': emailStatus,
        'account_type': accountType.toString().split('.')[1],
        'is_validated': isValidated,
        // 'complete': complete,
      };
}
