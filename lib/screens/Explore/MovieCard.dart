import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MovieCard extends StatelessWidget {
  final movie;

  MovieCard({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          height: constraints.maxHeight,
          padding: EdgeInsets.all(0.05 * constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CardImage(
                  movie: movie,
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: 0.6 * constraints.maxHeight,
                    maxWidth: constraints.maxWidth,
                    maxHeight: 0.6 * constraints.maxHeight,
                  )),
              Container(
                height: constraints.maxHeight * 0.25,
                padding: EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CardTitle(
                      title: movie['name'],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: movie['tags'].map<Widget>((tag) {
                        return CardTag(tag: tag);
                      }).toList(),
                    ),
                    CardRating(
                      rating: movie['rating'],
                    ),
                  ],
                ),
              ),
            ],
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
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
      ),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        this.title,
        style: TitleStyle,
      ),
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
