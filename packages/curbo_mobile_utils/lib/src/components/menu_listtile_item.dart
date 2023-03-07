import 'package:flutter/material.dart';

class MenuListTileItem extends StatelessWidget {
  MenuListTileItem({
    Key? key,
    required this.title,
    required this.onPressed,
    this.titleStyle,
  }) : super(key: key);

  final String title;
  final TextStyle? titleStyle;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Text(
        title,
        style: titleStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 16,
      ),
      onTap: onPressed,
    );
  }
}
