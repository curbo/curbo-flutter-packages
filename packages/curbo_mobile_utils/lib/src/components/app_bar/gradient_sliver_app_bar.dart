import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class GradientSliverAppBar extends SliverAppBar {
  final List<Color>? colors;

  GradientSliverAppBar({
    this.colors,
    Key? key,
    leading,
    automaticallyImplyLeading = true,
    pinned = false,
    floating = false,
    title,
    actions,
    bottom,
    elevation = 0.0,
    borderRadius,
    shape,
    backgroundColor,
    brightness: Brightness.dark,
    iconTheme,
    actionsIconTheme,
    toolbarTextStyle,
    titleTextStyle,
    primary = true,
    centerTitle = true,
    titleSpacing = NavigationToolbar.kMiddleSpacing,
  }) : super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          pinned: pinned,
          floating: floating,
          title: title,
          actions: actions,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: (colors?.isNotEmpty ?? false)
                  ? LinearGradient(colors: colors!)
                  : null,
              borderRadius: borderRadius,
            ),
          ),
          shape: shape,
          bottom: bottom,
          elevation: elevation,
          backgroundColor: backgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: brightness,
          ),
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          toolbarTextStyle: toolbarTextStyle,
          titleTextStyle: titleTextStyle,
          primary: primary,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
        );
}
