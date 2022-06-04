import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class CouponContainer extends StatelessWidget {
  final Function(BuildContext context, _ViewModel vm) builder;

  const CouponContainer({Key key, @required this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: builder,
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onValidateCoupon,
  });

  /// code:
  /// typeRequest:
  /// amount:
  final Function(
    String code,
    RequestType typeRequest,
    String amount,
    VoidCallback onSuccess,
    ErrorCallback onError,
  ) onValidateCoupon;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        onValidateCoupon: (
          String code,
          RequestType typeRequest,
          String amount,
          VoidCallback onSuccess,
          ErrorCallback onError,
        ) {
          store.dispatch(RequestCouponValidateAction(
            code: code,
            typeRequest: typeRequest,
            amount: amount,
            onSuccess: onSuccess,
            onError: onError,
          ));
        },
      );
}
