import 'package:flutter/material.dart';

import '../../../curbo_mobile_utils.dart';

class MaterialIconButton extends StatelessWidget {
  const MaterialIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.labelStyle,
    required this.onPressed,
    this.controlAffinity = ListTileControlAffinity.platform,
  }) : super(key: key);

  final Widget icon;
  final String label;
  final TextStyle? labelStyle;
  final Function() onPressed;
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    final labelWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        label,
        style: labelStyle,
      ),
    );

    Widget leading, trailing;

    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = labelWidget;
        trailing = icon;
        break;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        leading = icon;
        trailing = labelWidget;
        break;
    }

    return MaterialButton(
      onPressed: onPressed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      minWidth: 0,
      height: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading,
            Spaces.horizontalSmallest(),
            trailing,
          ],
        ),
      ),
    );
  }
}
