import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/shared/custom_divider.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CompleteStep extends StatefulWidget {
  const CompleteStep({
    Key key,
    @required this.onInitHistory,
    @required this.changeHistory,
    this.showAppBar = false,
  }) : super(key: key);

  final VoidCallback onInitHistory;
  final ChangeRequest changeHistory;
  final bool showAppBar;

  @override
  _CompleteStepState createState() => _CompleteStepState();
}

class _CompleteStepState extends State<CompleteStep> {
  ChangeRequest get change => widget.changeHistory;

  @override
  void initState() {
    widget.onInitHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: change.cardColor,
              title: Text(change.titleStatus()),
              centerTitle: true,
            )
          : null,
      body: !change.isComplete
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  if (widget.showAppBar)
                    Text('Se completo la transferencia de tu Cambio Seguro'),
                  UIHelper.verticalSpaceMedium,
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(change.titleIcon, color: change.titleColor),
                      UIHelper.horizontalSpaceMiniSmall,
                      Text(
                        change.titleStatus(),
                        style: TextStyle(
                          color: change.titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  UIHelper.verticalSpaceMedium,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          text: 'Código de operación ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: change.codeRequest,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18))
                          ]),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Código de transferencia',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text("${change.transferCode}"),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cuenta',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(change
                          .codeVoucher.bankAccountOrigin.bankAccountNumber),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Banco',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(change.codeVoucher.bankAccountOrigin.nameBank),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                          change.codeVoucher.bankAccountOrigin.bankAccountType),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Moneda',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(change.codeVoucher.bankAccountOrigin.currencyType),
                    ],
                  ),
                  UIHelper.verticalSpaceLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Enviaste',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Recibiste',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(change.amountPaidIcon, size: 16),
                      Text(
                        " ${change.amountPaid}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Spacer(),
                      Icon(change.amountPayableIcon, size: 16),
                      Text(
                        " ${change.amountPayable}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  CustomDivider(
                    color: Colors.grey,
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    children: <Widget>[
                      if (change.requestType == "venta") ...[
                        Text('Vendiste a '),
                        Text(
                          "${change.rate.salePriceFixed()}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                      if (change.requestType == "compra") ...[
                        Text('Compraste a '),
                        Text(
                          "${change.rate.purchasePriceFixed()}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ]
                    ],
                  ),
                  UIHelper.verticalSpaceLarge,
                  if (widget.showAppBar)
                    Container(
                      width: double.infinity,
                      child: FormSubmitButton(
                        child: Text(
                          'Nueva operación',
                          style: buttonStyle,
                        ),
                        // loading: vm.isBusy,
                        onPressed: () {
                          StoreProvider.of<AppState>(context)
                              .dispatch(RequestChangeDeleteResponseAction());
                        },
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
