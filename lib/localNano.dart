import 'constants.dart' as Constants;

import 'package:flutter/material.dart';
import 'package:local_nano/dashboard.dart';
import 'package:local_nano/importAccount.dart';
import 'package:local_nano/newAccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  static const int _durationms = 1000;    // typical duration of animations in milliseconds
  static const double _buttonHeight = 80; // height of the NEW and Import FlatButtons

  String _existingAccount = ""; // initState() will load an existing private key from preferences, if any
  double _opacity = 0.0;        // initial opacity of NEW and Import buttons

  AnimationController _logoController;
  Animation<Offset> _logoOffsetAnimation;

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
    _logoController = AnimationController( // rate at which logo will drop into view
      duration: const Duration(milliseconds: _durationms * 2),
      vsync: this,
    )..forward();

    _logoController.addStatusListener((status) { // after the first animation
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_existingAccount != '') { // DEBUG if no account exists in preferences
            _logoController = AnimationController( // logo will take 2 seconds
              duration: const Duration(milliseconds: _durationms * 2),
              vsync: this,
            )..forward();

            _logoOffsetAnimation = Tween<Offset>( // to translate to the home position
              begin: Offset.zero,
              end: Offset(0.0, -0.33),
            ).animate(CurvedAnimation(
              parent: _logoController,
              curve: Curves.easeOutExpo,
            ));

            _opacity = 1.0; // fade in the NEW and Import buttons
          } else {
            _logoController = AnimationController( // animate the logo out of the frame
              duration: const Duration(milliseconds: _durationms), // in half the time as other animations
              vsync: this,
            )..forward();

            _logoController.addStatusListener((status) { // upon completion
              if (status == AnimationStatus.completed) {
                Navigator.of(context).pop(); // make dashboard the base of the stack
                Navigator.of(context).push(_routeDashboard()); // show the dashboard
              }
            });

            _logoOffsetAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: Offset(0.0, -1.75), // out of the frame
            ).animate(CurvedAnimation(
              parent: _logoController,
              curve: Curves.easeOut,
            ));
          }
        });
      }
    });

    _logoOffsetAnimation = Tween<Offset>( // logo starts
      begin: const Offset(0.0, -1.5), // outside of view, then ends
      end: Offset.zero, // in the middle of the screen
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.bounceOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // detects swipe gestures across the whole homepage view
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity < 0)
          Navigator.of(context).push(_routeNew()); // left is NewAccount
        else if (details.primaryVelocity > 0)
          Navigator.of(context).push(_routeImport()); // right is ImportAccount
      },
      child: Scaffold(
        body: Container( // gradient
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
          child: Column( // buttons and logo
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition( // logo
                position: _logoOffsetAnimation,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Image(
                          image: AssetImage('assets/images/localnano.png'),
                        ),
                        onPressed: () async {
                          const url = Constants.BASE_URL;
                          if (await canLaunch(url)) await launch(url);
                        },
                      ),
                    ]),
              ),
              AnimatedOpacity( // buttons
                duration: const Duration(milliseconds: _durationms),
                opacity: _opacity,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: _buttonHeight,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(context).push(_routeImport()),
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
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(context).push(_routeNew()),
                          child: Text(
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

  void _loadExistingAccount() async { // loads existing account from preferences, if any
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
}
