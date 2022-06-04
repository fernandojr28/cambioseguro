import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/keys.dart';
import 'package:cambioseguro/models/auth_data.dart';
import 'package:cambioseguro/presentation/auth/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key, @required this.initialTabIndex}) : super(key: key);

  final int initialTabIndex;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  TabController _tabController;
  EmailPasswordSignInFormType formType = EmailPasswordSignInFormType.signIn;
  String email;
  String password;
  bool terms = false;
  String buttonText = "Iniciar sesión";
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(
        length: 2, initialIndex: widget.initialTabIndex, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {});
  }

  void updateFormType(EmailPasswordSignInFormType _formType) {
    formType = _formType;
    switch (_formType) {
      case EmailPasswordSignInFormType.register:
        buttonText = "Registrarme";
        break;
      case EmailPasswordSignInFormType.forgotPassword:
        buttonText = "Enviar";
        break;
      default:
        buttonText = "Iniciar sesión";
    }
    _smoothScrollToTop();
    setState(() {});
  }

  Widget _buildHeader() {
    return Container(
      height: 150,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 26),
            child: Hero(
              tag: AppKeys.logoText,
              child: Image.asset(
                "assets/img/logo.png",
                height: 60,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 40,
      width: 275,
      decoration: BoxDecoration(
          //This is for bottom border that is needed
          border: Border(
              bottom: BorderSide(
        color: Colors.black12,
        width: 5,
      ))),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        indicator: UnderlineTabIndicator(
            insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -5),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 5)),
        unselectedLabelColor: Colors.black54,
        indicatorWeight: 4,
        tabs: <Widget>[
          Tab(
            text: "Personal",
          ),
          Tab(
            text: "Empresarial",
          )
        ],
      ),
    );
  }

  Widget _buildRecoveryTitle() => Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: Text(
            "Recuperar contraseña",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 19),
          ),
        ),
      );
  Widget _buildBody() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          _buildHeader(),
          if (formType != EmailPasswordSignInFormType.forgotPassword)
            _buildTabBar(),
          if (formType == EmailPasswordSignInFormType.forgotPassword)
            _buildRecoveryTitle(),
          if (_tabController.index == 0)
            AuthForm(
              buttonText: buttonText,
              formType: formType,
              updateFormType: updateFormType,
              authType: _tabController.index == 0
                  ? AccountType.Natural
                  : AccountType.Juridica,
              scrollController: _scrollController,
            ),
          if (_tabController.index == 1)
            AuthForm(
              buttonText: buttonText,
              formType: formType,
              updateFormType: updateFormType,
              authType: AccountType.Juridica,
              scrollController: _scrollController,
            ),
        ],
      ),
    );
  }
}
