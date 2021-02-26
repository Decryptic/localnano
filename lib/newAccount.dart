import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:math';

import "constants.dart" as Constants;

class NewAccount extends StatelessWidget {
  NewAccount({Key key})
      : _secretKey = _generateSecretKey(),
        super(key: key);

  final String _secretKey;

  static String _intToHex(int a) {
    if (0 <= a && a <= 9)
      return a.toString();
    if (a == 10)
      return "A";
    if (a == 11)
      return "B";
    if (a == 12)
      return "C";
    if (a == 13)
      return "D";
    if (a == 14)
      return "E";
    return "F";
  }

  static String _generateSecretKey() {
    String value = "";
    var rng = Random();
    for (int i = 0; i < 64; i++)
      value = value + _intToHex(rng.nextInt(16));
    return value;
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var yes = FlatButton(
          onPressed: () {},
          child: const Text("Yes"),
        );

        var no = FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
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
                                  _generateSecretKey(),
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
                        SizedBox(height: 50,),
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
}
