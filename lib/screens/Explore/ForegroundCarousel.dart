import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/models.dart';

class ForegroundCarousel extends StatelessWidget {
  MoviesModel moviesList;
  PageController controller;

  ForegroundCarousel({this.moviesList, this.controller});

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

                children: moviesList.movies.map((movie) {
                  return Container(
                    child: CachedNetworkImage(imageUrl: movie['url']['tile']),
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
