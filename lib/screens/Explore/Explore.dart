import 'package:flutter/material.dart';
import 'package:movie_booking_app/screens/Explore/BackgroundCarousel.dart';
import 'package:movie_booking_app/screens/Explore/ForegroundCarousel.dart';
import 'package:provider/provider.dart';
import 'package:movie_booking_app/models.dart';

class Explore extends StatefulWidget {
  static const pathName = '/explore';

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  PageController _backgroundController;
  PageController _foregroundController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _backgroundController = PageController();
    _foregroundController =
        PageController(viewportFraction: 0.8, keepPage: true);
    _foregroundController.addListener(() {
      print(_foregroundController.offset);
      _backgroundController.position
          .jumpTo(_foregroundController.position.pixels * 1.25);
      setState(() {
        index = _foregroundController.page.round();
      });
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _foregroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesModel>(builder: (context, moviesList, child) {
      return Stack(
        children: <Widget>[
          BackgroundCarousel(
            moviesList: moviesList,
            controller: _backgroundController,
          ),
          ForegroundCarousel(
            moviesList: moviesList,
            controller: _foregroundController,
            index: index,
          ),
        ],
      );
    });
  }
}
