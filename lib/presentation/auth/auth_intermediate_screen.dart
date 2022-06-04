import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/routes.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/app_logo.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AuthIntermediateScreen extends StatelessWidget {
  AuthIntermediateScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AppLogo(),
            UIHelper.verticalSpaceLarge,
            UIHelper.verticalSpaceMedium,
            Text(
              "Seleccione el tipo de usuario",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.grey),
            ),
            UIHelper.verticalSpaceLarge,
            FormSubmitButton(
              onPressed: () => StoreProvider.of<AppState>(context).dispatch(
                  Navigator.of(context)
                      .pushReplacementNamed("${AppRoutes.auth}#0")),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    AppIcons.user,
                    color: Colors.white,
                    size: 20,
                  ),
                  UIHelper.horizontalSpaceSmall,
                  Text("Personal", style: buttonStyle)
                ],
              ),
            ),
            UIHelper.verticalSpaceMedium,
            UIHelper.verticalSpaceSmall,
            FormSubmitButton(
              onPressed: () => StoreProvider.of<AppState>(context).dispatch(
                  Navigator.of(context)
                      .pushReplacementNamed("${AppRoutes.auth}#1")),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    AppIcons.business,
                    color: Colors.white,
                    size: 20,
                  ),
                  UIHelper.horizontalSpaceMedium,
                  Text("Empresarial", style: buttonStyle)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
