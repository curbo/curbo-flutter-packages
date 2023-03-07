import 'package:flutter/material.dart';
import 'buttons_pages.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialButton(
              color: Colors.blue,
              child: Text(
                'Buttons',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ButtonsPage()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
