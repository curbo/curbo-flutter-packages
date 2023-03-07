import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class GradientAppBar extends AppBar {
  final List<Color>? colors;

  GradientAppBar({
    this.colors,
    Key? key,
    leading,
    automaticallyImplyLeading = true,
    title,
    actions,
    bottom,
    elevation = 0.0,
    borderRadius,
    shape,
    backgroundColor,
    brightness: Brightness.dark,
    iconTheme = const IconThemeData(color: Colors.white),
    actionsIconTheme,
    toolbarTextStyle,
    titleTextStyle,
    primary = true,
    centerTitle = true,
    titleSpacing = NavigationToolbar.kMiddleSpacing,
    toolbarOpacity = 1.0,
    bottomOpacity = 1.0,
  }) : super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
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
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
        );
}
