import 'constants.dart' as Constants;
import 'crypto.dart' as Crypto;

import 'package:flutter/material.dart';
import 'package:local_nano/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportAccount extends StatefulWidget {
  ImportAccount({Key key}) : super(key: key);

  @override
  _ImportAccountState createState() => _ImportAccountState();
}

class _ImportAccountState extends State<ImportAccount> {
  bool _obscure = true;
  bool _enabled = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() async {
      setState(
        () => _enabled = Crypto.isPrivateKey(_controller.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity < 0) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        Constants.IMPORT_ADVICE,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Center(
                              child: Theme(
                                data: ThemeData(
                                  primaryColor: Colors.redAccent,
                                  primaryColorDark: Colors.red,
                                ),
                                child: TextField(
                                  controller: _controller,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Secret key',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(
                                () => _obscure = !_obscure,
                              ); // toggle obscure text
                            },
                            child: Icon(_obscure
                                ? Icons.lock_outline
                                : Icons.lock_open_outlined),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        onPressed: _enabled
                            ? () {
                                _savePrivateKey();
                                Navigator.of(context).push(_routeDashboard());
                              }
                            : null,
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: Constants.BTN_FONT_SIZE,
                            color: _enabled ? Constants.BTN_COLOR : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Back',
                        style: const TextStyle(
                          fontSize: Constants.BTN_FONT_SIZE,
                          color: Constants.BTN_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _routeDashboard() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Dashboard(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn));
        final fadeAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }

  void _savePrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.PREFS_PRIVATE, _controller.text);
  }
}
