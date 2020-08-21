import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_booking_app/models.dart';

class BackgroundCarousel extends StatelessWidget {
  MoviesModel moviesList;
  PageController controller;

  BackgroundCarousel({this.moviesList, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: PageView(
              reverse: true,
              pageSnapping: false,
              scrollDirection: Axis.horizontal,
              controller: this.controller,
              children: moviesList.movies.map((movie) {
                return FittedBox(
                  fit: BoxFit.fill,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 100.0,
                        minHeight: 100.0,
                      ),
                      child: CachedNetworkImage(imageUrl: movie['url']['tall']),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
