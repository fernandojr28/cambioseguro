// typedef void VoidCallback();

typedef void ErrorCallback(dynamic error);

enum AccountType { Natural, Juridica }

// enum RequestType {}

const String MIN_DATETIME = '1930-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';
const String DATEFORMAT = 'dd-MMMM-yyyy';

enum ChangeRequestStatus {
  pendiente,
  usuario, // Validación
  transferencia, // Validación
  cambio, // Procesando pago
  finalizado, // Finalizado
  rechazado, // Finalizado
  cancelado, // Finalizado
}

List<Map> credentialTypes(bool addRuc) {
  List<Map> items = [
    {'id': 'DNI', 'title': 'DNI'},
    {'id': 'CE', 'title': 'Carnet de extranjería'},
    {'id': 'PASAPORTE', 'title': 'Pasaporte'},
  ];
  if (addRuc) items.add({'id': 'RUC', 'title': 'RUC'});
  return items;
}

final currencyType = [
  {'id': 'Soles', 'title': 'S/ - Soles'},
  {'id': 'Dolares', 'title': 'US\$ - Dólares Americanos'}
];

enum RequestType { compra, venta }
