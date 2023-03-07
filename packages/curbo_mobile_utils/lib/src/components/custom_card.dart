import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    Key? key,
    this.borderRadius: 8.0,
    this.border,
    this.shadowColor: const Color(0xFF000000),
    this.color = Colors.white,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.child,
    this.onTap,
    this.applyDisableColor: false,
  }) : super(key: key);

  final double borderRadius;
  final BoxBorder? border;
  final Color shadowColor;
  final Color color;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;
  final Function()? onTap;
  final bool applyDisableColor;

  @override
  Widget build(BuildContext context) {
    final clipRRect = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(8),
            offset: Offset(0.0, 2.0),
            blurRadius: borderRadius,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: applyDisableColor
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.color,
              ),
              child: clipRRect,
            )
          : clipRRect,
    );
  }
}
