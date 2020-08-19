import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_booking_app/models.dart';

class Explore extends StatelessWidget {
  static const pathName = '/explore';
  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesModel>(
      builder: (context, cart, child) {
        return Scaffold();
      },
    );
  }
}
