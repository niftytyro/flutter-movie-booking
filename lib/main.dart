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
          routes: {
            Explore.pathName: (context) => Explore(),
            Booking.pathName: (context) => Booking()
          },
        );
      },
    );
  }
}
