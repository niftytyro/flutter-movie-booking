import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MovieCard extends StatefulWidget {
  final movie;
  final Function onCardTap;
  final Function onDragDown;
  final Function registerTween;
  final AnimationController animationController;
  final bool showDetails;
  MovieCard({
    Key key,
    this.movie,
    this.showDetails,
    this.onCardTap,
    this.onDragDown,
    this.registerTween,
    this.animationController,
  }) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  var imageTween;
  var imageScaleTween;
  var containerScaleTween;

  @override
  void initState() {
    super.initState();
    this.containerScaleTween = this.widget.registerTween(
        startInterval: 0.0, endInterval: 0.400, curve: Curves.linear);
    this.imageScaleTween = this.widget.registerTween(
        startInterval: 0.0, endInterval: 0.250, curve: Curves.easeOutBack);
    this.imageTween = this.widget.registerTween(
        startInterval: 0.250, endInterval: 0.400, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            this.widget.onCardTap();
          },
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy > 50) {
              this.widget.onDragDown();
            }
          },
          child: AnimatedBuilder(
            animation: this.widget.animationController,
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
                              if (this.widget.showDetails)
                                Text(
                                  'Director/' + this.widget.movie['director'],
                                ),
                            ],
                          ),
                        ),
                        if (this.widget.showDetails) ...[
                          SizedBox(
                            height: 20.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: CardDetails(movie: this.widget.movie),
                            ),
                          ),
                        ],
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

class CardDetails extends StatelessWidget {
  final movie;
  CardDetails({this.movie});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          shrinkWrap: true,
          primary: true,
          physics: ClampingScrollPhysics(),
          children: [
            CardActors(movie: this.movie),
            SizedBox(height: 40.0),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Introduction',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  this.movie['introduction'],
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CardActors extends StatelessWidget {
  const CardActors({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Actors',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 15.0),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: movie['actors'].asMap().entries.map<Widget>((actor) {
              return Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                      right:
                          actor.key == movie['actors'].length - 1 ? 0.0 : 10.0),
                  child: CardActor(
                    actor: actor,
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}

class CardActor extends StatelessWidget {
  const CardActor({
    Key key,
    this.actor,
  }) : super(key: key);

  final actor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 100.0,
          margin: EdgeInsets.only(bottom: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: actor.value['url'],
            ),
          ),
        ),
        Text(
          actor.value['name'],
          style: TextStyle(fontSize: 10.0),
        ),
      ],
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
  final TextStyle titleStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 25.0,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: titleStyle,
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
