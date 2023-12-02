import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:yoko_mind/theme/color.dart';

class HandToHandView extends StatelessWidget {
  const HandToHandView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          height: size.height * .2,
          padding: EdgeInsets.only(bottom: size.height * .05),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QR кодоо уншуулна уу',
                style: TextStyle(
                  color: AppColor.outLine,
                  fontSize: size.height * .02,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * .015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .1),
                child: Text(
                  'Гараас гарт үйлчилгээг баталгаажуулан доорх кодыг уншуулна. Мөн нэг удаа ашиглах боломжтой нууц код үүсгэн ашиглах боломжтой.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.outLine,
                    fontSize: size.height * .016,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomPaint(
                foregroundPainter: BorderPainter(theme: theme),
                child: Container(
                  padding: EdgeInsets.all(size.height * .02),
                  height: size.height * .3,
                  child: PrettyQrView.data(
                    data: "hairtai shuu buldruu min",
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width * .5, size.height * .06)),
                onPressed: () {},
                child: Text(
                  'Нууц код үүсгэх',
                  style: TextStyle(
                    fontSize: size.height * .02,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(size.width * .5, size.height * .06)),
                  onPressed: () {},
                  child: Text(
                    'Багшид мэдэгдэх',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class BorderPainter extends CustomPainter {
  final ThemeData theme;
  BorderPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}

class BorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
