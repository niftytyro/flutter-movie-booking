import 'package:flutter/material.dart';
import './screens/Explore/Explore.dart';
import './screens/Booking/Booking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Explore.pathName,
      routes: {
        Explore.pathName: (context) => Explore(),
        Booking.pathName: (context) => Booking()
      },
    );
  }
}
