import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/shared/custom_divider.dart';
import 'package:flutter/material.dart';

class ProcesingStep extends StatelessWidget {
  const ProcesingStep({Key key, @required this.changeRequest})
      : super(key: key);

  final ChangeRequest changeRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procesando pago'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium,
            Center(
              child: Image.asset(
                'assets/img/procesando.png',
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
                        Text('${changeRequest.codeRequest}',
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
                        'El pago a tu cuenta está siendo procesado en este momento. Una vez se haya realizado. recibirás un correo de notificación y podrás visualizar tu operación en el Historial de operaciones.'),
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
