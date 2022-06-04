class Message {
  final String nameBank;
  final String message;

  Message({this.nameBank, this.message});

  static Message fromJson(dynamic json) {
    if (json == null) return Message();
    return Message(
      nameBank: json['name_bank'],
      message: json['message'],
    );
  }
}
