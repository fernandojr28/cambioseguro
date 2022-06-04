import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappButton extends StatelessWidget {
  const WhatsappButton({Key key, this.isFloating = true}) : super(key: key);

  final bool isFloating;

  static String phone = '51924901611';
  static String textWsp = '_*Solicitud App*_ \ Hola, ';
  static Color backgroundColor = Color(0xFF128C7E);

  String get whatsappUrl => "https://wa.me/$phone?text=$textWsp";

  void _openWsp() async {
    await canLaunch(whatsappUrl) ? launch(whatsappUrl) : print("Not support");
  }

  @override
  Widget build(BuildContext context) {
    if (isFloating)
      return FloatingActionButton(
        onPressed: _openWsp,
        child: Icon(Icons.chat),
        backgroundColor: backgroundColor,
      );

    return FormSubmitButton(
      onPressed: _openWsp,
      color: backgroundColor,
      textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.chat),
          UIHelper.horizontalSpaceSmall,
          Text(
            'Iniciar por WhatsApp',
            // style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
