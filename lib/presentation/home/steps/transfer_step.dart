import 'package:cambioseguro/helpers/show_confirm_dialog.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/models.dart';
// import 'package:cambioseguro/presentation/home/steps/operation_list_item_old.dart';
import 'package:cambioseguro/presentation/home/steps/operation_list_item.dart';
import 'package:cambioseguro/presentation/home/steps/operation_single_item.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/shared/custom_divider.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';

// import 'operation_item.dart';

class TransferStep extends StatefulWidget {
  @override
  _TransferStepState createState() => _TransferStepState();
}

class _TransferStepState extends State<TransferStep>
    with TickerProviderStateMixin {
  TabController _tabController;
  final List<RequestPutData> requestPutData = [];

  int tabIndex = 0;
  String codeText = "";
  // Map<int, OperationItemModel> operations = HashMap();
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_changeIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  _changeIndex() {
    tabIndex = _tabController.index;
    setState(() {});
  }

  Widget _buildTabBar() {
    return Container(
      height: 40,
      // width: 275,
      decoration: BoxDecoration(
          //This is for bottom border that is needed
          border: Border(
              bottom: BorderSide(
        color: Colors.black12,
        width: 3,
      ))),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        indicator: UnderlineTabIndicator(
            insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -3),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 3)),
        unselectedLabelColor: Colors.black54,
        indicatorWeight: 4,
        tabs: <Widget>[
          Tab(
            text: "Una transferencia",
          ),
          Tab(
            text: "Varias transferencias",
          )
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title) {
    return Stack(
      children: <Widget>[
        Container(
          height: 44,
          child: CustomDivider(
            color: Color(0XFFFFC23B),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.center,
            child: FormSubmitButton(
              color: Color(0XFFFFC23B),
              textColor: Colors.white,
              onPressed: () {},
              child: Text("$title"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankNumber(ChangeRequest changeRequest) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.black12,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: SelectableText(
                "${changeRequest.accountCs.numberAccount}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            FlatButton.icon(
              label: Text(
                'Copiar',
                style: TextStyle(color: primaryColor),
              ),
              icon: Icon(
                Icons.content_copy,
                color: primaryColor,
              ),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: changeRequest.accountCs.numberAccount));
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Copiado a Portapapeles"),
                ));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$title"),
          UIHelper.horizontalSpaceSmall,
          Expanded(
            child: Text(
              "$value",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          // Spacer()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = StoreProvider.of<AppState>(context).state;
    final ChangeRequest changeRequest = state.changeRequest;
    // if (changeRequest.accountCs.idBank == null) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transferencia'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(24), children: <Widget>[
        Center(
          child: Text(
              'Para seguir con tu solicitud realiza la transferencia bancaria.'),
        ),
        if (changeRequest.messages.isNotEmpty) ...[
          UIHelper.verticalSpaceMedium,
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0XFFFFC23B), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xFFFFF6E1),
              ),
              padding: EdgeInsets.all(8),
              child: Html(data: "${changeRequest.messages[0].message}"),
            ),
          ),
        ],
        UIHelper.verticalSpaceMedium,
        _buildStepTitle('PASO 1'),
        Center(
          child: Text('Recuerda que no aceptamos depósitos en efectivo.'),
        ),
        UIHelper.verticalSpaceSmall,
        Center(
          child: RichText(
            text: TextSpan(
              text: 'Para recibir tus ',
              children: [
                TextSpan(
                    text:
                        '${changeRequest.amountPayableIconText} ${changeRequest.amountPayableFixed2}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(text: ', transfiere '),
                TextSpan(
                    text:
                        '${changeRequest.amountPaidIconText} ${changeRequest.amountPaidFixed2}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(text: ' a la siguiente cuenta.')
              ],
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        UIHelper.verticalSpaceMedium,
        Text('Cuenta'),
        UIHelper.verticalSpaceSmall,
        _buildBankNumber(state.changeRequest),
        UIHelper.verticalSpaceSmall,
        _buildRow('Monto a transferir',
            "${changeRequest.amountPaidIconText} ${changeRequest.amountPaid}"),
        UIHelper.verticalSpaceMiniSmall,
        _buildRow('Banco', changeRequest.accountCs.shortNameBank),
        UIHelper.verticalSpaceMiniSmall,
        _buildRow('Nombre', changeRequest.accountCs.name),
        UIHelper.verticalSpaceMiniSmall,
        _buildRow('Tipo', changeRequest.accountCs.typeAccount),
        UIHelper.verticalSpaceMiniSmall,
        _buildRow('Moneda', changeRequest.accountCs.typeCurrency),
        UIHelper.verticalSpaceSmall,
        _buildStepTitle('PASO 2'),
        UIHelper.verticalSpaceSmall,
        _buildTabBar(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RichText(
            text: TextSpan(
                text: 'Ubica el ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text:
                          'número de operación de la transfererncia realizada en tu banco ',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: 'y escríbelo aquí:')
                ]),
          ),
        ),
        if (_tabController.index == 0) OperationSingleItem(),
        if (_tabController.index == 1) OperationListItem(),
        Divider(),
        Center(
          child: FlatButton(
            onPressed: () async {
              bool isConfirm = await onShowConfirmDialog(context);
              if (isConfirm)
                return StoreProvider.of<AppState>(context)
                    .dispatch(RequestChangeDeleteRequestAction());
            },
            child: Text(
              'Cancelar operación',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        )
      ]),
    );
  }
}
