import 'package:cambioseguro/helpers/image_select_field.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/cupertino.dart';

final BoxDecoration _boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(7.0),
  border: Border.all(color: Colors.blueGrey),
);

class OperationListItem extends StatefulWidget {
  @override
  _OperationListItemState createState() => _OperationListItemState();
}

class _OperationListItemState extends State<OperationListItem> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  int _nextItem;
  List<Widget> fields = [];
  bool isBusy;

  @override
  void initState() {
    isBusy = false;
    fields.addAll([
      OperationItem(
        onDelete: null,
        item: 0,
      ),
      OperationItem(
        onDelete: null,
        item: 1,
      ),
    ]);
    _nextItem = 2;
    super.initState();
  }

  _insert() {
    final int index = _nextItem++;
    fields.add(
      OperationItem(
        onDelete: () {},
        item: index,
      ),
    );
    setState(() {});
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
    } else {
      print(_fbKey.currentState.value);
      print("validation failed");
    }
  }

  // _onChange(){
  //   _fbKey.currentState.setState(fn)
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FormBuilder(
            // context,
            key: _fbKey,
            // autovalidate: true,
            child: Column(
              children: <Widget>[
                for (Widget w in fields) w,
              ],
            ),
          ),
          InkWell(
            onTap: _insert,
            child: Container(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Agregar transferencia",
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
          ),
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

class OperationItem extends StatefulWidget {
  const OperationItem({
    Key key,
    @required this.item,
    // @required this.isNeedImage,
    @required this.onDelete,
  })  : assert(item != null),
        // assert(selected != null),
        super(key: key);

  final int item;
  // final bool isNeedImage;
  final VoidCallback onDelete;

  @override
  _OperationItemState createState() => _OperationItemState();
}

class _OperationItemState extends State<OperationItem> {
  bool isDeleted = false;
  final String emptyMessage = 'Dato obligatorio';

  int get item => widget.item;

  _onDelete() {
    setState(() {
      isDeleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDeleted) return Container();

    final AppState state = StoreProvider.of<AppState>(context).state;
    final ChangeRequest changeRequest = state.changeRequest;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[50],
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          // direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              // height: 50,
              child: FormBuilderTextField(
                // initialValue: widget.model?.code,
                attribute: '$item-code',
                // onChanged: _onUpdateCode,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Ingresa Nro. operación",
                  labelText: "Nro. operación",
                ),
                validators: [
                  FormBuilderValidators.required(errorText: emptyMessage)
                ],
              ),
            ),
            UIHelper.verticalSpaceSmall,
            SizedBox(
              // height: 50,
              child: FormBuilderTextField(
                // initialValue: widget.model?.amount,
                // onChanged: _onUpdateAmount,
                attribute: '$item-amount',
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "100",
                  labelText: "Monto",
                ),
                validators: [
                  FormBuilderValidators.required(errorText: emptyMessage)
                ],
              ),
            ),
            if (changeRequest.accountCs.isCci) ...[
              UIHelper.verticalSpaceSmall,
              ImageSelectField(item: item),
            ],
            if (widget.onDelete != null) ...[
              UIHelper.verticalSpaceSmall,
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Container(
                  decoration: _boxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          // color: onDelete == null ? Colors.transparent : primaryColor,
                          color: Colors.red,
                        ),
                        onPressed: _onDelete,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
