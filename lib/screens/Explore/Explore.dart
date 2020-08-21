import 'package:flutter/material.dart';
import 'package:movie_booking_app/screens/Explore/BackgroundCarousel.dart';
import 'package:movie_booking_app/screens/Explore/BottomOverlay.dart';
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
        PageController(viewportFraction: 0.7, keepPage: true);
    _foregroundController.addListener(() {
      _backgroundController.position
          .jumpTo(_foregroundController.position.pixels * 1.43);
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
      return Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundCarousel(
              moviesList: moviesList,
              controller: _backgroundController,
            ),
            BottomOverlay(),
            ForegroundCarousel(
              moviesList: moviesList,
              controller: _foregroundController,
              index: index,
            ),
            BuyButton(),
          ],
        ),
      );
    });
  }
}

class BuyButton extends StatelessWidget {
  final TextStyle BuyStyle = const TextStyle(
      color: Color(0xFFFFFFFF), fontSize: 13.0, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 50.0,
              minWidth: constraints.maxWidth * 0.6,
              maxHeight: 50.0,
              maxWidth: constraints.maxWidth * 0.6,
            ),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.black87),
              ),
              color: Colors.black,
              onPressed: () {},
              child: Text(
                'BUY TICKET',
                style: BuyStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}
