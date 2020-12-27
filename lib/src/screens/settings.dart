import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:todo_app/src/services/themeStorage.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  final Function(Brightness brightness) changeTheme;

  Settings({Key key, this.changeTheme}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String selectedTheme;

  Map _packageInfo = new Map<String, String>();

  void _setPackageInfo(){
    _packageInfo['version'] = 'v1.0';
  }
 
  @override
  void initState() {
    super.initState();
    _setPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (Theme.of(context).brightness == Brightness.dark) {
        selectedTheme = 'dark';
      } else {
        selectedTheme = 'light';
      }
    });

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Icon(OMIcons.arrowBack),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 36, right: 24),
                  child: buildHeader(context),
                ),
                // Build Theme selector
                buildCard(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'App Theme',
                      style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                    ),
                    Container(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'light',
                          groupValue: selectedTheme,
                          onChanged: handleThemeSelection,
                        ),
                        Text(
                          'Light Theme',
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'ZillaSlab'),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'dark',
                          groupValue: selectedTheme,
                          onChanged: handleThemeSelection,
                        ),
                        Text(
                          'Dark theme',
                          style:
                              TextStyle(fontFamily: 'ZillaSlab', fontSize: 18),
                        )
                      ],
                    )
                  ],
                )),
                // Build about section
                buildCard(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'About app',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'ZillaSlab',
                          color: Theme.of(context).primaryColor),
                    ),
                    Container(
                      height: 40,
                    ),
                    Center(
                        child: Text(
                      'Version'.toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'ZillaSlab',
                          letterSpacing: 1),
                    )),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 4),
                        child: Text(
                          //this.packageInfo.version,
                          _packageInfo['version'],
                          style:
                              TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      'Developed by'.toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'ZillaSlab',
                          letterSpacing: 1),
                    )),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 4),
                        child: Text(
                          'Stef Tweepenninckx',
                          style:
                              TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: OutlineButton.icon(
                        icon: Icon(OMIcons.link),
                        label: Text(
                          'SOURCE',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              letterSpacing: 1,
                              color: Colors.grey.shade500),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () {
                          // TODO set repo public + opengit
                          //openGit();
                        },
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        'Settings',
        style: TextStyle(
            fontFamily: 'ZillaSlab',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  buildCard(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 8),
                color: Colors.black.withAlpha(20),
                blurRadius: 16)
          ]),
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }

  void handleThemeSelection(String value) {
    setState(() {
      selectedTheme = value;
    });
    if (value == 'light') {
      widget.changeTheme(Brightness.light);
    } else {
      widget.changeTheme(Brightness.dark);
    }
    setThemeInLocalStorage(value);
  }

  void openGit() {
    // TODO set repo public
    launch('https://gitlab.com/SteTwe/todo-app');
  }
}
