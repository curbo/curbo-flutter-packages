import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final List<Color> colors;
  final Color borderColor;
  final Color textColor;
  final double borderSize;
  final String title;
  final TextAlign textAlign;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final TextStyle? style;
  final double? elevation;
  final double borderRadius;
  final Function()? onPressed;
  final double minWidth;
  final double minHeight;
  final double height;
  final MainAxisAlignment rowAlignment;

  RoundedButton({
    required this.colors,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
    this.borderSize = 1.0,
    this.style,
    this.elevation,
    this.borderRadius = 80.0,
    required this.title,
    this.textAlign = TextAlign.center,
    this.rowAlignment = MainAxisAlignment.center,
    this.trailingIcon,
    this.leadingIcon,
    required this.onPressed,
    this.minWidth = 88.0,
    this.minHeight = 48.0,
    this.height = 48.0,
  }) : assert(colors.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    var btnColors = colors;
    var btnBorderColor = borderColor;

    final isGradient = btnColors.length > 1;

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            primary: btnColors.first,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: btnBorderColor,
                style: BorderStyle.solid,
                width: borderSize,
              ),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isGradient ? LinearGradient(colors: btnColors) : null,
              color: isGradient ? null : btnColors.first,
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
            ),
            child: Container(
              constraints: BoxConstraints(
                minWidth: minWidth,
                minHeight: minHeight,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: rowAlignment,
                children: <Widget>[
                  _buildLeadingIcon(),
                  _buildTitle(),
                  _buildTrailingIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: trailingIcon != null ? 24.0 : 0.0,
          right: leadingIcon != null ? 24.0 : 0.0,
        ),
        child: Text(
          title,
          textAlign: textAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: style ??
              TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    return leadingIcon != null
        ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: leadingIcon,
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildTrailingIcon() {
    return trailingIcon != null
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: trailingIcon,
            ),
          )
        : SizedBox.shrink();
  }
}
