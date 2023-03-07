import 'package:flutter/material.dart';

import '../../curbo_mobile_utils.dart';

class InfoView extends StatelessWidget {
  InfoView({
    this.height = 100.0,
    this.image,
    this.title,
    this.description,
    this.titleAction,
    this.actionPressed,
    this.actionTitleColor = Colors.white,
    this.actionColor = Colors.blue,
    this.actionBorderColor = Colors.blue,
    this.actionElevation = 2.0,
    this.titleStyle = const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    ),
    this.descriptionStyle = const TextStyle(
      fontSize: 14.0,
      color: Colors.grey,
    ),
    this.child,
  });

  final double height;
  final Widget? image;
  final String? title;
  final String? description;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final String? titleAction;
  final Color actionTitleColor;
  final Color actionColor;
  final Color actionBorderColor;
  final double actionElevation;
  final Function()? actionPressed;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    if (image != null) children.add(image!);

    if (title?.isNotEmpty ?? false)
      children.addAll([
        Spaces.verticalMedium(),
        Text(
          title ?? '',
          textAlign: TextAlign.center,
          style: titleStyle,
        )
      ]);

    if (child != null) children.add(child!);

    if (description?.isNotEmpty ?? false)
      children.addAll([
        Spaces.verticalMedium(),
        Text(
          description ?? '',
          textAlign: TextAlign.center,
          style: descriptionStyle,
        ),
      ]);

    if (actionPressed != null)
      children.addAll([
        Spaces.verticalMedium(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: RoundedButton(
            elevation: actionElevation,
            colors: [actionColor],
            borderColor: actionBorderColor,
            title: titleAction ?? '',
            textColor: actionTitleColor,
            onPressed: actionPressed,
          ),
        )
      ]);

    return Container(
      constraints: BoxConstraints(minHeight: height),
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
