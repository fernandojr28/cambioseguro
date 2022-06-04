import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/helpers/handle_refresh.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/presentation/bank_account_screen.dart';
import 'package:cambioseguro/presentation/user_data_screen.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/confirm_account_alert.dart';
import 'package:cambioseguro/widgets/count_down_timer.dart';
import 'package:cambioseguro/widgets/coupon_card.dart';
import 'package:cambioseguro/widgets/custom_dialog.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:cambioseguro/widgets/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:cambioseguro/helpers/helpers.dart' as helpers;
import 'package:flutter_redux/flutter_redux.dart';

class TabChange extends StatefulWidget {
  const TabChange({
    Key key,
    @required this.bankAccounts,
    @required this.onRequestChange,
    @required this.currentUser,
    @required this.requestData,
  }) : super(key: key);

  final List<BankAccount> bankAccounts;
  final Function(RequestData, VoidCallback, ErrorCallback) onRequestChange;
  final UserApp currentUser;
  final RequestData requestData;
  @override
  _TabChangeState createState() => _TabChangeState();
}

class _TabChangeState extends State<TabChange> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _textPENController;
  TextEditingController _textUSDController;

  RequestData get requestData => widget.requestData;

  bool isValidate;
  @override
  initState() {
    super.initState();
    isValidate = true;
    _textPENController =
        TextEditingController(text: "${requestData.amountPayableMin}");
    _textUSDController =
        TextEditingController(text: "${requestData.amountPayableTotal}");
  }

  @override
  void didUpdateWidget(TabChange oldWidget) {
    if (widget.bankAccounts != oldWidget.bankAccounts) {
      StoreProvider.of<AppState>(context).dispatch(
        UpdateRequestDataRequestAction(
          requestData.copyWith(bankAccount: null, bankAccountOrigin: null),
        ),
      );
    }
    if (widget.requestData != oldWidget.requestData) {
      if (!widget.requestData.onEditAmountT) {
        _textPENController.text = widget.requestData.amountPayableMin;
      }
      _textUSDController.text = widget.requestData.amountPayableTotal;
    }
    super.didUpdateWidget(oldWidget);
    // if (widget.rate != oldWidget.rate) _calcPENtoUSD();
  }

  _changeOperationType(RequestType _requestType) {
    StoreProvider.of<AppState>(context).dispatch(
      UpdateRequestDataRequestAction(
        requestData.copyWith(
          requestType: _requestType,
          bankAccountOrigin: null,
          bankAccount: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List items = [];
    items.add(Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      borderOnForeground: true,
      elevation: 3,
      child: Column(
        children: <Widget>[
          _buildChangeCardHeader(context),
          _buildCouponRate(),
          _buildChangeCardBody(context)
        ],
      ),
    ));
    items.add(UIHelper.verticalSpaceSmall);
    if (requestData.isActiveUserChangeRequestType)
      items.add(CouponCard(
        currentCoupon: requestData.currentCoupon,
        // amount: _penAmount,
        typeRequest: requestData.makeRequestType,
        requestData: requestData,
      ));
    items.add(UIHelper.verticalSpaceMedium);
    items.add(UIHelper.verticalSpaceMedium);
    items.add(_buildSendButton(context));
    items.add(UIHelper.verticalSpaceMedium);
    items.add(_buildReceiveButton(context));
    items.add(UIHelper.verticalSpaceMedium);
    items.add(UIHelper.verticalSpaceMedium);
    items.add(_buildSubmitButton());
    items.add(UIHelper.verticalSpaceSmall);

    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva operación'),
        centerTitle: true,
        bottom: ConfirmAccountAlert(
          currentUser: widget.currentUser,
        ),
      ),
      backgroundColor: Colors.grey[100],
      floatingActionButton: WhatsappButton(),
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(context),
        child: Form(
          key: _formKey,
          child: Container(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getCompraRate() {
    return requestData.rate.purchasePriceFixed(
        coupon: requestData.currentCoupon,
        preferentialRate: requestData.preferentialRate);
  }

  String _getVentaRate() {
    return requestData.rate.salePriceFixed(
        coupon: requestData.currentCoupon,
        preferentialRate: requestData.preferentialRate);
  }

  Color _cardColorPurchase() {
    if (requestData.isActiveUserChangeRequestType)
      return requestData.isCSPurchase
          ? Theme.of(context).primaryColor
          : Colors.white;

    return requestData.isCSPurchase ? Color(0xFF707070) : Color(0xFFD3D3D3);
  }

  TextStyle _cardStylePurchase({bool isRate = false}) {
    TextStyle _result = requestData.isCSPurchase
        ? subHeaderStyle.copyWith(color: Colors.white)
        : subHeaderStyle;

    if (!requestData.isActiveUserChangeRequestType &&
        isRate &&
        requestData.isCSPurchase)
      _result = _result.copyWith(
        decoration: TextDecoration.lineThrough,
      );

    return _result;
  }

  Color _cardColorSale() {
    if (requestData.isActiveUserChangeRequestType)
      return !requestData.isCSPurchase
          ? Theme.of(context).primaryColor
          : Colors.white;

    return !requestData.isCSPurchase ? Color(0xFF707070) : Color(0xFFD3D3D3);
  }

  TextStyle _cardStyleSale({bool isRate = false}) {
    TextStyle _result = !requestData.isCSPurchase
        ? subHeaderStyle.copyWith(color: Colors.white)
        : subHeaderStyle;
    if (!requestData.isActiveUserChangeRequestType &&
        isRate &&
        !requestData.isCSPurchase)
      _result = _result.copyWith(decoration: TextDecoration.lineThrough);
    return _result;
  }

  Widget _buildChangeCardHeader(context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: requestData.isActiveUserChangeRequestType
                  ? () => _changeOperationType(RequestType.compra)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: _cardColorPurchase(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                  ),
                ),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Compra: ",
                      style: _cardStylePurchase(),
                    ),
                    Text(
                      " ${_getCompraRate()}",
                      style: _cardStylePurchase(isRate: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: requestData.isActiveUserChangeRequestType
                  ? () => _changeOperationType(RequestType.venta)
                  : null,
              child: Container(
                  decoration: BoxDecoration(
                    color: _cardColorSale(),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                  ),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Venta: ",
                        style: _cardStyleSale(),
                      ),
                      Text(
                        "${_getVentaRate()}",
                        style: _cardStyleSale(isRate: true),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferentialRate() {
    if (requestData.isActiveUserChangeRequestType) return Container();
    return Container(
      color: Color(0xFFFFC23B),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(4),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        dense: true,
        title: RichText(
          text: TextSpan(
            text: 'Tasa preferencial ${requestData.makeRequestTypeText} ',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
            children: [
              TextSpan(
                text: '${requestData.preferentialRate.rateToFixed}',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
        trailing: Container(
          constraints: BoxConstraints(maxWidth: 90, maxHeight: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.alarm,
                size: 15,
                color: Colors.red,
              ),
              UIHelper.horizontalSpaceMiniSmall,
              CountDownTimer(
                secondsRemaining: requestData.preferentialRate.time,
                countDownTimerStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                whenTimeExpires: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeCardTextFieldSend() {
    return TextFormField(
      controller: _textPENController,
      // initialValue: requestData.amountPayableMin,
      keyboardType: TextInputType.number,
      style: inputChangeStyle,
      readOnly: !requestData.isActiveUserChangeRequestType,
      textAlign: TextAlign.center,
      onChanged: (String value) {
        StoreProvider.of<AppState>(context).dispatch(
          UpdateRequestDataRequestAction(
            requestData.copyWith(
                penAmount: double.parse(value), onEditAmount: true),
          ),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Envío "),
            Icon(
              requestData.isCSPurchase ? AppIcons.usd : AppIcons.pen,
              size: 20,
            ),
          ],
        ),
      ),
      autovalidate: true,
      validator: (value) => helpers.validateMinAndMaxPurchase(
          value, requestData.currentCoupon, requestData.makeRequestType),
    );
  }

  Widget _buildChangeCardTextFieldReceive() {
    return TextField(
      controller: _textUSDController,
      readOnly: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Recibo "),
            Icon(
              requestData.isCSPurchase ? AppIcons.pen : AppIcons.usd,
              size: 20,
            ),
          ],
        ),
      ),
      keyboardType: TextInputType.number,
      style: inputChangeStyle,
      textAlign: TextAlign.center,
    );
  }

  bool get _isApplyCoupon => requestData.currentCoupon != null;

  Widget _buildCouponRate() {
    if (requestData.isActiveUserChangeRequestType && _isApplyCoupon) {
      return Container(
        padding: EdgeInsets.only(top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Antes: ${requestData.rate.purchasePriceFixed()}',
              style: TextStyle(decoration: TextDecoration.lineThrough),
            ),
            Text(
              'Antes: ${requestData.rate.salePriceFixed()}',
              style: TextStyle(decoration: TextDecoration.lineThrough),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildChangeCardBody(context) {
    return Column(
      children: <Widget>[
        _buildPreferentialRate(),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Monto mínimo"),
              UIHelper.horizontalSpaceMiniSmall,
              Icon(
                requestData.isCSPurchase ? AppIcons.usd : AppIcons.pen,
                size: 14,
              ),
              UIHelper.horizontalSpaceMiniSmall,
              if (!requestData.isCSPurchase)
                Text("${requestData.config.requestAmountMinSFixed}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              if (requestData.isCSPurchase)
                Text("${requestData.config.requestAmountMinDFixed}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  _buildChangeCardTextFieldSend(),
                  _buildChangeCardTextFieldReceive(),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FloatingActionButton(
                    heroTag: "__changeBtn__",
                    backgroundColor: requestData.isActiveUserChangeRequestType
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    onPressed: requestData.isActiveUserChangeRequestType
                        ? () => _changeOperationType(
                            requestData.requestType == RequestType.compra
                                ? RequestType.venta
                                : RequestType.compra)
                        : null,
                    child: Icon(Icons.compare_arrows),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSendButtonStandalone(context) => Column(
        children: <Widget>[
          Text("¿Desde qué cuenta envías el dinero?"),
          UIHelper.verticalSpaceSmall,
          InkWell(
            onTap: () => _showDialog(!requestData.isCSPurchase),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: showOriginRequieredText
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Agregar cuenta bancaria",
                    style: selectTextStyle,
                  ),
                  Icon(
                    AppIcons.plusCircle,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          if (showOriginRequieredText) errorText(),
        ],
      );

  Widget errorText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Campo requerido',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  bool get showOriginRequieredText =>
      !isValidate && requestData.bankAccountOrigin == null;
  bool get showPAyableRequiredText =>
      !isValidate && requestData.bankAccount == null;

  Widget _buildSendButton(context) {
    // open modal
    if (widget.bankAccounts.isEmpty) return _buildSendButtonStandalone(context);
    String _currencyType = !requestData.isCSPurchase ? "Dolares" : "Soles";
    List<BankAccount> _bankOrigin = List.from(widget.bankAccounts)
      ..removeWhere((t) => t.currencyType == _currencyType);
    if (_bankOrigin.isEmpty) return _buildSendButtonStandalone(context);

    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(
                color: showOriginRequieredText ? Colors.red : Colors.blueGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BankAccount>(
              isExpanded: true,
              value: requestData.bankAccountOrigin,
              hint: Text('¿Desde qué cuenta nos envías el dinero?'),
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (BankAccount newValue) {
                // setState(() {
                //   bankAccountOrigin = newValue;
                // });
                StoreProvider.of<AppState>(context).dispatch(
                  UpdateRequestDataRequestAction(
                    requestData.copyWith(bankAccountOrigin: newValue),
                  ),
                );
              },
              items: _bankOrigin
                  .map<DropdownMenuItem<BankAccount>>((BankAccount bankAcc) {
                return DropdownMenuItem<BankAccount>(
                  value: bankAcc,
                  child: Text(bankAcc.alias),
                );
              }).toList(),
            ),
          ),
        ),
        if (showOriginRequieredText) errorText(),
        InkWell(
          onTap: () => _showDialog(!requestData.isCSPurchase),
          child: Container(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Text(
                  "Agregar cuenta bancaria",
                  style: selectTextStyle,
                ),
                UIHelper.horizontalSpaceSmall,
                Icon(
                  AppIcons.plusCircle,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildReceiveButtonStandalone(context) {
    // open modal
    return Column(
      children: <Widget>[
        Text("¿En qué cuenta deseas recibir el dinero?"),
        UIHelper.verticalSpaceSmall,
        InkWell(
          onTap: () => _showDialog(requestData.isCSPurchase),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: showPAyableRequiredText
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                style: BorderStyle.solid,
                width: 1.0,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Agregar cuenta bancaria",
                  style: selectTextStyle,
                ),
                Icon(
                  AppIcons.plusCircle,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
        if (showPAyableRequiredText) errorText(),
      ],
    );
  }

  Widget _buildReceiveButton(context) {
    if (widget.bankAccounts.isEmpty)
      return _buildReceiveButtonStandalone(context);
    String _currencyType = !requestData.isCSPurchase ? "Soles" : 'Dolares';

    List<BankAccount> _bankPayable = List.from(widget.bankAccounts)
      ..removeWhere((t) => t.currencyType == _currencyType);

    if (_bankPayable.isEmpty) return _buildReceiveButtonStandalone(context);
    // open modal
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.0),
              border: Border.all(
                  color:
                      showPAyableRequiredText ? Colors.red : Colors.blueGrey)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BankAccount>(
              isExpanded: true,
              value: requestData.bankAccount,
              hint: Text(
                '¿En qué cuenta deseas recibir el dinero?',
                overflow: TextOverflow.ellipsis,
              ),
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                  color:
                      showPAyableRequiredText ? Colors.red : Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (BankAccount newValue) {
                // setState(() {
                //   bankAccountPayable = newValue;
                // });
                StoreProvider.of<AppState>(context).dispatch(
                  UpdateRequestDataRequestAction(
                    requestData.copyWith(bankAccount: newValue),
                  ),
                );
              },
              items: _bankPayable
                  .map<DropdownMenuItem<BankAccount>>((BankAccount bankAcc) {
                return DropdownMenuItem<BankAccount>(
                  value: bankAcc,
                  child: Text(bankAcc.alias),
                );
              }).toList(),
            ),
          ),
        ),
        if (showPAyableRequiredText) errorText(),
        InkWell(
          onTap: () => _showDialog(requestData.isCSPurchase),
          child: Container(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Text(
                  "Agregar cuenta bancaria",
                  style: selectTextStyle,
                ),
                UIHelper.horizontalSpaceSmall,
                Icon(
                  AppIcons.plusCircle,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showDialogEmailNotValidate() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "El correo no está validado",
        description:
            "No puedes generar solicitudes hasta que valides tu cuenta. Ingresa a tu correo para validarla",
        buttonText: "OK",
      ),
    );
  }

  void _goCompleteFormData(RequestData data) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return UserDataScreen(
        requestData: data,
        onRequestChange: widget.onRequestChange,
        currentUser: widget.currentUser,
      );
    }));
  }

  bool validateAccounts() {
    bool _isValid = requestData.bankAccountOrigin != null &&
        requestData.bankAccount != null;
    setState(() => isValidate = _isValid);
    return _isValid;
  }

  void _submitRequest() {
    // validate form data
    if (!validateAccounts()) return;
    if (!_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Datos no válidos"),
      ));
      return;
    }

    if (!widget.currentUser.data.validEmail)
      return _showDialogEmailNotValidate();
    else {
      if (!widget.currentUser.hasData) return _goCompleteFormData(requestData);

      // if(data)

      isLoading = true;

      widget.onRequestChange(requestData, () {
        setState(() {
          isLoading = false;
        });
      }, (error) {
        setState(() {
          isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("${error.message}"),
        ));
      });
    }
  }

  Widget _buildSubmitButton() {
    return FormSubmitButton(
      onPressed: _submitRequest,
      child: Text(
        "Iniciar operación",
        style: buttonStyle,
      ),
      loading: isLoading,
    );
  }

  void _showDialog(bool isSend) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BankAccountScreen(
        isAccountSend: isSend,
        currency: isSend ? currencyType[0]['id'] : currencyType[1]['id'],
      );
    }));
  }
}
