import 'dart:io';

import 'package:cambioseguro/helpers/select_image.dart';
import 'package:cambioseguro/models/user_data.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/redux/actions/app_actions.dart';
import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/client_form_data.dart';
import 'package:cambioseguro/models/request_data.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:cambioseguro/widgets/switch_like_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:cambioseguro/helpers/helpers.dart' as helpers;
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    Key key,
    @required this.currentUser,
    // @required this.onRequestChange,
    @required this.requestData,
  }) : super(key: key);

  final UserApp currentUser;
  // final Function(RequestData, VoidCallback, ErrorCallback) onRequestChange;
  final RequestData requestData;

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  ClientFormData formData;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  UserApp get currentUser => widget.currentUser;
  UserData get userData => currentUser.data;
  TextEditingController _bithdayCtrl;
  bool isLoading = false;
  // dynamic _formDataImage;

  @override
  void initState() {
    _bithdayCtrl = TextEditingController();
    formData = ClientFormData(
      accountType: currentUser.accountType,
      docDateCe: userData.credential.dateCe,
      name: userData.name,
      fatherLastName: userData.fatherLastName,
      motherLastName: userData.motherLastName,
      credentialType: userData.credential?.type,
      credentialNumber: userData.credential?.number,
      phone: userData.phone,
      politicallyExposed: userData.politicallyExposed,
      familyExposedPolitically: userData.familyExposedPolitically,
      docImageP: userData.credential.imageUrl,
    );
    _bithdayCtrl.text = DateFormat('d/MM/y').format(formData.docDateCe);
    super.initState();
  }

  @override
  void dispose() {
    _bithdayCtrl?.dispose();
    super.dispose();
  }

  final BoxDecoration _boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(7.0),
      border: Border.all(color: Colors.blueGrey));

  List<Widget> _buildTitle(String text) =>
      [Text(text), UIHelper.verticalSpaceMiniSmall];

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: currentUser.email,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.emailAddress,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      validator: (value) => helpers.validateEmail(value),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: formData.name,
      onChanged: (value) {
        formData = formData.copyWith(name: value);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa tu nombre",
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      initialValue: formData.fatherLastName,
      onChanged: (val) {
        formData = formData.copyWith(fatherLastName: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      initialValue: formData.motherLastName,
      onChanged: (val) {
        formData = formData.copyWith(motherLastName: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  Widget _buildDocumentType() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: _boxDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: formData.credentialType,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              formData = formData.copyWith(credentialType: newValue);
            });
          },
          items:
              credentialTypes(false).map<DropdownMenuItem<String>>((Map credT) {
            return DropdownMenuItem<String>(
              value: credT['id'],
              child: Text(credT['title']),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNumberDocumentField() {
    return TextFormField(
      initialValue: formData.credentialNumber,
      onChanged: (val) {
        formData = formData.copyWith(credentialNumber: val);
      },
      enableInteractiveSelection: false,
      keyboardType:
          helpers.getTextInputTypeByCredentialType(formData.credentialType),
      maxLength: helpers.getLenthByCredentialType(formData.credentialType),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      validator: (value) =>
          helpers.validateDocumentNumberByType(formData.credentialType, value),
    );
  }

  Widget _buildBirthdayTitularField() {
    return InkWell(
        onTap: _showDatePicker,
        child: TextFormField(
          readOnly: true,
          enabled: false,
          controller: _bithdayCtrl,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Ingresa Fecha de nacimiento",
            labelText: "Fecha de nacimiento",
          ),
          validator: (value) => helpers.validateText(value),
        ));
  }

  Widget _buildUploadImage() {
    return _isUploadFile
        ? LinearProgressIndicator()
        : Column(
            children: <Widget>[
              InkWell(
                onTap: _getImage,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  // padding: EdgeInsets.all(8),
                  decoration: _boxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Subir imagen de pasaporte',
                        style: selectTextStyle,
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Icon(
                        Icons.cloud_upload,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpaceSmall,
              Center(
                child: Text('Asegúrate de que el pasaporte se vea nítido'),
              ),
              if (formData.docImageP.isNotEmpty)
                Container(
                    margin: EdgeInsets.all(8),
                    child: Image.network(formData.docImageP)),
            ],
          );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      initialValue: formData.phone,
      onChanged: (val) {
        formData = formData.copyWith(phone: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      maxLength: 9,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: "Ingresa tu número",
      ),
      validator: (value) => helpers.validatePhone(value),
    );
  }

  Widget _buildBusinessRucField() {
    return TextFormField(
      initialValue: formData.ruc,
      onChanged: (val) {
        formData = formData.copyWith(ruc: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      maxLength: 11,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa RUC",
      ),
      validator: (value) => helpers.validateRuc(value),
    );
  }

  Widget _buildBusinessNameField() {
    return TextFormField(
      initialValue: formData.businessName,
      onChanged: (val) {
        formData = formData.copyWith(businessName: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa razón social",
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  Widget _buildBusinessSBSRequiredField() {
    return TextFormField(
      initialValue: formData.sbsRequirement,
      onChanged: (val) {
        formData = formData.copyWith(sbsRequirement: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  Widget _buildBusinessRepresentation() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: _boxDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: formData.typeRepresentation,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              formData = formData.copyWith(typeRepresentation: newValue);
            });
          },
          items: typeRepresentationList.map<DropdownMenuItem<String>>((credT) {
            return DropdownMenuItem<String>(
              value: credT,
              child: Text(credT),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExposedPEPField() {
    return ListTile(
      onTap: () {
        setState(() {
          formData = formData.copyWith(
              politicallyExposed: !formData.politicallyExposed);
        });
      },
      contentPadding: EdgeInsets.all(0),
      leading: SwitchlikeCheckbox(
        checked: formData.politicallyExposed,
        textOff: 'NO',
        textOn: 'SI',
      ),
      title: Text(
        "¿Eres o has sido Persona Expuesta Politicamente (PEP)?",
      ),
    );
  }

  Widget _buildFamilyExposedPEPField() {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () {
        setState(() {
          formData = formData.copyWith(
              familyExposedPolitically: !formData.familyExposedPolitically);
        });
      },
      leading: SwitchlikeCheckbox(
        checked: formData.familyExposedPolitically,
        textOff: 'NO',
        textOn: 'SI',
      ),
      title: Text(
        "¿Eres pariente, cónyuge o conviviente de alguna persona que califique como PEP hasta el segundo grado de consanguinidad y segundo de afinidad?",
      ),
    );
  }

  Widget _buildFamilyPoliticallyNameField() {
    return TextFormField(
      initialValue: formData.namePep,
      onChanged: (val) {
        formData = formData.copyWith(namePep: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Nombres del pariente",
      ),
      validator: (value) => helpers.validateEmail(value),
    );
  }

  Widget _buildFamilyPoliticallyLastnameField() {
    return TextFormField(
      initialValue: formData.lastNamePep,
      onChanged: (val) {
        formData = formData.copyWith(lastNamePep: val);
      },
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Apellidos del pariente",
      ),
      validator: (value) => helpers.validateEmail(value),
    );
  }

  _onSuccessFetchFormData(String imageUrl) {
    setState(() {
      _isUploadFile = false;
      formData = formData.copyWith(docImageP: imageUrl);
    });
  }

  _onErrorFetchFormData(PlatformException error) {
    setState(() {
      _isUploadFile = false;
    });
  }

  bool _isUploadFile = false;
  Future _getImage() async {
    File image = await selectImage(context);

    if (image != null) {
      setState(() {
        _isUploadFile = true;
      });
      // Clean all image cached
      imageCache.clear();
      StoreProvider.of<AppState>(context)
          .dispatch(UploadPassportImageRequestAction(
        onError: _onErrorFetchFormData,
        onSuccess: _onSuccessFetchFormData,
        file: image,
      ));
    }
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Aceptar',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        cancel: Text('Cancelar', style: TextStyle(color: Colors.grey)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: formData.docDateCe,
      dateFormat: DATEFORMAT,
      locale: DateTimePickerLocale.es,
      onClose: () =>
          _bithdayCtrl.text = DateFormat('d/MM/y').format(formData.docDateCe),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          formData = formData.copyWith(docDateCe: dateTime);
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          formData = formData.copyWith(docDateCe: dateTime);
        });
      },
    );
  }

  void _handleSubmitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setLoading(true);
      StoreProvider.of<AppState>(context).dispatch(ClientDataPostAction(
          formData: formData, onCompeleted: _onSuccess, onError: _onError));
    }
  }

  void setLoading(bool isL) => setState(() => isLoading = isL);

  void _onSuccess() {
    setLoading(false);

    // apply for tab_request
    if (widget.requestData == null) return;

    setLoading(true);
    StoreProvider.of<AppState>(context)
        .dispatch(RequestChangeAction(widget.requestData, () {
      setLoading(false);
      Navigator.pop(context);
    }, (error) {
      _onError(error);
      Navigator.pop(context);
    }));
  }

  void _onError(PlatformException error) {
    setLoading(false);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("${error.message}"),
    ));
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Expanded(
        //   child: FormSubmitButton(
        //     color: Colors.grey,
        //     child: Text(
        //       "Cancelar",
        //       style: buttonStyle,
        //     ),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
        // UIHelper.horizontalSpaceLarge,
        Expanded(
          child: FormSubmitButton(
            loading: isLoading,
            child: Text(
              "Continuar",
              style: buttonStyle,
            ),
            // loading: _isBusy,
            onPressed: _handleSubmitForm,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          key: _scaffoldKey,
          // appBar: AppBar(
          //   title: Text('Completa tus datos personales'),
          // ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ..._buildTitle('Correo electrónico'),
                  _buildEmailField(),
                  UIHelper.verticalSpaceMedium,
                  ..._buildTitle('Nombres'),
                  _buildNameField(),
                  UIHelper.verticalSpaceMedium,
                  ..._buildTitle('Primer apellido'),
                  _buildFirstNameField(),
                  UIHelper.verticalSpaceMedium,
                  ..._buildTitle('Segundo apellido'),
                  _buildLastNameField(),
                  UIHelper.verticalSpaceMedium,
                  ..._buildTitle('Documento'),
                  _buildDocumentType(),
                  UIHelper.verticalSpaceMedium,
                  ..._buildTitle('Número'),
                  _buildNumberDocumentField(),
                  if (formData.credentialType == 'CE') ...[
                    UIHelper.verticalSpaceMedium,
                    _buildBirthdayTitularField(),
                  ],
                  if (formData.credentialType == 'PASAPORTE') ...[
                    UIHelper.verticalSpaceMedium,
                    _buildUploadImage(),
                  ],
                  UIHelper.verticalSpaceMedium,
                  ..._buildTitle('Celular'),
                  _buildPhoneField(),
                  UIHelper.verticalSpaceMedium,
                  if (formData.accountType == AccountType.Juridica) ...[
                    ..._buildTitle('RUC'),
                    _buildBusinessRucField(),
                    UIHelper.verticalSpaceMedium,
                    ..._buildTitle('Razón social'),
                    _buildBusinessNameField(),
                    UIHelper.verticalSpaceMedium,
                    ..._buildTitle(
                        'Según requerimiento de la SBS, indica los accionistas, socios o asociados que tengan directa o indirectamente más del 25% del capital social, aporte o participación de la persona jurídica (nombres, apellidos, tipo de documento y N° de documento en el caso de personas naturales; denominación o razón social y N° de RUC en el caso de personas jurídicas). Separa los datos por una coma.'),
                    _buildBusinessSBSRequiredField(),
                    UIHelper.verticalSpaceMedium,
                    ..._buildTitle('Indicar cual es el tipo de representación'),
                    _buildBusinessRepresentation(),
                  ],
                  _buildExposedPEPField(),
                  UIHelper.verticalSpaceMedium,
                  _buildFamilyExposedPEPField(),
                  if (formData.familyExposedPolitically) ...[
                    UIHelper.verticalSpaceMedium,
                    ..._buildTitle('Nombres del pariente'),
                    _buildFamilyPoliticallyNameField(),
                    UIHelper.verticalSpaceMedium,
                    ..._buildTitle('Apellidos del pariente'),
                    _buildFamilyPoliticallyLastnameField(),
                  ],
                  UIHelper.verticalSpaceMedium,
                  _buildButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
