class Ubigeo {
  final String id;
  final String message;
  final String name;

  Ubigeo({
    String id,
    String message,
    String name,
  })  : this.id = id ?? '',
        this.message = message ?? '',
        this.name = name ?? '';

  static Ubigeo fromJson(Map<String, dynamic> json) {
    if (json == null) return Ubigeo();
    return Ubigeo(
      id: json['_id'],
      message: json['message'],
      name: json['name'],
    );
  }
}
