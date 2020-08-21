import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/models.dart';
import 'package:movie_booking_app/screens/Explore/MovieCard.dart';

class ForegroundCarousel extends StatelessWidget {
  MoviesModel moviesList;
  PageController controller;
  int index;

  ForegroundCarousel({this.moviesList, this.controller, this.index});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight * 0.7,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: this.controller,
                children: moviesList.movies.asMap().entries.map((entry) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 250),
                    opacity: this.index == entry.key ? 1.0 : 0.7,
                    child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 250),
                      tween: Tween<double>(
                          begin: (this.index == entry.key ? 0.8 : 1.0),
                          end: (this.index == entry.key ? 1.0 : 0.8)),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: MovieCard(movie: entry.value),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
