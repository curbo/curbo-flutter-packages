import 'dart:io';

import 'package:flutter/material.dart';

class CircularFileImage extends StatelessWidget {
  CircularFileImage({
    Key? key,
    this.file,
    this.onTap,
    this.width = 60,
    this.height = 60,
    this.fit = BoxFit.cover,
    required this.placeholder,
    required this.errorWidget,
  }) : super(key: key);

  final File? file;
  final BoxFit fit;
  final double width;
  final double height;
  final Function()? onTap;
  final Widget placeholder;
  final Widget errorWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ClipOval(
        child: Material(
          shape: CircleBorder(),
          child: InkWell(
            onTap: onTap,
            child: file != null
                ? Image.file(
                    file!,
                    fit: fit,
                    errorBuilder: (_, __, ___) => errorWidget,
                  )
                : placeholder,
          ),
        ),
      ),
    );
  }
}
