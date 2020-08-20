import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/models.dart';

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
              child: PageView(
                // options: CarouselOptions(
                //   height: constraints.maxHeight * 0.6,
                //   viewportFraction: 0.7,
                //   aspectRatio: 2.0,
                //   enlargeCenterPage: true,
                //   enableInfiniteScroll: false,
                // ),
                scrollDirection: Axis.horizontal,
                controller: this.controller,

                children: moviesList.movies.asMap().entries.map((entry) {
                  return Opacity(
                    opacity: this.index == entry.key ? 1.0 : 0.5,
                    child: Container(
                      child: CachedNetworkImage(
                          imageUrl: entry.value['url']['tile']),
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