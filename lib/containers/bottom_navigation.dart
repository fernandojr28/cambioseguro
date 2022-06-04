import 'package:cambioseguro/models/app_tab.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/widgets/ClipShadowPath.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {Key key, @required this.activeTab, @required this.onTabSelected})
      : super(key: key);

  final int activeTab;
  final Function(int) onTabSelected;
  void _onItemTapped(int index) {
    return onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
      shadow:
          Shadow(blurRadius: 10, offset: Offset(0, -2), color: Colors.black12),
      clipper: ShapeBorderClipper(
          shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(45),
          topLeft: Radius.circular(45),
        ),
      )),
      child: BottomNavigationBar(
        elevation: 8,
        backgroundColor: Colors.white,
        currentIndex: activeTab,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.8),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          for (var tab in appTabDataList())
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              title: Text(tab.title),
            ),
        ],
      ),
    );
  }
}
