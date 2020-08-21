import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/models.dart';
import 'package:movie_booking_app/screens/Explore/MovieCard.dart';

class ForegroundCarousel extends StatelessWidget {
  MoviesModel moviesList;
  PageController controller;
  double index;

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
                  return Opacity(
                    opacity: 1.0 - ((this.index - entry.key).abs() * 0.25),
                    child: Transform.scale(
                      scale: 1.0 - ((this.index - entry.key).abs() * 0.25),
                      child: MovieCard(movie: entry.value),
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
