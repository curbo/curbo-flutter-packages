import 'package:flutter/material.dart';

class BubbleText extends StatelessWidget {
  BubbleText(
    this.text, {
    this.textAlign = TextAlign.center,
    this.style,
    this.color,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
  });

  final Color? borderColor;
  final Color? color;
  final String text;
  final TextAlign textAlign;
  final TextStyle? style;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: color ?? Colors.white,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(
              color: borderColor ?? Colors.white,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            textAlign: textAlign,
            style: style,
          ),
        ),
      ),
    );
  }
}
