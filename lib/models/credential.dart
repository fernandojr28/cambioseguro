import 'package:cambioseguro/enums/enum.dart';

class Credential {
  final String type;
  final String number;
  final DateTime dateCe;
  final String imageUrl;

  Credential({this.type, this.number, String dateCe, String imageUrl})
      : this.dateCe = dateCe != null
            ? DateTime.parse(dateCe)
            : DateTime.parse(INIT_DATETIME),
        this.imageUrl = imageUrl ?? '';

  static Credential fromJson(Map json) {
    if (json == null) return Credential();
    return Credential(
      type: json['type'],
      number: json['number'],
      dateCe: json['date_ce'],
      imageUrl: json['image_p'],
    );
  }
}
