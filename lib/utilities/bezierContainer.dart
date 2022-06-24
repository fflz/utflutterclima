import 'dart:math';

import 'package:flutter/material.dart';

import 'customClipper.dart';

// se trata da curva de bézier https://en.wikipedia.org/wiki/B%C3%A9zier_curve
// https://pub.dev/packages/proste_bezier_curve (tambem dava pra ser usado)

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5,
        child: ClipPath(
          clipper: ClipPainter(),
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.yellow,
                  Colors.orange,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
