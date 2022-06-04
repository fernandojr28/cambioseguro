import 'package:cambioseguro/containers/change_container.dart';
import 'package:cambioseguro/containers/history_container.dart';
import 'package:cambioseguro/containers/request_steps_container.dart';
import 'package:cambioseguro/containers/tab_selector.dart';
import 'package:cambioseguro/containers/user_data_container.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/presentation/home/tab_menu.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
    @required this.currentUser,
    @required this.activeTab,
    @required this.logout,
    @required this.onInitHome,
    @required this.changeRequest,
  }) : super(key: key);

  final UserApp currentUser;
  final int activeTab;
  final Function logout;
  final VoidCallback onInitHome;
  final ChangeRequest changeRequest;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    widget.onInitHome();
  }

  Widget get contain => Center(
          child: RaisedButton(
        child: Text("Logout ${widget.currentUser.token.substring(0, 5)}"),
        onPressed: widget.logout,
      ));

  @override
  Widget build(BuildContext context) {
    // print(widget.currentUser.data.);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Nueva operación"),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: <Widget>[
          if (widget.activeTab == 0)
            if (widget.changeRequest != null)
              RequestStepsContainer()
            else
              ChangeContainer(),
          if (widget.activeTab == 1) HistoryContainer(),
          if (widget.activeTab == 2) UserDataContainer(),
          if (widget.activeTab == 3) TabMenu(),
        ],
      ),
      bottomNavigationBar: TabSelector(),
    );
  }
}
