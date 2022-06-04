import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/shared/custom_divider.dart';
import 'package:flutter/material.dart';

class ValidationStep extends StatelessWidget {
  const ValidationStep({Key key, @required this.changeRequest})
      : super(key: key);

  final ChangeRequest changeRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium,
            Center(
              child: Image.asset(
                'assets/img/validando.png',
                height: 100,
              ),
            ),
            UIHelper.verticalSpaceLarge,
            Card(
              // margin: EdgeInsets.all(24),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Código de solicitud'),
                        Text("${changeRequest.codeRequest}",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.teal,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    CustomDivider(
                      color: Colors.black26,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Text(
                        'Estamos validando la transferencia que realizaste. Recibirás un correo de confirmación en un plazo promedio de 15 minutos.'),
                    Text(
                        'De existir algún inconveniente, te lo comunicaremos a través del teléfono de contacto registrado en tu cuenta.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
