import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:todo_app/src/screens/home.dart';

class SignIn extends StatefulWidget {
  final Function(Brightness brightness) changeTheme;
  final Function(bool val) changeBiometrics;
  final bool signInEnabled;

  const SignIn({Key key, this.changeTheme, this.signInEnabled, this.changeBiometrics}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheck;
    try {
      canCheck = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> available;
    try {
      available = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = available;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating...';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating...';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    if (authenticated) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(changeTheme: widget.changeTheme)));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              buildHeader(context),
              GestureDetector(
                onTap: goToHome,
                child: buildSignInButton(context),
              ),
              Container(
                height: 100,
              )
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  Future<void> goToHome() async {
    if (_canCheckBiometrics) {
      await _getAvailableBiometrics();
      await _authenticate();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(changeTheme: widget.changeTheme,))
      );
    }
  }

  buildSignInButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).canvasColor, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Sign In'.toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                letterSpacing: 1),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          child: Text(
            'Welcome'.toUpperCase(),
            style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontWeight: FontWeight.w700,
                fontSize: 36,
                color: Theme.of(context).primaryColor,
                letterSpacing: 1),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }


}
