import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> selectImage(context) {
  return showModalBottomSheet<File>(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text('Seleccione una opción para subir su voucher'),
              ),
              ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Cámara'),
                  onTap: () async {
                    File _image = await _getImage(ImageSource.camera);
                    Navigator.pop(context, _image);
                  }),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Galeria fe fotos'),
                onTap: () async {
                  File _image = await _getImage(ImageSource.gallery);
                  Navigator.pop(context, _image);
                },
              ),
            ],
          ),
        );
      });
}

Future<File> _getImage(ImageSource source) async {
  File image = await ImagePicker.pickImage(source: source);

  if (image != null) {
    return image;
  }
  return null;
}
