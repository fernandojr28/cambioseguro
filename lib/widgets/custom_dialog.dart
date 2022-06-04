import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
    this.onConfirm,
  });

  final String title, description, buttonText;
  final Image image;
  final VoidCallback onConfirm;

  _onConfirm(context) {
    if (onConfirm != null) onConfirm();
    Navigator.of(context).pop(); // To close the dialog
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          // margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomRaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () => _onConfirm(context),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          top: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            // radius: Consts.avatarRadius,
            child: Icon(AppIcons.requestError),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
