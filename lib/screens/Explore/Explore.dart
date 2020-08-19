import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_booking_app/models.dart';

class Explore extends StatelessWidget {
  static const pathName = '/explore';
  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesModel>(
      builder: (context, moviesList, child) {
        return Container(
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return CarouselSlider(
                  options: CarouselOptions(
                      height: constraints.maxHeight,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false),
                  items: moviesList.movies.reversed.map((movie) {
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: Center(
                        child: Image.network(movie['url']['tall']),
                      ),
                    );
                  }).toList(),
                );
              })
            ],
          ),
        );
      },
    );
  }
}
