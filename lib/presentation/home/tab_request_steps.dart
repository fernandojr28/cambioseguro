import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/change_request.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/presentation/home/steps/complete_screen.dart';
import 'package:cambioseguro/presentation/home/steps/procesing_step.dart';
import 'package:cambioseguro/presentation/home/steps/transfer_step.dart';
import 'package:cambioseguro/presentation/home/steps/validation_step.dart';
import 'package:cambioseguro/widgets/count_down_timer.dart';
import 'package:cambioseguro/widgets/steps_indicator.dart';
import 'package:flutter/material.dart';

class TabRequestSteps extends StatelessWidget {
  const TabRequestSteps({
    Key key,
    @required this.currentUser,
    // @required this.onRequestPut,
    // @required this.onDeleteRequest,
    @required this.changeRequest,
    @required this.onLoadRequestPending,
  }) : super(key: key);

  final UserApp currentUser;
  // final Function(RequestPutData) onRequestPut;
  // final VoidCallback onDeleteRequest;
  final ChangeRequest changeRequest;
  final VoidCallback onLoadRequestPending;
  @override
  Widget build(BuildContext context) {
    Widget _widgetChild;
    int _currentStep = 1;
    if (changeRequest.status == ChangeRequestStatus.usuario ||
        changeRequest.status == ChangeRequestStatus.transferencia) {
      _widgetChild = ValidationStep(
        changeRequest: changeRequest,
      );
      _currentStep = 2;
    }
    if (changeRequest.status == ChangeRequestStatus.cambio) {
      _widgetChild = ProcesingStep(
        changeRequest: changeRequest,
      );
      _currentStep = 3;
    }
    if (changeRequest.status == ChangeRequestStatus.finalizado ||
        changeRequest.status == ChangeRequestStatus.rechazado) {
      _widgetChild = CompleteScreen(
        historyId: changeRequest.id,
      );
      _currentStep = 4;
    }
    if (changeRequest.status == ChangeRequestStatus.pendiente)
      _widgetChild = TransferStep();
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            if (_currentStep == 1)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.alarm,
                    color: Color(0XFFf5a623),
                    size: 14,
                  ),
                  Container(
                    width: 60.0,
                    padding: EdgeInsets.only(top: 3.0, right: 4.0),
                    child: CountDownTimer(
                      secondsRemaining: changeRequest.time,
                      whenTimeExpires: onLoadRequestPending,
                      countDownTimerStyle: TextStyle(
                          color: Color(0XFFf5a623), fontSize: 14, height: 1.2),
                    ),
                  ),
                ],
              ),
            Center(
              child: StepsIndicator(
                currentStep: _currentStep,
              ),
            )
          ],
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: _widgetChild,
    );
  }
}
