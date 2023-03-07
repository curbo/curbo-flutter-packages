import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    Key? key,
    this.size = 56,
    this.child,
    this.color = Colors.white,
    this.borderColor = Colors.transparent,
    this.splashColor,
    required this.onPressed,
  }) : super(key: key);

  final double size;
  final Function()? onPressed;
  final Widget? child;
  final Color color;
  final Color? splashColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
          child: InkWell(
            splashColor: splashColor ?? Colors.transparent,
            child: SizedBox(
              width: size,
              height: size,
              child: child,
            ),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
