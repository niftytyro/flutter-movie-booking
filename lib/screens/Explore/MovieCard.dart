import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieCard extends StatelessWidget {
  String imageURL;

  MovieCard({this.imageURL});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: CachedNetworkImage(
            imageUrl: imageURL,
          ),
        );
      },
    );
  }
}
