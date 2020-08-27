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

class _ExploreState extends State<Explore> with SingleTickerProviderStateMixin {
  PageController _backgroundController;
  PageController _foregroundController;
  AnimationController _animationController;
  Duration _animationDuration;
  double index = 0.0;
  bool showDetails = false;

  @override
  void initState() {
    this._backgroundController = PageController(keepPage: true);
    this._foregroundController =
        PageController(viewportFraction: 0.7, keepPage: true);
    this._foregroundController.addListener(() {
      this
          ._backgroundController
          .position
          .jumpTo(this._foregroundController.position.pixels * 1.43);
      setState(() {
        this.index = this._foregroundController.page;
      });
    });
    this._animationDuration = Duration(seconds: 1);
    this._animationController = AnimationController(
      duration: this._animationDuration,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    this._backgroundController.dispose();
    this._foregroundController.dispose();
    this._animationController.dispose();
    super.dispose();
  }

  Animation registerTween(
      {startValue = 0.0, endValue = 1.0, startInterval, endInterval, curve}) {
    return Tween<double>(begin: startValue, end: endValue).animate(
      CurvedAnimation(
        parent: this._animationController,
        curve: Interval(
          startInterval,
          endInterval,
          curve: curve,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesModel>(
      builder: (context, moviesList, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              BackgroundCarousel(
                moviesList: moviesList,
                controller: _backgroundController,
                showDetails: this.showDetails,
                index: this.index,
                animationController: this._animationController,
                registerTween: this.registerTween,
              ),
              BottomOverlay(),
              ForegroundCarousel(
                moviesList: moviesList,
                controller: this._foregroundController,
                index: index,
                showDetails: this.showDetails,
                registerTween: this.registerTween,
                animationController: this._animationController,
                onCardTap: () {
                  if (!this.showDetails) {
                    this._animationController.forward();
                    setState(() {
                      this.showDetails = true;
                    });
                  }
                },
                onDragDown: () async {
                  await this._animationController.reverse();
                  setState(() {
                    this.showDetails = false;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    this._backgroundController.animateToPage(
                          this.index.round(),
                          duration: Duration(milliseconds: 100),
                          curve: Curves.ease,
                        );
                  });
                },
              ),
              BuyButton(
                controller: this._animationController,
                registerTween: this.registerTween,
              ),
            ],
          ),
        );
      },
    );
  }
}

class BuyButton extends StatelessWidget {
  final TextStyle buyStyle = const TextStyle(
      color: Color(0xFFFFFFFF), fontSize: 13.0, fontWeight: FontWeight.w700);
  Animation scaleTween;
  final Function registerTween;
  final AnimationController controller;
  BuyButton({this.controller, this.registerTween})
      : this.scaleTween = registerTween(
          startInterval: 0.0,
          endInterval: 0.400,
          curve: Curves.ease,
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: this.controller,
        builder: (_, __) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  constraints: BoxConstraints(
                    minHeight: 50.0,
                    minWidth: constraints.maxWidth *
                        (0.6 + this.scaleTween.value * 0.4),
                    maxHeight: 50.0,
                    maxWidth: constraints.maxWidth *
                        (0.6 + this.scaleTween.value * 0.4),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.05 * constraints.maxWidth),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.black87),
                      ),
                      color: Colors.black,
                      onPressed: () {},
                      child: Text(
                        'BUY TICKET',
                        style: buyStyle,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
