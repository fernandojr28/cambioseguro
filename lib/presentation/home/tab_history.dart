import 'package:cambioseguro/helpers/handle_refresh.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/history.dart';
import 'package:cambioseguro/routes.dart';
import 'package:cambioseguro/widgets/confirm_account_alert.dart';
import 'package:cambioseguro/widgets/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class TabHistory extends StatefulWidget {
  const TabHistory({
    Key key,
    @required this.onInitHistory,
    @required this.historys,
  }) : super(key: key);

  final VoidCallback onInitHistory;
  final List<History> historys;

  @override
  _TabHistoryState createState() => _TabHistoryState();
}

class _TabHistoryState extends State<TabHistory> {
  @override
  void initState() {
    widget.onInitHistory();
    super.initState();
  }

  _navigateToDetail(String id) {
    StoreProvider.of<AppState>(context).dispatch(
        Navigator.of(context).pushNamed("${AppRoutes.historyDetail}/$id"));
  }

  Widget _buildEmptyMessage() {
    return ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
      Center(
        child: Text('No tiene operaciones para mostrar'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final boldStyle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
    List<History> items = List<History>.from(widget.historys.reversed);
    return Scaffold(
      floatingActionButton: WhatsappButton(),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F4F4),
        elevation: 0,
        title: Text(
          'Historial',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        bottom: ConfirmAccountAlert(
          currentUser: StoreProvider.of<AppState>(context).state.currentUser,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(context),
        child: items.isEmpty
            ? _buildEmptyMessage()
            : ListView.separated(
                padding: EdgeInsets.only(top: 16, bottom: 16, left: 16),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final History his = items[index];
                  return Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () => _navigateToDetail(his.id),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16, left: 16, bottom: 16, right: 24),
                          margin: EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                              color: his.cardColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(children: [
                                  Icon(
                                    his.titleIcon,
                                    color: his.titleColor,
                                  ),
                                  UIHelper.horizontalSpaceMiniSmall,
                                  Text(
                                    his.titleStatus(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: his.titleColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                              ),
                              UIHelper.verticalSpaceMedium,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Enviaste', style: boldStyle),
                                  Text('Recibiste', style: boldStyle)
                                ],
                              ),
                              UIHelper.verticalSpaceMiniSmall,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      '${his.amountPayIconText} ${his.amountPaid}',
                                      style: boldStyle.copyWith(fontSize: 18)),
                                  Text(
                                      '${his.amountPayableIconText} ${his.amountPayable}',
                                      style: boldStyle.copyWith(fontSize: 18))
                                ],
                              ),
                              UIHelper.verticalSpaceSmall,
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      DateFormat('E, d MMM y')
                                          .format(his.createdAt),
                                      style: boldStyle))
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        right: -20,
                        bottom: 0,
                        top: 0,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Color(0xff6E46E6),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _navigateToDetail(his.id);
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return UIHelper.verticalSpaceMedium;
                },
              ),
      ),
    );
  }
}
