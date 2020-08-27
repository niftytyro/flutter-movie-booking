import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_booking_app/models.dart';

class BackgroundCarousel extends StatelessWidget {
  MoviesModel moviesList;
  PageController controller;
  bool showDetails;
  double index;
  final Function registerTween;
  final AnimationController animationController;
  Animation activeSpringTween;
  Animation inactiveSpringTween;

  BackgroundCarousel({
    this.moviesList,
    this.controller,
    this.showDetails,
    this.index,
    this.registerTween,
    this.animationController,
  }) {
    this.activeSpringTween = this.registerTween(
      startValue: 1.0,
      endValue: 0.0,
      startInterval: 0.100,
      endInterval: 0.900,
      curve: Curves.easeInOutBack,
    );
    this.inactiveSpringTween = this.registerTween(
      startValue: 1.0,
      endValue: 0.0,
      startInterval: 0.200,
      endInterval: 1.0,
      curve: Curves.easeInOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showDetails) {
      bool suffix = false, prefix = false;
      if (this.index.round() - 1 < 0) {
        prefix = true;
      }
      if (this.index.round() + 1 > this.moviesList.movies.length - 1) {
        suffix = true;
      }
      List movies = [];
      if (!prefix) movies.add(this.moviesList.movies[this.index.round() - 1]);
      if (!suffix) movies.add(this.moviesList.movies[this.index.round() + 1]);
      return LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: this.animationController,
            builder: (context, child) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight * 0.5,
                  maxHeight: constraints.maxHeight * 0.5,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (prefix) Spacer(),
                          ...movies.asMap().entries.map((entry) {
                            return Transform.translate(
                              offset: Offset(
                                  0.0,
                                  0.5 *
                                      constraints.maxHeight *
                                      this.inactiveSpringTween.value),
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 100.0,
                                    minHeight: 100.0,
                                    maxWidth: 0.33 * constraints.maxWidth,
                                    maxHeight: 0.5 * constraints.maxHeight,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: CachedNetworkImage(
                                          imageUrl: entry.value['url']['tile']),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          if (suffix) Spacer(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(
                            0.0,
                            0.5 *
                                constraints.maxHeight *
                                this.activeSpringTween.value),
                        child: Transform.scale(
                          scale: 1.5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 100.0,
                              minHeight: 100.0,
                              maxWidth: 0.33 * constraints.maxWidth,
                              maxHeight: 0.5 * constraints.maxHeight,
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                    imageUrl: this
                                            .moviesList
                                            .movies[this.index.round()]['url']
                                        ['tile']),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      return Container(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                reverse: true,
                pageSnapping: false,
                scrollDirection: Axis.horizontal,
                controller: this.controller,
                children: moviesList.movies.map((movie) {
                  if (this.showDetails) {
                    return Transform.translate(
                      offset: Offset(
                          0.0,
                          0.5 *
                              constraints.maxHeight *
                              this.inactiveSpringTween.value),
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 100.0,
                            minHeight: 100.0,
                            maxWidth: 0.33 * constraints.maxWidth,
                            maxHeight: 0.5 * constraints.maxHeight,
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CachedNetworkImage(
                                imageUrl: movie.value['url']['tile']),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100.0,
                            minHeight: 100.0,
                          ),
                          child: CachedNetworkImage(
                              imageUrl: movie['url']['tall']),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            );
          },
        ),
      );
    }
  }
}
