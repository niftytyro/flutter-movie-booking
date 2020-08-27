import 'package:flutter/material.dart';
import 'package:movie_booking_app/screens/Booking/Booking.dart';
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

class BuyButton extends StatefulWidget {
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
  _BuyButtonState createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton>
    with SingleTickerProviderStateMixin {
  final TextStyle buyStyle = const TextStyle(
      color: Color(0xFFFFFFFF), fontSize: 13.0, fontWeight: FontWeight.w700);
  AnimationController _animationController;

  @override
  void initState() {
    this._animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: this.widget.controller,
        builder: (_, __) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedBuilder(
                    animation: this._animationController,
                    builder: (_, __) {
                      double buttonWidth = constraints.maxWidth *
                              (0.6 + this.widget.scaleTween.value * 0.4) -
                          (this._animationController.value *
                              MediaQuery.of(context).size.width);
                      if (buttonWidth < 50.0 + 0.1 * constraints.maxWidth) {
                        buttonWidth = 50.0 + 0.1 * constraints.maxWidth;
                        print(buttonWidth);
                      }
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        constraints: BoxConstraints(
                          minHeight: 50.0,
                          minWidth: buttonWidth,
                          maxHeight: 50.0,
                          maxWidth: buttonWidth,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.05 * constraints.maxWidth),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0 + this._animationController.value * 95.0),
                              side: BorderSide(color: Colors.black87),
                            ),
                            color: Colors.black,
                            onPressed: () {
                              this._animationController.forward();
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                this._animationController.reverse();
                                Navigator.pushNamed(context, Booking.pathName);
                              });
                            },
                            child: Text(
                              buttonWidth > 200.0 ? 'BUY TICKET' : '',
                              style: buyStyle,
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          );
        });
  }
}
