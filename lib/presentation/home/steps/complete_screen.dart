import 'package:cambioseguro/containers/history_detail_container.dart';
import 'package:cambioseguro/presentation/home/steps/complete_step.dart';
import 'package:flutter/material.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({Key key, @required this.historyId}) : super(key: key);

  final String historyId;
  
  @override
  Widget build(BuildContext context) {
    return HistoryDetailContainer(
        historyId: historyId,
        builder: (BuildContext context, vm) {
          return CompleteStep(
            changeHistory: vm.changeHistory,
            onInitHistory: vm.onLoadHistory,

            
            showAppBar: true,
          );
        },
      );
  }
}