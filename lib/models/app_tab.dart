import 'package:cambioseguro/keys.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AppTab { change, history, account, menu }

class AppTabData {
  final String title;
  final IconData icon;
  final AppTab tab;
  final Key key;
  final int index;

  AppTabData(this.index, this.title, this.icon, this.tab, this.key);
}

List<AppTabData> appTabDataList() {
  return [
    AppTabData(0, "Nueva op.", FontAwesomeIcons.exchangeAlt, AppTab.change,
        AppKeys.changeTab),
    AppTabData(1, "Historial", FontAwesomeIcons.history, AppTab.history,
        AppKeys.historyTab),
    AppTabData(2, "Mi cuenta", FontAwesomeIcons.user, AppTab.account,
        AppKeys.accountTab),
    AppTabData(
        3, "Menú", FontAwesomeIcons.ellipsisH, AppTab.menu, AppKeys.menuTab),
  ];
}
