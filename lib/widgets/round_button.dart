import 'package:flutter/material.dart';
import 'package:yoko_mind/theme/color.dart';

class RoundedButton extends StatelessWidget {
  final Function onTap;
  final String label;
  final double width;
  final double height;
  final IconData? icon;
  const RoundedButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.height,
    required this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return icon == null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.outLine,
              fixedSize: Size(width, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () => onTap(),
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: size.height * 0.021,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          )
        : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.outLine,
              fixedSize: Size(width, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            icon: Icon(icon),
            onPressed: () => onTap(),
            label: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: size.height * 0.021,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          );
  }
}
