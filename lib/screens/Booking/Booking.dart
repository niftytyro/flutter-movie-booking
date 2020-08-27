import 'package:flutter/material.dart';

class Booking extends StatelessWidget {
  static const pathName = '/booking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  width: constraints.maxWidth,
                  height: 0.3 * constraints.maxHeight,
                ),
                Container(
                  width: constraints.maxWidth,
                  height: 0.45 * constraints.maxHeight,
                ),
                Container(
                  color: Colors.red,
                  width: constraints.maxWidth,
                  height: 0.25 * constraints.maxHeight,
                ),
              ],
            );
          },
        ));
  }
}
