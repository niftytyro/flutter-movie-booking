import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/models.dart';
import 'package:provider/provider.dart';
import './screens/Explore/Explore.dart';
import './screens/Booking/Booking.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => MoviesModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  Route _onGenerateRoute(RouteSettings settings) {
    Route page;
    switch (settings.name) {
      case Explore.pathName:
        page = MaterialPageRoute(builder: (context) => Explore());
        break;
      case Booking.pathName:
        page = PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Booking(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var tween = Tween<double>(begin: 0.0, end: 1.0);
              return Stack(
                children: [
                  TweenAnimationBuilder(
                    tween: tween,
                    duration: Duration(milliseconds: 250),
                    builder: (context, value, __) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                                value > 0.7 ? 100.0 - value * 100.0 : 100.0),
                          ),
                          height: value * MediaQuery.of(context).size.height <
                                  50.0
                              ? 50.0
                              : (value * MediaQuery.of(context).size.height),
                          width:
                              value * MediaQuery.of(context).size.width < 50.0
                                  ? 50.0
                                  : (value * MediaQuery.of(context).size.width),
                          child: child,
                        ),
                      );
                    },
                  ),
                ],
              );
            });
        break;
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        String initialRoute = Booking.pathName;
        if (snapshot.connectionState == ConnectionState.done) {
          initialRoute = Explore.pathName;
        } else {
          initialRoute = Booking.pathName;
        }
        return MaterialApp(
          key: ValueKey(initialRoute),
          title: 'Movie Booking',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Mulish',
          ),
          initialRoute: initialRoute,
          onGenerateRoute: this._onGenerateRoute,
          // routes: {
          //   Explore.pathName: (context) => Explore(),
          //   Booking.pathName: (context) => Booking(),
          // },
        );
      },
    );
  }
}
