import 'package:cambioseguro/containers/history_detail_container.dart';
import 'package:cambioseguro/presentation/home/steps/complete_step.dart';
import 'package:flutter/material.dart';

class HistoryDetail extends StatelessWidget {
  const HistoryDetail({Key key, @required this.historyId}) : super(key: key);
  final String historyId;

  @override
  Widget build(BuildContext context) {
    return HistoryDetailContainer(
        historyId: historyId,
        builder: (BuildContext context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Detalle de operación'),
              centerTitle: true,
            ),
            body: CompleteStep(
              changeHistory: vm.changeHistory,
              onInitHistory: vm.onLoadHistory,
            ),
          );
        });
  }
}
