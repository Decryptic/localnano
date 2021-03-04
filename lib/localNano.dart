import 'package:flutter/material.dart';
import 'package:local_nano/dashboard.dart';
import 'package:local_nano/importAccount.dart';
import 'package:local_nano/newAccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart' as Constants;

class LocalNano extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Nano',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const int _durationms = 1000;
  static const double _buttonHeight = 80;

  AnimationController _logoController;
  Animation<Offset> _logoOffsetAnimation;

  double _opacity = 0.0;
  String _existingAccount = "";

  void _loadExistingAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var existing = prefs.getString(Constants.PREFS_PRIVATE);
    if (existing != null) {
      setState(() {
        _existingAccount = existing;
      });
    }
  }

  Route _routeNew() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewAccount(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutSine;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route _routeImport() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ImportAccount(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutSine;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
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

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // shared preferences
    _loadExistingAccount();

    // animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: _durationms*2),
      vsync: this,
    )..forward();
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_existingAccount == '') {
            _logoController = AnimationController(
              duration: const Duration(milliseconds: _durationms*2),
              vsync: this,
            )..forward();

            _logoOffsetAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: Offset(0.0, -0.33),
            ).animate(CurvedAnimation(
              parent: _logoController,
              curve: Curves.easeOutExpo,
            ));

            _opacity = 1.0;
          } else {
            _logoController = AnimationController(
              duration: const Duration(milliseconds: _durationms),
              vsync: this,
            )..forward();

            _logoController.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                Navigator.of(context).pop();
                Navigator.of(context).push(_routeDashboard());
              }
            });

            _logoOffsetAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: Offset(0.0, -1.5),
            ).animate(CurvedAnimation(
              parent: _logoController,
              curve: Curves.easeOut,
            ));
          }
        });
      }
    });
    _logoOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.bounceOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity < 0)
          Navigator.of(context).push(_routeNew());
        else if (details.primaryVelocity > 0)
          Navigator.of(context).push(_routeImport());
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _logoOffsetAnimation,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                        child: Image(
                          image: AssetImage('assets/images/localnano.png'),
                        ),
                        onPressed: () async {
                          const url = Constants.WWW_URL;
                          if (await canLaunch(url)) await launch(url);
                        },
                      ),
                    ]),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: _durationms),
                opacity: _opacity,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: _buttonHeight,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(_routeImport());
                          },
                          child: const Text(
                            'Import',
                            style: const TextStyle(
                              fontSize: Constants.BTN_FONT_SIZE,
                              color: Constants.BTN_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: _buttonHeight,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(_routeNew());
                          },
                          child: const Text(
                            'NEW',
                            style: const TextStyle(
                              fontSize: Constants.BTN_FONT_SIZE,
                              color: Constants.BTN_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
