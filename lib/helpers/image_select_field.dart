import 'dart:io';

import 'package:cambioseguro/helpers/select_image.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart' as path;

class ImageSelectField extends StatefulWidget {
  const ImageSelectField({Key key, @required this.item}) : super(key: key);

  final int item;

  @override
  _ImageSelectFieldState createState() => _ImageSelectFieldState();
}

class _ImageSelectFieldState extends State<ImageSelectField> {
  TextEditingController _controller;

  int get item => widget.item;

  @override
  initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  dispose() {
    // _controller?.
    super.dispose();
  }

  Future _getImage(context) async {
    // File image = await ImagePicker.pickImage(source: source);
    File image = await selectImage(context);

    if (image != null) {
      setState(() {
        _isUploadFile = true;
        _controller.text = "${path.basename(image.path)}";
        // "...${path.basename(image.path).substring(image.path.length - 8, image.path.length)}";
      });
      StoreProvider.of<AppState>(context)
          .dispatch(UploadRequestImageRequestAction(
        onError: _onErrorFetchFormData,
        onSuccess: _onSuccessFetchFormData,
        file: image,
        position: widget.item,
      ));
    }
  }

  final BoxDecoration _boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(7.0),
    border: Border.all(color: Colors.blueGrey),
  );

  _onSuccessFetchFormData(String imageUrl) {
    setState(() {
      _isUploadFile = false;
    });
    // widget.onUpdateData(
    //     OperationItemModel(position: widget.item, imageUrl: imageUrl));
  }

  _onErrorFetchFormData(dynamic error) {
    setState(() {
      _isUploadFile = false;
    });
  }

  bool _isUploadFile = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        decoration: _boxDecoration,
        child: InkWell(
          onTap: _isUploadFile ? null : () => _getImage(context),
          child: FormBuilderTextField(
            controller: _controller,
            readOnly: true,
            textAlign: TextAlign.center,
            enabled: false,
            maxLines: 1,
            attribute: '$item-image',
            decoration: InputDecoration(
              hintMaxLines: 1,
              suffixIcon: _isUploadFile
                  ? Container(
                      height: 24,
                      width: 24,
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ))
                  : _controller.text.isEmpty
                      ? Icon(Icons.cloud_upload)
                      : Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        ),
              hintText: 'Subir voucher',
            ),
            validators: [
              // FormBuilderValidators.required(errorText: '')
            ],
          ),
        ),
      ),
    );
  }
}
