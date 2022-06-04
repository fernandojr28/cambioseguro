import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:flutter/material.dart';

class ConfirmAccountAlert extends StatelessWidget
    implements PreferredSizeWidget {
  const ConfirmAccountAlert({Key key, @required this.currentUser})
      : super(key: key);

  final UserApp currentUser;
  final indicatorWeight = 2.0;
  final double _kTabHeight = 80;

  @override
  Widget build(BuildContext context) {
    if (currentUser.data.validEmail) return Container();

    return Container(
      height: _kTabHeight,
      color: Color(0xFFFF6961),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(AppIcons.inbox, color: Colors.white),
            UIHelper.horizontalSpaceSmall,
            Expanded(
              child: Text(
                "Tu cuenta aún no ha sido validada, por favor revisa tu correo para validarla. ${currentUser.email}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    if (currentUser.data.validEmail) return Size(0, 0);
    return Size.fromHeight(_kTabHeight + indicatorWeight);
  }
}
