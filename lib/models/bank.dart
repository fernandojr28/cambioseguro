class Bank {
/*
{
            "cci": true,
            "status": true,
            "is_deleted": false,
            "_id": "5d573742335f0c1425f70f94",
            "name": "Agrobanco",
            "short_name": "Agrobanco",
            "text": "",
            "created_at": "2019-08-16T23:07:46.168Z",
            "updated_at": "2019-10-11T15:20:39.629Z",
            "__v": 0,
            "message_account": "",
            "message_request": "<p>Has seleccionado una cuenta de origen de otro banco Lima o Callao (que no es BCP ni Interbank). Ten en consideración que:</p><ul><li><strong>Si depositas el dinero en efectivo la solicitud será rechazada</strong> y te devolveremos el dinero, descontando las comisiones cobradas por el banco.</li><li><strong>Puedes usar cualquier canal de tu banco para realizar la transferencia.</strong> Ten en cuenta que el banco te podría cobrar una comisión por transferencia interbancaria y que los plazos para transferencias interbancarias son de 1 día útil.</li></ul>",
            "message_destiny": "<p>Has seleccionado una cuenta de destino de otro banco Lima o Callao (que no es BCP ni Interbank). Ten en consideración que:</p><ul><li>Los <strong>plazos para transferencias interbancarias son de 1 día útil</strong> como máximo.</li></ul>"
        }
*/

  final bool cci; //": true,
  final bool status; //": true,
  final bool isDeleted; //": false,
  final String id; //": "5d573742335f0c1425f70f94",
  final String name; //": "Agrobanco",
  final String shortName; //": "Agrobanco",
  final String text; //": "",
  final String createdAt; //": "2019-08-16T23:07:46.168Z",
  final String updatedAt; //": "2019-10-11T15:20:39.629Z",
  final int v; //": 0,
  final String messageAccount; //": ""
  final String messageRequest; //": "<p>Has sel
  final String messageDestiny;

  Bank({
    bool cci,
    bool status,
    bool isDeleted,
    String id,
    String name,
    String shortName,
    String text,
    String createdAt,
    String updatedAt,
    int v,
    String messageAccount,
    String messageRequest,
    String messageDestiny,
  })  : this.cci = cci ?? false,
        this.status = status ?? true,
        this.isDeleted = isDeleted ?? true,
        this.id = id ?? '',
        this.name = name ?? '',
        this.shortName = shortName ?? '',
        this.text = text ?? '',
        this.createdAt = createdAt ?? '',
        this.updatedAt = updatedAt ?? '',
        this.v = v ?? 0,
        this.messageAccount = messageAccount ?? '',
        this.messageRequest = messageRequest ?? '',
        this.messageDestiny = messageDestiny ?? '';

  static Bank fromJson(Map<String, dynamic> json) {
    if (json == null) return Bank();
    return Bank(
      cci: json['cci'],
      status: json['status'],
      isDeleted: json['is_deleted'],
      id: json['_id'],
      name: json['name'],
      shortName: json['short_name'],
      text: json['text'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      v: json['__v'],
      messageAccount: json['message_account'],
      messageRequest: json['message_request'],
      messageDestiny: json['message_destiny'],
    );
  }
}
