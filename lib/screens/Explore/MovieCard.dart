import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MovieCard extends StatefulWidget {
  final movie;
  final Function onCardTap;
  final Function onDragDown;
  bool showDetails;
  MovieCard(
      {Key key, this.movie, this.showDetails, this.onCardTap, this.onDragDown})
      : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Duration _animationDuration;
  var imageTween;
  var imageScaleTween;
  var containerScaleTween;

  @override
  void initState() {
    super.initState();
    this._animationDuration = Duration(seconds: 1);
    this._animationController = AnimationController(
      duration: this._animationDuration,
      vsync: this,
    );
    this.containerScaleTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: this._animationController,
        curve: Interval(
          0.0,
          0.400,
          curve: Curves.ease,
        ),
      ),
    );
    this.imageScaleTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: this._animationController,
        curve: Interval(
          0.0,
          0.250,
          curve: Curves.ease,
        ),
      ),
    );
    this.imageTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: this._animationController,
        curve: Interval(
          0.200,
          0.400,
          curve: Curves.bounceInOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            this.widget.onCardTap();
            this._animationController.forward();
          },
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy > 50) {
              this.widget.onDragDown();
              this._animationController.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return OverflowBox(
                minWidth: 0.0,
                minHeight: 0.0,
                maxWidth: screenWidth,
                maxHeight: constraints.maxHeight,
                child: UnconstrainedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    height: constraints.maxHeight,
                    width: constraints.maxWidth +
                        this.containerScaleTween.value *
                            (screenWidth - constraints.maxWidth),
                    padding: EdgeInsets.all(0.05 * constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.0 - (this.imageScaleTween.value),
                          child: CardImage(
                            movie: this.widget.movie,
                            constraints: BoxConstraints(
                              minWidth: (1.0 - this.imageTween.value) *
                                  constraints.maxWidth,
                              minHeight: (0.6 - (this.imageTween.value * 0.6)) *
                                  constraints.maxHeight,
                              maxWidth: (1.0 - this.imageTween.value) *
                                  constraints.maxWidth,
                              maxHeight: (0.6 - (this.imageTween.value * 0.6)) *
                                  constraints.maxHeight,
                            ),
                          ),
                        ),
                        Container(
                          height: constraints.maxHeight * 0.25,
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CardTitle(
                                title: this.widget.movie['name'],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: this
                                    .widget
                                    .movie['tags']
                                    .map<Widget>((tag) {
                                  return CardTag(tag: tag);
                                }).toList(),
                              ),
                              CardRating(
                                rating: this.widget.movie['rating'],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CardRating extends StatelessWidget {
  const CardRating({Key key, @required this.rating}) : super(key: key);

  final rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          rating.toStringAsFixed(1),
        ),
        SmoothStarRating(
          rating: rating * 5 / 10,
          isReadOnly: true,
          size: 20.0,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          starCount: 5,
          allowHalfRating: true,
          spacing: 2.0,
          color: Colors.amber[900],
          borderColor: Colors.amber[900],
        ),
      ],
    );
  }
}

class CardTag extends StatelessWidget {
  const CardTag({Key key, @required this.tag}) : super(key: key);

  final String tag;
  final TextStyle tagStyle =
      const TextStyle(fontSize: 8.0, color: Color(0xFFBDBDBD));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(50.0)),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        tag,
        style: tagStyle,
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final title;
  final TextStyle TitleStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 25.0,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TitleStyle,
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({
    Key key,
    @required this.movie,
    @required this.constraints,
  }) : super(key: key);

  final movie;
  final constraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: FittedBox(
          fit: BoxFit.fill,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 10.0, minWidth: 10.0),
            child: CachedNetworkImage(imageUrl: movie['url']['tile']),
          ),
        ),
      ),
    );
  }
}
