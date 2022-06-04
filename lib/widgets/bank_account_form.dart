import 'dart:io';

import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/helpers/select_image.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/helpers/helpers.dart' as helpers;
import 'package:cambioseguro/models/account_form_data.dart';
import 'package:cambioseguro/models/app_state.dart';
import 'package:cambioseguro/models/bank.dart';
import 'package:cambioseguro/models/ubigeo.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:cambioseguro/shared/app_colors.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/custom_checkbox.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

final BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(7.0),
    border: Border.all(color: Colors.blueGrey));

class BankAccountForm extends StatefulWidget {
  const BankAccountForm({
    Key key,
    @required this.ubigeos,
    @required this.fetchBanks,
    @required this.banks,
    @required this.submitForm,
    @required this.formException,
    @required this.onLoadBankAccounts,
    @required this.currency,
    this.isAccountSend = false,
  }) : super(key: key);

  final List<Ubigeo> ubigeos;
  final List<Bank> banks;
  final Function(String, VoidCallback, ErrorCallback) fetchBanks;
  final Function(AccountFormData formData, VoidCallback onSuccess,
      ErrorCallback onError) submitForm;
  final PlatformException formException;
  final bool isAccountSend;
  final VoidCallback onLoadBankAccounts;
  final String currency;

  @override
  _BankAccountFormState createState() => _BankAccountFormState();
}

class _BankAccountFormState extends State<BankAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final accountTypes = ['Ahorros', 'Corriente'];

  String credentialType;
  String accountType;
  String currency;
  Ubigeo ubigeo;
  Bank bank;
  bool isOwner = false;
  bool isSubmit = false;
  String isOwnerType;
  String _imageUrl;
  bool _isUploadFile;

  DateTime _dateTime;
  // String _format = 'dd-MMMM-yyyy';
  bool _isBusy = false;
  bool _busyBanks = false;
  //Controllers
  TextEditingController _accountBankCtrl;
  TextEditingController _accountAliasCtrl;
  TextEditingController _nameCtrl;
  TextEditingController _middleNameCtrl;
  TextEditingController _lastNameCtrl;
  TextEditingController _documentNumberCtrl;
  TextEditingController _bithdayCtrl;
  TextEditingController _businessNameCtrl;

  FocusNode _bankFocusNode;
  FocusNode _aliasFocusNode;
  FocusNode _nameFocusNode;
  FocusNode _middleNameFocusNode;
  FocusNode _lastNameFocusNode;
  FocusNode _documentNumberFocusNode;
  FocusNode _bithdayFocusNode;
  FocusNode _businessNameFocusNode;
  FocusNode _rucFocusNode;

  @override
  void initState() {
    super.initState();
    _isUploadFile = false;
    currency = widget.currency;
    _accountBankCtrl = TextEditingController();
    _accountBankCtrl.addListener(_setDefaultTextAlias);
    _accountAliasCtrl = TextEditingController();
    _bithdayCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _middleNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _documentNumberCtrl = TextEditingController();
    _businessNameCtrl = TextEditingController();
    _bankFocusNode = FocusNode();
    _aliasFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _middleNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _documentNumberFocusNode = FocusNode();
    _bithdayFocusNode = FocusNode();
    _businessNameFocusNode = FocusNode();
    _rucFocusNode = FocusNode();
    _dateTime = DateTime.parse(INIT_DATETIME);
  }

  @override
  void dispose() {
    _accountBankCtrl?.dispose();
    _accountAliasCtrl?.dispose();
    _bankFocusNode?.dispose();
    _aliasFocusNode?.dispose();
    _bithdayCtrl?.dispose();
    _nameCtrl?.dispose();
    _middleNameCtrl?.dispose();
    _lastNameCtrl?.dispose();
    _documentNumberCtrl?.dispose();
    _businessNameCtrl?.dispose();
    _nameFocusNode?.dispose();
    _middleNameFocusNode?.dispose();
    _lastNameFocusNode?.dispose();
    _documentNumberFocusNode?.dispose();
    _bithdayFocusNode?.dispose();
    _businessNameFocusNode?.dispose();
    _rucFocusNode?.dispose();
    super.dispose();
  }

  void _handleSubmitForm() {
    _unfocus();
    setState(() {
      isSubmit = true;
      _isBusy = true;
    });
    final FormState _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      final formData = AccountFormData(
        alias: _accountAliasCtrl.text,
        bank: bank.id,
        bankAccountNumber: _accountBankCtrl.text,
        bankAccountType: accountType,
        currencyType: currency,
        isOwner: isOwnerType == 'owner',
        ubigeo: ubigeo.id,
        docType: credentialType,
        docDateCe: _dateTime,
        docNumber: _documentNumberCtrl.text,
        nameThird: _nameCtrl.text,
        fatherLastNameThird: _middleNameCtrl.text,
        motherLastNameThird: _lastNameCtrl.text,
        businessName: _businessNameCtrl.text,
        docImageP: _imageUrl,
      );

      widget.submitForm(formData, _onCompleted, _onError);
    }
  }

  void _unfocus() {
    _bankFocusNode?.unfocus();
    _aliasFocusNode?.unfocus();
  }

  _showSnackBar(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  _onCompleted() {
    setState(() {
      _isBusy = false;
    });
    _showSnackBar("Guardado correctamente");
    widget.onLoadBankAccounts();
    // Navigator.of(context).pop();
    // StoreProvider.of<AppState>(context).dispatch(Navigator.of(context).pop());
  }

  _onError(dynamic error) {
    setState(() {
      _isBusy = false;
    });
    _showSnackBar("${error.message}");
  }

  void _updateIsOwner(bool value) {
    setState(() {
      isOwner = value;
      isOwnerType = value ? 'owner' : 'other';
    });
  }

  Widget _buildMessage() {
    List<Widget> _messagesList = [];
    if (bank != null && bank.cci)
      _messagesList.add(Text(
          "Recuerda que si realizas una transferencia interbancaria, deberás asumir el costo de la misma."));
    if (ubigeo != null && ubigeo.message.trim().isNotEmpty)
      _messagesList.add(Text(ubigeo.message));

    if (bank != null && bank.messageAccount.trim().isNotEmpty)
      _messagesList.add(Text(
        bank.messageAccount,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    if (_messagesList.isEmpty) return Container();
    return Center(
        child: Container(
            color: Colors.yellow,
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                for (var _child in _messagesList) ...[
                  _child,
                  UIHelper.verticalSpaceSmall
                ]
              ],
            )));
  }

  _fetchBanksError(dynamic error) {
    _showSnackBar(error.message);
  }

  _fetchBanksSuccess() {
    setState(() {
      _busyBanks = false;
    });
  }

  _setDefaultTextAlias() {
    List<String> arr = [];
    if (bank != null) arr.add(bank.shortName);
    if (accountType?.isNotEmpty != null) arr.add(accountType);
    if (currency?.isNotEmpty != null) arr.add(currency);
    if (_accountBankCtrl.text?.isNotEmpty != null)
      arr.add(_accountBankCtrl.text);
    if (arr.isNotEmpty) _accountAliasCtrl.text = arr.join(' ');
  }

  Widget _buildAddressField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: _boxDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Ubigeo>(
          value: ubigeo,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Ubigeo newValue) {
            setState(() {
              ubigeo = newValue;
              bank = null;
              _busyBanks = true;
            });
            widget.fetchBanks(
                newValue.id, _fetchBanksSuccess, _fetchBanksError);
          },
          items: widget.ubigeos.map<DropdownMenuItem<Ubigeo>>((Ubigeo ubigeo) {
            return DropdownMenuItem<Ubigeo>(
              value: ubigeo,
              child: Text(ubigeo.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBankField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: _boxDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Bank>(
          isExpanded: true,
          disabledHint: _busyBanks ? Text('Cargando...') : null,
          value: bank,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: _busyBanks
              ? null
              : (Bank newValue) {
                  setState(() {
                    bank = newValue;
                  });
                  _setDefaultTextAlias();
                },
          items: widget.banks.map<DropdownMenuItem<Bank>>((Bank bank) {
            return DropdownMenuItem<Bank>(
              value: bank,
              child: Text(bank.shortName),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAccountTypeField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: _boxDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: accountType,
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
              accountType = newValue;
            });
            _setDefaultTextAlias();
          },
          items: accountTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCurrencyTypeField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: _boxDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: currency,
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
              currency = newValue;
            });
            _setDefaultTextAlias();
          },
          items: currencyType.map<DropdownMenuItem<String>>((Map currency) {
            return DropdownMenuItem<String>(
              value: currency['id'],
              child: Text(currency['title']),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAccountField() {
    return TextFormField(
      controller: _accountBankCtrl,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      focusNode: _bankFocusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa número de cuenta",
        labelText: "Número de cuenta",
      ),
      validator: (value) => helpers.isValidAccountBank(value),
      // controller: _emailTextController,
    );
  }

  Widget _buildAccountAliasField() {
    return TextFormField(
      controller: _accountAliasCtrl,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      focusNode: _aliasFocusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        labelText: "Alias de la cuenta",
      ),
      validator: (value) => helpers.validateText(value),
    );
  }

  Widget _buildCheckboxField() {
    return ListTile(
      // dense: true,
      contentPadding: EdgeInsets.all(0),
      leading: Transform.scale(
        scale: 1.8,
        child: CustomCheckbox(
          activeColor: primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: isOwner,
          onChanged: _updateIsOwner,
        ),
      ),
      title: Text(
        "Certifico que es una cuenta propia.",
      ),
      subtitle: isSubmit && !isOwner
          ? Text('Debe confirmar',
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.red[700],
                  ))
          : null,
    );
  }

  Widget _buildOptionsField() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text('¿A quién pertenece la cuenta?'),
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 'owner',
              groupValue: isOwnerType,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (newValue) {
                setState(() => isOwnerType = newValue);
              },
            ),
            Text('Cuenta propia'),
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 'other',
              groupValue: isOwnerType,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (newValue) {
                setState(() => isOwnerType = newValue);
              },
            ),
            Text('Cuenta de tercero'),
          ],
        ),
      ],
    );
  }

  Widget _buildCredentialTypesFields() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          padding: EdgeInsets.all(8),
          decoration: _boxDecoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: credentialType,
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
                  credentialType = newValue;
                });
              },
              items: credentialTypes(true)
                  .map<DropdownMenuItem<String>>((Map credT) {
                return DropdownMenuItem<String>(
                  value: credT['id'],
                  child: Text(credT['title']),
                );
              }).toList(),
            ),
          ),
        ),
        if (credentialType == 'RUC') ...[
          UIHelper.verticalSpaceMedium,
          _buildBusinessNameField(),
        ],
        if (credentialType != 'RUC') ...[
          UIHelper.verticalSpaceMedium,
          _buildNameTitularField(),
          UIHelper.verticalSpaceMedium,
          _buildMiddleNameTitularField(),
          UIHelper.verticalSpaceMedium,
          _buildLastNameTitularField(),
        ],
        if (credentialType == 'CE') ...[
          UIHelper.verticalSpaceMedium,
          _buildBirthdayTitularField(),
        ],
        if (credentialType == 'PASAPORTE') ...[
          UIHelper.verticalSpaceMedium,
          _buildPassportImage(),
        ],
        UIHelper.verticalSpaceMedium,
        _buildDocumentNumberTitularField(),
      ],
    );
  }

  Widget _buildBusinessNameField() {
    return TextFormField(
      controller: _businessNameCtrl,
      focusNode: _businessNameFocusNode,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa Razón social",
        labelText: "Razón social",
      ),
      validator: (value) => helpers.validateText(value),
      // controller: _emailTextController,
    );
  }

  Widget _buildNameTitularField() {
    return TextFormField(
      controller: _nameCtrl,
      focusNode: _nameFocusNode,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa el nombre del titular",
        labelText: "Nombre del titular de la cuenta",
      ),
      validator: (value) => helpers.validateText(value),
      // controller: _emailTextController,
    );
  }

  Widget _buildMiddleNameTitularField() {
    return TextFormField(
      controller: _middleNameCtrl,
      focusNode: _middleNameFocusNode,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa el primer apellido del titular",
        labelText: "Primer apellido del titular",
      ),
      validator: (value) => helpers.validateText(value),
      // controller: _emailTextController,
    );
  }

  Widget _buildLastNameTitularField() {
    return TextFormField(
      controller: _lastNameCtrl,
      focusNode: _lastNameFocusNode,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: "Ingresa el segundo apellido del titular",
        labelText: "Segundo apellido del titular",
      ),
      validator: (value) => helpers.validateText(value),
      // controller: _emailTextController,
    );
  }

  Widget _buildDocumentNumberTitularField() {
    return TextFormField(
      controller: _documentNumberCtrl,
      focusNode: _documentNumberFocusNode,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: credentialType != 'RUC'
            ? "Ingresa el Número de documento"
            : 'Ingrese RUC',
        labelText: credentialType != 'RUC' ? "Número de documento" : 'RUC',
      ),
      validator: (value) => credentialType != 'RUC'
          ? helpers.validateText(value)
          : helpers.validateRuc(value),
      // controller: _emailTextController,
    );
  }

  Widget _buildBirthdayTitularField() {
    return InkWell(
        onTap: _showDatePicker,
        child: TextFormField(
          readOnly: true,
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
      initialDateTime: _dateTime,
      dateFormat: DATEFORMAT,
      locale: DateTimePickerLocale.es,
      onClose: () => _bithdayCtrl.text = DateFormat('d/MM/y').format(_dateTime),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  _onSuccessFetchFormData(String imageUrl) {
    setState(() {
      _isUploadFile = false;
      _imageUrl = imageUrl;
    });
  }

  _onErrorFetchFormData(PlatformException error) {
    setState(() {
      _isUploadFile = false;
    });
  }

  Future _getImage() async {
    File image = await selectImage(context);

    if (image != null) {
      setState(() {
        _isUploadFile = true;
      });
      // Clean all image cached
      imageCache.clear();
      StoreProvider.of<AppState>(context)
          .dispatch(UploadBanksAccountsPassportAction(
        onError: _onErrorFetchFormData,
        onSuccess: _onSuccessFetchFormData,
        file: image,
      ));
    }
  }

  Widget _buildPassportImage() {
    return _isUploadFile
        ? LinearProgressIndicator()
        : Column(
            children: <Widget>[
              InkWell(
                onTap: _getImage,
                child: Container(
                  height: 40,
                  // width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: _boxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Spacer(),
                      Text(
                        "Subir imagen de pasaporte",
                        style: selectTextStyle,
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Icon(
                        AppIcons.plusCircle,
                        color: Theme.of(context).primaryColor,
                      ),
                      // Spacer(),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpaceSmall,
              Center(
                child: Text('Asegúrate de que el pasaporte se vea nítido'),
              ),
              if (_imageUrl != null && _imageUrl.isNotEmpty) ...[
                UIHelper.verticalSpaceSmall,
                Image.network(_imageUrl)
              ],
            ],
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: FormSubmitButton(
            color: Colors.grey,
            child: Text(
              "Cancelar",
              style: buttonStyle,
            ),
            // loading: vm.isBusy,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        UIHelper.horizontalSpaceLarge,
        Expanded(
          child: FormSubmitButton(
            child: Text(
              "Guardar",
              style: buttonStyle,
            ),
            loading: _isBusy,
            onPressed: _handleSubmitForm,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildMessage(),
            UIHelper.verticalSpaceSmall,
            Align(
              alignment: Alignment.centerLeft,
              child: Text('¿Dónde está domiciliada tu cuenta bancaria?'),
            ),
            UIHelper.verticalSpaceSmall,
            _buildAddressField(),
            UIHelper.verticalSpaceMedium,
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Entidad bancaria'),
            ),
            UIHelper.verticalSpaceSmall,
            _buildBankField(),
            UIHelper.verticalSpaceMedium,
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Tipo de cuenta'),
            ),
            UIHelper.verticalSpaceSmall,
            _buildAccountTypeField(),
            UIHelper.verticalSpaceMedium,
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Tipo de moneda'),
            ),
            UIHelper.verticalSpaceSmall,
            _buildCurrencyTypeField(),
            UIHelper.verticalSpaceMedium,
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Número de cuenta'),
            ),
            UIHelper.verticalSpaceSmall,
            _buildAccountField(),
            UIHelper.verticalSpaceMedium,
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Alias de la cuenta'),
            ),
            UIHelper.verticalSpaceSmall,
            _buildAccountAliasField(),
            UIHelper.verticalSpaceMedium,
            if (widget.isAccountSend) ...[
              _buildCheckboxField(),
              UIHelper.verticalSpaceMedium,
            ],
            if (!widget.isAccountSend) ...[
              _buildOptionsField(),
              UIHelper.verticalSpaceMedium,
            ],
            if (isOwnerType == 'other' && !widget.isAccountSend) ...[
              _buildCredentialTypesFields(),
              UIHelper.verticalSpaceMedium,
            ],
            _buildButton()
          ],
        ),
      ),
    );
  }
}
