import 'package:cambioseguro/helpers/handle_refresh.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/routes.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/custom_divider.dart';
import 'package:cambioseguro/widgets/confirm_account_alert.dart';
import 'package:cambioseguro/widgets/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TabMenu extends StatelessWidget {
  Widget _buildListTile({String title, IconData iconData, VoidCallback onTap}) {
    return ListTile(
      leading: Icon(iconData, color: primaryColor),
      title: Text(title, style: TextStyle(color: primaryColor)),
      onTap: onTap,
    );
  }

  _navigateToTab(context, int tab) {
    // if (tab == 0)
    //   StoreProvider.of<AppState>(context).dispatch(UpdateTabAction((tab)));

    StoreProvider.of<AppState>(context).dispatch(UpdateTabAction((tab)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WhatsappButton(),
      appBar: AppBar(
        title: Text('Menú'),
        centerTitle: true,
        bottom: ConfirmAccountAlert(
          currentUser: StoreProvider.of<AppState>(context).state.currentUser,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(context),
        child: ListView(
          padding: EdgeInsets.only(left: 24, top: 20, right: 24),
          children: <Widget>[
            _buildListTile(
              iconData: Icons.compare_arrows,
              title: 'Nueva operación',
              onTap: () => _navigateToTab(context, 0),
            ),
            _buildListTile(
              iconData: Icons.history,
              title: 'Historial',
              onTap: () => _navigateToTab(context, 1),
            ),
            _buildListTile(
              iconData: AppIcons.user,
              title: 'Mi cuenta',
              onTap: () => _navigateToTab(context, 2),
            ),
            _buildListTile(
                iconData: Icons.branding_watermark,
                title: 'Mis cuentas bancarias',
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(
                      Navigator.of(context).pushNamed(AppRoutes.bankAccounts));
                }),
            _buildListTile(
                iconData: AppIcons.user,
                title: 'Cambiar contraseña',
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(
                      Navigator.of(context)
                          .pushNamed(AppRoutes.changePassword));
                }),
            CustomDivider(
              color: Colors.black26,
            ),
            _buildListTile(
                iconData: Icons.exit_to_app,
                title: 'Cerrar sesión',
                onTap: () => StoreProvider.of<AppState>(context)
                    .dispatch(LogoutRequestAction())),
          ],
        ),
      ),
    );
  }
}
