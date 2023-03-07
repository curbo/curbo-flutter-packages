import 'package:curbo_mobile_utils/curbo_mobile_utils.dart';
import 'package:flutter/material.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRondedButton(),
            Spaces.verticalMedium(),
            _buildRondedButtonWithLeadingIcon(),
            Spaces.verticalMedium(),
            _buildRoundedGradientButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRondedButton() {
    return RoundedButton(
      colors: [Colors.transparent],
      borderColor: Colors.blue,
      title: "Button",
      style: TextStyle(color: Colors.blue),
      elevation: 0.0,
      onPressed: () {},
    );
  }

  Widget _buildRondedButtonWithLeadingIcon() {
    return RoundedButton(
      colors: [Colors.blue.shade900],
      title: "With  Icon",
      leadingIcon: Icon(
        Icons.add_a_photo,
        color: Colors.white,
      ),
      onPressed: () {},
    );
  }

  Widget _buildRoundedGradientButton() {
    return RoundedButton(
      colors: [
        Colors.blue.shade300,
        Colors.blue.shade500,
        Colors.blue.shade900,
      ],
      title: "Gradient Button",
      onPressed: () {},
    );
  }
}
