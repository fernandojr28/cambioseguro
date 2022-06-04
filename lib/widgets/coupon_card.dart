import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/containers/coupon_container.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CouponCard extends StatefulWidget {
  const CouponCard({
    Key key,
    @required this.typeRequest,
    // @required this.amount,
    @required this.currentCoupon,
    @required this.requestData,
  }) : super(key: key);

  final RequestType typeRequest;
  // final double amount;
  final Coupon currentCoupon;
  final RequestData requestData;

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isActive = false;
  // String _code = "";
  bool _isBusy = false;
  TextEditingController _textController;
  @override
  initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  dispose() {
    _textController?.dispose();
    super.dispose();
  }

  _submit(onValidateCoupon) {
    if (_textController.text.trim().isEmpty) return false;
    // return widget.onValidateCoupon(_code);
    setState(() => _isBusy = true);
    // _showConfirmDialog();
    return onValidateCoupon(
      _textController.text,
      widget.typeRequest,
      widget.requestData.penAmount.toStringAsFixed(2),
      _showConfirmDialog,
      _showError,
    );
  }

  _showError(error) {
    setState(() => _isBusy = false);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("${error.message}"),
    ));
  }

  _showConfirmDialog() {
    setState(() => _isBusy = false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          AppIcons.ticket,
                          color: Color(0xFF9CD000),
                          // size: 32,
                        ),
                      ),
                      UIHelper.verticalSpaceMedium,
                      Center(
                        child: Text(
                          '¡El código del cupón fue aplicado correctamente!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      UIHelper.verticalSpaceMedium,
                      Center(
                        child: FormSubmitButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget get _buildButtonText => widget.currentCoupon == null
      ? Text(
          'Aplicar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        )
      : Icon(Icons.check);

  Color get _buttonColor =>
      widget.currentCoupon == null ? Color(0XFFFFC23B) : Color(0XFF9CD000);

  _deleteClean() {
    StoreProvider.of<AppState>(context).dispatch(DeleteCouponRequestAction());
    _textController.text = "";
    isActive = _textController.text.isNotEmpty;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CouponContainer(
      builder: (BuildContext context, vm) {
        return Column(
          children: <Widget>[
            Text("¿Cuentas con un cupón?"),
            UIHelper.verticalSpaceSmall,
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                width: 240,
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: isActive ? _buttonColor : greyColor,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _textController,
                        readOnly: widget.currentCoupon != null,
                        onChanged: (v) {
                          setState(() {
                            isActive = v.trim().isNotEmpty;
                          });
                        },
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Ingrese cupón",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: widget.currentCoupon != null
                            ? null
                            : () => _submit(vm.onValidateCoupon),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isActive ? _buttonColor : greyColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          height: 50,
                          child: Center(
                            child: _isBusy
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  )
                                : _buildButtonText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.currentCoupon != null)
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: _deleteClean,
                  ),
                )
            ]),
          ],
        );
      },
    );
  }
}
