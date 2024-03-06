import "package:flutter/material.dart";
import "package:microbial_source_tracking/src/themes/glwa_theme.dart";

class HowToConfigure extends StatelessWidget {
  const HowToConfigure({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: glwaTheme.secondaryHeaderColor,
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'How to Configure a Device',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
