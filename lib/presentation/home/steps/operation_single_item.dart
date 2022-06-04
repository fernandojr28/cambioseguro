import 'package:cambioseguro/helpers/image_select_field.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OperationSingleItem extends StatefulWidget {
  @override
  _OperationSingleItemState createState() => _OperationSingleItemState();
}

class _OperationSingleItemState extends State<OperationSingleItem> {
  TextEditingController _codeCtrl;

  // final _formKey = GlobalKey<FormState>();
  GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  bool isBusy;

  @override
  initState() {
    super.initState();
    _codeCtrl = TextEditingController();
    isBusy = false;
  }

  _success() {
    setState(() => isBusy = false);
  }

  _error(error) {
    setState(() => isBusy = false);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("${error.message}"),
    ));
  }

  _onSubmit() {
    if (_fbKey.currentState.saveAndValidate()) {
      final ChangeRequest changeRequest =
          StoreProvider.of<AppState>(context).state.changeRequest;
      RequestPutData model = RequestPutData(cci: changeRequest.accountCs.isCci);

      List<RequestPutData> requestPutData = model.makeData(_fbKey);
      setState(() => isBusy = true);
      StoreProvider.of<AppState>(context).dispatch(
          RequestChangePutRequestAction(requestPutData, _success, _error));
    }
  }

  final int item = 0;
  @override
  Widget build(BuildContext context) {
    final AppState state = StoreProvider.of<AppState>(context).state;
    final ChangeRequest changeRequest = state.changeRequest;
    return FormBuilder(
      key: _fbKey,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            controller: _codeCtrl,
            enableInteractiveSelection: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Ingresa Nro. operación",
              labelText: "Nro. operación",
            ),
            validators: [FormBuilderValidators.required()],
            attribute: '$item-code',
          ),
          if (changeRequest.accountCs.isCci) ...[
            UIHelper.verticalSpaceSmall,
            ImageSelectField(item: item),
          ],
          UIHelper.verticalSpaceMedium,
          Center(
            child: Container(
              width: double.infinity,
              child: FormSubmitButton(
                child: Text(
                  'Enviar',
                  style: buttonStyle,
                ),
                loading: isBusy,
                onPressed: _onSubmit,
                // _textIsNotEmpty()
                //  () => _handleSubmitted(state.changeRequest),
                // : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
