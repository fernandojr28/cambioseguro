import 'package:cambioseguro/helpers/handle_refresh.dart';
import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/user_app.dart';
import 'package:cambioseguro/models/user_data.dart';
import 'package:cambioseguro/presentation/home/account/account_form.dart';
import 'package:cambioseguro/shared/text_styles.dart';
import 'package:cambioseguro/widgets/confirm_account_alert.dart';
import 'package:cambioseguro/widgets/form_submit_button.dart';
import 'package:cambioseguro/widgets/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabAccount extends StatefulWidget {
  const TabAccount({Key key, @required this.currentUser}) : super(key: key);
  final UserApp currentUser;

  @override
  _TabAccountState createState() => _TabAccountState();
}

class _TabAccountState extends State<TabAccount> {
  UserData get userData => widget.currentUser.data;
  TextEditingController _phoneController;

  @override
  void initState() {
    _phoneController = TextEditingController(text: userData.phone);
    super.initState();
  }

  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  @override
  Widget build(BuildContext context) {
    _showMessage() {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Implementación en progreso"),
      ));
    }

    _handleSubmitForm() {
      _showMessage();
    }

    Widget _buildButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: FormSubmitButton(
              child: Text(
                "Guardar",
                style: buttonStyle,
              ),
              // loading: _isBusy,
              onPressed: _handleSubmitForm,
            ),
          )
        ],
      );
    }

    Widget _buildContent() {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Color(0xFFF4F4F4),
                    ),
                    Container(height: 100),
                  ],
                ),
                Positioned.fill(
                  child: Icon(
                    FontAwesomeIcons.userCircle,
                    size: 150,
                    color: Color(0xFF6E46E6),
                  ),
                )
              ],
            ),
            Center(
              child: Text('DNI'),
            ),
            Center(
              child: Text(
                  '${userData.name} ${userData.fatherLastName} ${userData.motherLastName}'),
            ),
            Center(
              child: Text('${userData.email}'),
            ),
            Center(
              child: Text('Datos validados'),
            ),
            UIHelper.verticalSpaceLarge,
            Center(
              child: Text('Número de teléfono'),
            ),
            UIHelper.verticalSpaceSmall,
            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: TextFormField(
                  controller: _phoneController,
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.number,
                  // maxLength: 11,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(FontAwesomeIcons.phoneAlt),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Ingresa teléfono",
                    // labelText: "Teléfono",
                  ),
                  // validator: (value) => helpers.validateRuc(value),
                ),
              ),
            ),
            UIHelper.verticalSpaceLarge,
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _buildButton()),
          ],
        ),
      );
    }

    Widget _buildBody() {
      // final RequestData requestData = StoreProvider.of<AppState>(context).state.
      if (!widget.currentUser.isValidated)
        return AccountForm(
          currentUser: widget.currentUser,
          requestData: null,
          // onRequestChange: ,
        );
      return _buildContent();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _hideKeyboard,
      child: Scaffold(
        floatingActionButton: WhatsappButton(),
        appBar: AppBar(
          title: Text("Mi datos"),
          centerTitle: true,
          bottom: ConfirmAccountAlert(
            currentUser: widget.currentUser,
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () => handleRefresh(context), child: _buildBody()),
      ),
    );
  }
}
