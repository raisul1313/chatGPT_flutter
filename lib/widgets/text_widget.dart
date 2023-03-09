import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String label;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const TextWidget(
      {Key? key,
      required this.label,
      this.fontSize,
      this.color,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0,8.0,8.0,8.0),
      child: Text(
        textAlign: TextAlign.justify,
        label,
        // textAlign: TextAlign.justify,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
