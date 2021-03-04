import 'constants.dart' as Constants;
import 'crypto.dart' as Crypto;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_nano/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAccount extends StatelessWidget {
  NewAccount({Key key})
      : _secretKey = Crypto.generateSecretKey(),
        super(key: key);

  final String _secretKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity > 0) Navigator.of(context).pop();
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          Constants.NEW_KEY_ADVICE,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  _secretKey,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: _secretKey));
                                return Fluttertoast.showToast(
                                  msg: 'copied to clipboard',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              },
                              child: const Icon(
                                Icons.copy,
                                color: Constants.BTN_COLOR,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FlatButton(
                          onPressed: () => _showAlertDialog(context),
                          child: const Text(
                            'I agree',
                            style: const TextStyle(
                              fontSize: Constants.BTN_FONT_SIZE,
                              color: Constants.BTN_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
            )),
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
    await prefs.setString(Constants.PREFS_PRIVATE, _secretKey);
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var yes = FlatButton(
          onPressed: () {
            _savePrivateKey();
            Navigator.of(context).pop();
            Navigator.of(context).push(_routeDashboard());
          },
          child: const Text("Yes"),
        );

        var no = FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'No',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        );

        var alert = AlertDialog(
          title: const Text('Proceed?'),
          content: const Text('Did you back up your private key?'),
          actions: [
            no,
            yes,
          ],
        );

        return alert;
      },
    );
  }
}
