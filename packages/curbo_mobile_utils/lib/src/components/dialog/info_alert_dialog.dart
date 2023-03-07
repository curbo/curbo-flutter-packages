import 'package:flutter/material.dart';

import '../../../curbo_mobile_utils.dart';

class InfoAlertDialog extends StatelessWidget {
  InfoAlertDialog({
    this.image,
    this.title = "",
    required this.message,
    this.confirmTitle = "Ok",
    this.cancelTitle = "Cancel",
    this.onConfirm,
    this.onCancel,
    this.confirmation = false,
    this.disableExecuteActions = false,
    this.textAlign = TextAlign.center,
    this.titleStyle,
    this.messageStyle,
    this.buttonDirection = Axis.horizontal,
  });

  final Image? image;
  final String title;
  final String message;
  final Function? onConfirm;
  final Function? onCancel;
  final String confirmTitle;
  final String cancelTitle;
  final bool confirmation;
  final bool disableExecuteActions;
  final TextAlign textAlign;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final Axis buttonDirection;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildContentDialog(),
          Divider(height: 0.5),
          _buildBottomDialog(context),
        ],
      ),
    );
  }

  Widget _buildContentDialog() {
    final widgets = <Widget>[];

    if (image != null) {
      widgets.addAll([
        Spaces.verticalLarge(),
        SizedBox(
          height: 96.0,
          width: 96.0,
          child: image,
        ),
      ]);
    }

    if (title.isNotEmpty) {
      widgets.addAll([
        Text(
          title,
          textAlign: textAlign,
          style: titleStyle ??
              TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
        ),
        Spaces.verticalMedium(),
      ]);
    }

    widgets.add(
      Text(
        message,
        textAlign: textAlign,
        style: messageStyle ??
            TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: widgets,
      ),
    );
  }

  Widget _buildBottomDialog(BuildContext context) {
    final actions = <Widget>[];

    if (confirmation) {
      actions.add(
        TextButton(
          child: Text(cancelTitle),
          onPressed: () {
            if (!disableExecuteActions) Navigator.pop(context);

            if (onCancel != null) onCancel!();
          },
        ),
      );
    }

    actions.add(
      TextButton(
        child: Text(confirmTitle),
        onPressed: () {
          if (!disableExecuteActions) Navigator.pop(context);

          if (onConfirm != null) onConfirm!();
        },
      ),
    );

    Widget widget = Row(
      mainAxisAlignment: actions.length > 1
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceAround,
      children: actions,
    );

    if (buttonDirection == Axis.vertical) {
      final actionsReserved = actions.reversed.toList();

      widget = ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemCount: actionsReserved.length,
        itemBuilder: (context, index) => actionsReserved[index],
        separatorBuilder: (_, __) => Divider(),
      );
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      child: widget,
    );
  }
}
