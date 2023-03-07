import 'package:flutter/material.dart';

import '../../../curbo_mobile_utils.dart';

class InfoAlertFullScreenDialog extends StatelessWidget {
  static show(
    BuildContext context, {
    required String title,
    String? subTitle,
    required String description,
    required String buttonTitle,
    required Function() onPressed,
    Color headerColor: Colors.grey,
    Color buttonColor: Colors.blue,
    TextStyle? titleStyle,
    TextStyle? buttonTitleStyle,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return InfoAlertFullScreenDialog(
          title: title,
          subTitle: subTitle,
          description: description,
          buttonTitle: buttonTitle,
          headerColor: headerColor,
          buttonColor: buttonColor,
          titleStyle: titleStyle,
          buttonTitleStyle: buttonTitleStyle,
          onPressed: onPressed,
        );
      },
    );
  }

  InfoAlertFullScreenDialog({
    Key? key,
    required this.title,
    this.subTitle,
    required this.description,
    required this.buttonTitle,
    this.headerColor: Colors.grey,
    this.buttonColor: Colors.blue,
    this.titleStyle,
    this.buttonTitleStyle,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final String description;
  final String buttonTitle;
  final Color headerColor;
  final Color buttonColor;
  final TextStyle? titleStyle;
  final TextStyle? buttonTitleStyle;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTitle(context),
            Divider(thickness: 1.5, height: 1.0),
            _buildSubTitle(context),
            _buildContent(context),
            Spaces.verticalLarge(),
            _buildSeparateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      color: headerColor,
      child: Text(
        title,
        style: titleStyle ??
            TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
      ),
    );
  }

  Widget _buildSubTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: Text(
        subTitle ?? '',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        description,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildSeparateButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: RoundedButton(
          title: buttonTitle,
          colors: [buttonColor],
          style: buttonTitleStyle ??
              TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
          elevation: 0.0,
          onPressed: onPressed,
        ));
  }
}
