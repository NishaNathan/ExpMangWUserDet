import 'package:flutter/material.dart';

class CustomElevatedBtnTwo extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final Color? txtColor;
  final double width;
  final Widget? child;
  final double radius;
  final double fontSize;
  final BorderSide? side;
  final String title;
  final TextStyle? textStyle;

  const CustomElevatedBtnTwo({
    super.key,
    this.side,
    this.width = double.infinity,
    this.height = 48,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.radius = 10,
    this.title = '',
    this.textStyle,
    this.txtColor,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: side,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size(width, height),
        shadowColor: Colors.black54,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: child ??
          Text(
            title,
            maxLines: 2,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontFamily: "poppinsSemiBold"),
          ),
    );
  }
}
