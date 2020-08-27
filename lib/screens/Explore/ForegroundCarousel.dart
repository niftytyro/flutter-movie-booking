import 'package:flutter/material.dart';
import 'package:movie_booking_app/models.dart';
import 'package:movie_booking_app/screens/Explore/MovieCard.dart';

class ForegroundCarousel extends StatelessWidget {
  final MoviesModel moviesList;
  final bool showDetails;
  final double index;
  final Function onCardTap;
  final Function onDragDown;
  final Function registerTween;
  final PageController controller;
  final AnimationController animationController;

  ForegroundCarousel({
    this.moviesList,
    this.onCardTap,
    this.showDetails,
    this.index,
    this.onDragDown,
    this.controller,
    this.registerTween,
    this.animationController,
  });

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
                physics:
                    this.showDetails ? NeverScrollableScrollPhysics() : null,
                controller: this.controller,
                children: this.moviesList.movies.asMap().entries.map((entry) {
                  return Opacity(
                    opacity: this.showDetails
                        ? this.index == entry.key ? 1.0 : 0.0
                        : 1.0 - ((this.index - entry.key).abs() * 0.25),
                    child: Transform.scale(
                      scale: 1.0 - ((this.index - entry.key).abs() * 0.25),
                      child: MovieCard(
                        movie: entry.value,
                        showDetails: this.index == entry.key.toDouble()
                            ? this.showDetails
                            : false,
                        registerTween: this.registerTween,
                        animationController: this.animationController,
                        onCardTap: this.onCardTap,
                        onDragDown: this.onDragDown,
                      ),
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
