import 'package:flutter/material.dart';

class FAQpage extends StatelessWidget {
  const FAQpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frequently Asked Questions')),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          children: [
            ExpansionTile(
              title: Text(
                'How do I ?',
                style: TextStyle(fontSize: 17),
              ),
              children: [
                ListTile(
                  title: Text('Lorem ipsum'),
                )
              ],
              onExpansionChanged: (bool expanded) {},
            ),
            ExpansionTile(
              title: Text(
                'How do I ?',
                style: TextStyle(fontSize: 17),
              ),
              children: [
                ListTile(
                  title: Text('Lorem ipsum'),
                )
              ],
              onExpansionChanged: (bool expanded) {},
            )
          ],
        ),
      )),
    );
  }
}
