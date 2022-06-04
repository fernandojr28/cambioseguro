import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/containers/bottom_navigation.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TabSelector extends StatelessWidget {
  TabSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) {
        return _ViewModel.fromStore(store, context);
      },
      builder: (context, vm) {
        return BottomNavigation(
          activeTab: vm.activeTab,
          onTabSelected: vm.onTabSelected,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  final int activeTab;
  final Function(int) onTabSelected;

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    return _ViewModel(
      activeTab: store.state.activeTab,
      onTabSelected: (int tab) {
        store.dispatch(UpdateTabAction((tab)));
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeTab == other.activeTab;

  @override
  int get hashCode => activeTab.hashCode;
}
