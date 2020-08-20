import 'package:flutter/material.dart';

class BottomOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, -20.0),
                  blurRadius: 100.0,
                  spreadRadius: 100.0,
                )
              ],
            ),
            height: 0.2 * constraints.maxHeight,
          );
        },
      ),
    );
  }
}
