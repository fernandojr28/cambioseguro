import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/presentation/home/tab_request_steps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cambioseguro/redux/actions/actions.dart';

class RequestStepsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TabRequestSteps(
          currentUser: vm.currentUser,
          changeRequest: vm.changeRequest,
          onLoadRequestPending: vm.onLoadRequestPending,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.currentUser,
    @required this.changeRequest,
    @required this.onLoadRequestPending,
  });
  final UserApp currentUser;
  final ChangeRequest changeRequest;
  final VoidCallback onLoadRequestPending;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        currentUser: store.state.currentUser,
        changeRequest: store.state.changeRequest,
        onLoadRequestPending: () =>
            store.dispatch(RequestChangePendingRequestAction()),
      );
}
