import 'package:flutter/material.dart';
import 'package:mr_invoice/colors.dart';
class TopCurve extends StatelessWidget {

  var headerHeight;
  var headerWidth;

  TopCurve(this.headerHeight, this.headerWidth);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child:
        Container(
          height: headerHeight,
          width: headerWidth,
        ),
      painter: CurvePainter(),

    );
  }
}

class CurvePainter extends CustomPainter{


  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
    path.quadraticBezierTo(size.width*0.30, size.height*0.90, size.width*0.37, size.height*0.85);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.95);
    path.quadraticBezierTo(size.width*0.75, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = darkerCurveShade;
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
